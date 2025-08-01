Criteria has a lot of boiler plate and duplication of code

Specification gives us an interface with the following methods

1. toPredicate() - abstract method for which we need to override
2. and() - to join specifications logically
3. or()
4. not()

Using this Specification interface we can assemble all the predicates we want in a class

```java
public class UserSpecification {
	public static Specification<UserDetails> equalsPhone(Long phoneNo){
		return (root, query, cb) ->{
			return cb.equal(root.get("phone"), phoneNo);
		}
	}
	
	public static Specification<UserDetails> likeName(String name){
		return (root, query, cb) ->{
			String pattern = "%"+name+"%";
			return cb.equal(root.get("name"), pattern);
		}
	}
	// kind of a hack, specifications are generally only used to do predicates
	public static Specification<UserDetails> joinAddress(){
		return (root, query, cb) ->{
			root.join("userAddress", JoinType.INNER);
			return null;
		}
	}
}
```

and instead of using criteria directly we can use JpaSpecificationExecutor
##### JpaSpecificationExecutor
has the following methods
1. `Optional<T> findOne(Specification<T> spec)`
2. `List<T> finadAll(Specification<T> spec)`
3. `Page<T> findAll(Specification<T> spec, Pageable pageable)`
4. `Boolean exists(Specification<T> spec)`

these functions handle all the boiler plate for us

to use it our repository needs to extend `JpaSpecificationExecutor<T>`
```java
@Repository
public interface UserDetailsRepository extends 
	JpaRepository<UserDetails, Long>, JpaSpecificationExecutor<UserDetails> {
}
```

and in the service class create our specification and use the repository to execute it

```java 
public class UserDetailsService{
	@Autowired
	private UserDetailsRepository repo;
	public List<UserDetails> getUserDetailsByPhone(){
		Specification<UserDetails> spec = Specification.where(UserSpecification.joinAddress())
			.and(UserSpecification.equalsPhone(123l))
			.and(UserSpecification.likeName("AA"));
		return UserDetailsRepository.findAll(spec);
	}
}
```