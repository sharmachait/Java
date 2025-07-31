
- CriteriaBuilder - used to create Queries
	- Predicates to pass into where in Criteria query where user is root that we got from `from(UserDetails.class)`
		- equal
		- notEqual
		- gt - cb.gt(user.get("phone"), 123);
		- ge
		- lt
		- le
	- and or not - we can use these logical operators with multiple predicates, which we get from the above methods
		- cb.and(predicate1, predicate2)
		- cb.or(predicate1, predicate2)
	- like and notLike
		- cb.like(user.get("name"), "S%");
		- cb.notLike(user.get("name"), "S%");
	- in and not in
		- cb.in(user.get("phone")).value(11).value(7);
		- cb.not(user.get("phone")).in(11,7);
	- these methods return a predicate which we can pass into the where method of the criteria query
	- CriteriaQuery
		- from - specifies the table we are fetching from
		- join -  specifies the table we are fetching from
		- multiselect - fetches specified columns
		- Select(root) - fetches full entity
		- where(predicate)
		- Order
		- groupBy()
		- Having()
	- TypedQuery - executes the query
		- getResultList()
		- getSingleResult()
		- setFirstResult(offset) - paginated offset
		- setMaxResults(limit) - pagination limit per page

```java
@Service
public class UserDetailsService{
	
	@PersistenceContext
	private EntityManager entityManager;
	
	public List<UserDetails> getUserDetailsByPhone(Long phoneNo){
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		
		CriteriaQuery<UserDetails> crQuery = cb.createQuery(UserDetails.class); // gives the type of each row
		
		Root<UserDetails> user = crQuery.from(UserDetails.class); // tells where to fetch from
		
		crQuery.select(user); // select *
		// if we only want certain columns we use multiselect and send the fields we want as parameters
		
		Predicate predicate = cb.equal(user.get("phone", phoneNo)); // use the name of the field in the POJO
		crQuery.where(predicate);
		
		TypedQuery<UserDetails> query = entityManager.createQuery(crQuery);
		List<UserDetails> output = query.getResultList();
		
		return output;
	}
}
```
```java
Predicate p1 = cb.equal(user.get("phone"), 123);
Predicate p2 = cb.notEqual(user.get("name"), "me");
Predicate finalp = cb.and(p1, p2);
```

###### Multi Select example

we need to use Object for multi select because we dont have a type with the columns we are selecting

```java
@Service
public class UserDetailsService{
	
	@PersistenceContext
	private EntityManager entityManager;
	
	public List<UserDetails> getUserDetailsByPhone(Long phoneNo){
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		
		CriteriaQuery<Object[]> cr = cb.createQuery(Object[].class);
		
		Root<UserDetails> user = cr.from(UserDetails.class);
		
		cr.multiselect(user.get("name"), user.get("phone"));
		
		Predicate p1 = cb.equal(user.get("phone"), phoneNo);
		cr.where(p1);
		
		TypedQuery<Object[]> q = entityManager.createQuery(cr);
		List<Object[]> results = q.getResultList();
		
		List<UserDTO> output = new ArrayList<>();
		
		for(Object[] r : results){
			String name = (String) row[0];
			String phone = (Long) row[1];
			UserDTO res = new UserDTO(name, phone);
			output.add(res);
		}
		
		return output;
	}
}
```

we can map the fields directly into the UserDTO class with the following, but the DTO must ahve a constructor with all these fields
```java
CriteriaBuilder cb = entityManager.getCriteriaBuilder();

// Use UserDTO.class instead of Object[].class
CriteriaQuery<UserDTO> cr = cb.createQuery(UserDTO.class);
Root<UserDetails> user = cr.from(UserDetails.class);// FROM

// Use cb.construct to map fields to UserDTO constructor
cr.select(cb.construct(UserDTO.class, user.get("name"), user.get("phone"))); // SELECT


Predicate p1 = cb.equal(user.get("phone"), phoneNo); 
cr.where(p1); // WHERE


TypedQuery<UserDTO> q = entityManager.createQuery(cr);
List<UserDTO> output = q.getResultList();  // execute
return output;

```
###### JOINS example
```java
@Service
public class UserDetailsService{
	
	@PersistenceContext
	private EntityManager entityManager;
	
	public List<UserDetails> getUserDetailsByPhone(Long phoneNo){
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		
		CriteriaQuery<Object[]> cr = cb.createQuery(Object[].class);
		
		Root<UserDetails> user = cr.from(UserDetails.class); // from
		
		Join<UserDetails, UserAddres> user_address = user.join("userAddress", JoinType.INNER); // userAddress is the ON in this Join
		
		cr.multiselect(user.get("name"), user_address.get("city"));
		
		Predicate p1 = cb.equal(user.get("phone"), phoneNo);
		cr.where(p1);
		
		TypedQuery<Object[]> q = entityManager.createQuery(cr);
		List<Object[]> results = q.getResultList();
		
		List<UserDTO> output = new ArrayList<>();
		
		for(Object[] r : results){
			String name = (String) row[0];
			String city = (String) row[1];
			UserDTO res = new UserDTO(name, phone);
			output.add(res);
		}
		
		return output;
	}
}
```

for pagination 
on the TypedQuery we can add setFirstResult() for pagination offset and setMaxResults() for page size

```java
TypedQuery<Object[]> q = entityManager.createQuery(cr);
q.setFirstResult(0);
q.setMaxResults(5);
List<Object[]> results = q.getResultList();
```

for sorting we can add orderBy to the criteria query
```java
CriteriaBuilder cb = entityManager.getCriteriaBuilder();
CriteriaQuery<UserDetails> crQuery = cb.createQuery(UserDetails.class);
Root<UserDetails> user = crQuery.from(UserDetails.class);
crQuery.select(user);
Predicate predicate = cb.equal(user.get("phone", phoneNo));

crQuery.orderBy(cb.desc(user.get("name")));
```