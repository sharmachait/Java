## derived query methods 
the method names are made up of introducer and criteria and the two sections are divided by "By"
```java
@Repository
public interface CotactRepository extends CrudRepository<Contact,Integer>{
	List<Contact> findByStatus(String status);
	List<Contact> findByStatusAndDate(String status, String Date);
}
```

JPA repository derived method to check exists by
```java
@Repository  
public interface PatientRepository extends JpaRepository<Patient, UUID> {  
    boolean existsByEmail(String email);  
}
```
### introducers
1. find
2. read
3. query
4. count
5. get
6. distinct - `findDistinctByStatus`
7. exists
we can use distinct to tell JPA to get distinct items in the output like `findDistinctByStatus`
### criteria
any of the entity properties separated by `And` and `Or`

readBy getBy and findBy are equivalent

![[Pasted image 20241002143707.png]]
![[Pasted image 20241002144014.png]]
![[Pasted image 20241002144050.png]]
