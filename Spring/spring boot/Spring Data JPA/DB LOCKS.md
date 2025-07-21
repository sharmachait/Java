Lost updated when in a transaction we take a snapshot of the data and then some other transaction updates it, which our snapshot doesnt have
### lost updates dues to the snapshot view can be handled with DB locks 
In the Spring Data JPA example, several different types of locks are being used. Let's break down each type and their differences
## 1. Optimistic Locking

```sql
ALTER TABLE your_table_name 
ADD COLUMN "version" INTEGER NOT NULL DEFAULT 0;
```
**Implementation:** Uses a `@Version` field in the entity class.

```java
@Entity 
public class Employee {     
	// other fields         
	@Version    
	private Long version; 
}
```

**How it works:**
- Doesn't acquire actual database locks
- When an entity is loaded, JPA tracks its version
- On save/update, JPA verifies the version hasn't changed
- If version has changed, it throws `OptimisticLockingFailureException`
**Best for:** High-concurrency, low-conflict scenarios where most concurrent operations don't modify the same records.

we also need to use the lock annotation for custom queries
```java
@Lock(LockModeType.OPTIMISTIC) 
Optional<Product> findByName(Long id);
```
###### downsides
if any update outside of hibernate omit updating version we may have consistency issues
## 2. Pessimistic Locks
uses database native mechanisms to lock the records
```postgresql
BEGIN;
SELECT * FROM accounts WHERE id = 123 FOR UPDATE;
-- Process data and make changes
-- Other transactions that try to acquire a lock on this row will wait
UPDATE accounts SET balance = balance - 100 WHERE id = 123;
COMMIT;
```
types of pessimistic locks supported by JPA
1. PESSIMISTIC_READ - shared lock prevents data from being updated, allows reading
```java
@Override
@Lock(LockModeType.PESSIMISTIC_READ) 
Optional<Employee> findById(Long id);
```
1. PESSIMISTIC_WRITE - exclusive lock, prevents data from even being read 
```java
@Lock(LockModeType.PESSIMISTIC_WRITE) 
Optional<Employee> findById(Long id);
```
3. PESSIMISTIC_FORCE_INCREMENT - use only if we have a version property in our entity
	1. basically like PESSIMISTIC_WRITE but also maintains a Version property for the record
	2. **Intended use:** It signals to concurrent optimistic transactions that a change has occurred, even if the entity wasn’t strictly modified. This helps in parent-child or aggregate root scenarios to propagate a version increment intentionally

```java
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    // For optimistic locking - find methods with default optimistic locking
    Optional<Employee> findById(Long id);
    
    // For pessimistic locking - explicit methods with lock modes
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @QueryHints({@QueryHint(name = "javax.persistence.lock.timeout", value = "3000")})
    Optional<Employee> findByIdWithPessimisticWriteLock(Long id);
    
    @Lock(LockModeType.PESSIMISTIC_READ)
    Optional<Employee> findByIdWithPessimisticReadLock(Long id);
}
```
`@QueryHints({@QueryHint(name = "javax.persistence.lock.timeout", value = "3000")})` specifies that when executing a database query with this annotation:
1. The lock timeout is set to 3000 milliseconds (3 seconds)
2. If the query attempts to access data that's locked by another transaction, it will wait up to 3 seconds before giving up and throwing an exception
3. ==Pessimistic locks require an active transaction to work properly==
4. The lock must be maintained throughout your business logic until the transaction commits
Here's why this is important:
- Pessimistic locks are held within the scope of a transaction
- Without `@Transactional` on your service method, the lock would be acquired and released immediately after the repository method completes
- **When a non-transactional method (e.g., createOrder()) calls a transactional method (e.g., persistOrder()) within the same class, the call bypasses the proxy and goes directly to the target object. This skips transactional behavior because the proxy isn't involved. Which is why it is good practice to make transaction methods in different classes.**
- this limitation can be by passed with AspectJ bean configuration
- Transactional methods can not be private
- Any subsequent operations would not be protected by the lock

```java
@Service
public class ItemService {
    private final ItemRepository itemRepository;
    @Autowired
    public ItemService(ItemRepository itemRepository) {
        this.itemRepository = itemRepository;
    }
    @Transactional // This is necessary
    public Item updateItem(Long id) {
        Item item = itemRepository.findByIdWithLock(id);
        item.setQuantity(item.getQuantity() - 1);
        return itemRepository.save(item);
    }
}
public interface ItemRepository extends JpaRepository<Item, Long> {    
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT i FROM Item i WHERE i.id = :id")
    Item findByIdWithLock(@Param("id") Long id);
}
```
