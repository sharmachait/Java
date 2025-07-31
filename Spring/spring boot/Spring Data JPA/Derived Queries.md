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

## Nested Objects
```java
@Entity
public class Person {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @ManyToOne(cascade = CascadeType.ALL)
    private Address address;

    // Getters and setters
}
@Entity
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String street;
    private String city;
    private String zipCode;

    // Getters and setters
}
public interface PersonRepository extends JpaRepository<Person, Long> {

    // This method will find all Person entities that have an Address with the specified city.
    List<Person> findByAddressCity(String city);

    // You can also combine conditions
    List<Person> findByNameAndAddressCity(String name, String city);

    // To avoid ambiguity with property names, you can also use an underscore
    // to separate the properties, though this is less common for simple traversals.
    List<Person> findByAddress_City(String city);
}

```