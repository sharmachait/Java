# custom queries
allowed using three annotations
1. @Query - allows writing queries using JPQL or native SQL
	1. when using native SQL we need to provide `@Query(nativeQuery = true)`
2. @NamedQuery - used to maintain JPQL with names in a single place
3. @NamedNativeQuery - used to maintain native SQL with names in a single place
Named and NamedNative allow us to manage the queries in the entity class itself
### jpql example
queries are written on the Entity instead of the table name
```java
@Query("SELECT c FROM Contact c WHERE c.containsId = ?1 ORDER BY c.createdAt DESC")
List<Contact> findByIdOrderByCreatedDesc(Long id);
```
the ?1 is used to refer to the first parameter being passed to the method
equivalent in derived methods would be
```java
List<Contact> findByContainsIdOrderByCreatedAtDesc(Long id);
```

instead of using ?1 we can also use the name of the parameter directly
```java
@Query("SELECT c FROM c WHERE c.status = :status")
Page<Contact> findByStatus(String status, Pageable pageable);
```

in Native Sql queries we have to use real table names instead of just the model names and also the real column names in the database instead of the field names of the entity class

### update with custom queries
to be able to update insert or delete records in the database with custom queries along with @Query annotation we also need to mention two other annotation
1. @Transactional
2. @Modifying
```java
@Modifying
@Transactional
@Query("UPDATE Contact c SET c.status = ?1 WHERE c.contactId = ?2")
int updateStatusById(String status, int id);
```
this will return the number of rows that were affected

Delete by  - queries dont require @Modifying annotation
```java
@Transactional
void deleteByLastName(String lastName);
```
##### Proxy mode issue
```java
public class Seed implments CommandLineRunner {
	@Override
	public void run(string ...args){
		methodCall();
	}
	@Transactional
	public void methodCall();
}
```
in the above example the transactional annotation doesnt work, because all the beans are created as proxies and AOP is applied to that, so for any method calling a child method of the same class the transactional should be annotated on the parent method not the child
another way to do it would be to extract the methodCall into a bean of its own and inject it here in the commandLineRunner and have transactional there in the bean on it, that way the proxy of the bean will be enough for AOP to apply transactions to it
```java
public class Seed implments CommandLineRunner {
	@Override
	public void run(string ...args){
		methodCall();
	}
}
@Service
public class Method {
	@Transactional
	public void methodCall();
}
```

### NamedQuery & NamedNativeQuery
Named and NamedNative allow us to manage the queries in the entity class itself
the Name of the query is `<Name of Entity>.<Name of method in the repository>`
```java
@Entity
@NamedQeury(name="Contact.findOpenMessages", query="SELECT c FROM Contact c WHERE c.status = :status")
public class Contact extends BaseEntity{

}
```
the NamedNativeQuery annotation also expects the resultClass as a parameter
```java
@Entity
@NamedQeury(name="Contact.findOpenMessages", query="SELECT c FROM Contact c WHERE c.status = :status", resultClass = Contact.class)
public class Contact extends BaseEntity{

}
```
in case of named native query the method in the repository should also have the @query annotation with nativeQuery=true parameter
```java
@Query(nativeQuery = true)
public Contact findOpenMessages(String status);
```

we can have multiple named queries and named native queries with
![[Pasted image 20241022074030.png]]
the methods in the repository can still expect pageable and sort objects as well if we use namedQueries
but if we use named native queries, and want to use pageable as well then we need to write a named native query that counts the number of records for us as well

```java
@SqlResultSetMappings({
@SqlResultSetMapping(name = "SqlResultSetMapping.count" columns = @ColumnResult(name = "cnt"))
})
@NamedNativeQueries({
	@NamedNativeQuery(name = "Contact.findOpenMessages",
		query = "SELECT * FROM contact_msg c WHERE c.status = :status",
		resultClass = Contact.class),
	@NamedNativeQuery(name = "Contact.findOpenMessages.count",
		query = "SELECT count(*) as cnt FROM contact_msg c WHERE c.status = :status",
		resultSetMapping = "SqlResultSetMapping.count"),
})
public class Contact extends BaseEntity {

}
```
where findOpenMessages should be a function  in the Repository that expects a Pageable
