## First Level Caching
Its the caching done at the session level for each EntityManager of entities that are not flushed to the data base yet
the caches of the different entity managers are completely isolated from eachother
for each http request a new entity manager is created
###### Request - scoped per HTTP request

## Second Level Caching L2 Caching
This cache is common for all the http requests
![[Pasted image 20250723092546.png]]
shared across different persistence contexts
to enable it
dependencies
```xml
<dependency>  
  <groupId>org.ehcache</groupId>  
  <artifactId>ehcache</artifactId>  
  <version>3.10.8</version>  
</dependency>
<dependency>  
  <groupId>org.hibernate</groupId>  
  <artifactId>hibernate-jcache</artifactId>  
  <version>6.5.2.Final</version>  
</dependency>
<dependency>  
  <groupId>javax.cache</groupId>  
  <artifactId>cache-api</artifactId>  
  <version>1.1.1</version>  
</dependency>
```
properties
```properties
spring.jpa.properties.hibernate.cache.use_second_level_cache=true

# 2. Enable Query Cache (Optional, but recommended)
# Caches the results of queries.
spring.jpa.properties.hibernate.cache.use_query_cache=true

# 3. Specify the JCache (JSR-107) Region Factory
# Tells Hibernate to use a JCache-compliant cache.
spring.jpa.properties.hibernate.cache.region.factory_class=org.hibernate.cache.jcache.JCacheRegionFactory

# 4. Specify the Ehcache JCache Provider
# Points the JCache Region Factory to the Ehcache implementation.
spring.jpa.properties.hibernate.javax.cache.provider=org.ehcache.jsr107.EhcacheCachingProvider
```
Entity
```java
@Entity
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE, region = "userDetailsCache")
public class UserDetails{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
}
```

for different regions we can apply different eviction and cache strategies
in the resources directory create ehcache.xml
```xml
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		 xsi:noNamespaceSchemaLocation="http://www.ehcache.org/ehcache.xsd">

	<cache alias="userDetailsCache"
		   maxElementsInMemory="100"
		   timeToLiveSeconds="60"
		   evictionStrategy="LIFO"/>
	
	<cache alias="orderDetailsCache"
		   maxElementsInMemory="1000"
		   timeToLiveSeconds="200"
		   evictionStrategy="FIFO"/>

</ehcache>
```

##### there are 4 CacheConcurrencyStrategy
these guide how db updated affect our cache
1. READ_ONLY
	1. good for static data
	2. for data that doesnt require updates, if we update will throw exception
	3. stuff like business defined strategies
	4. with read only we wont be able to update the entity in the data base via api call
2. READ_WRITE
	1. good for when we dont want any stale data
	2. where read and writes may happen parallelly
	3. during reads, it acquires shared locks so others can read but not update
	4. during writes it acquires exclusive locks, no one else is allowed to read or write
	5. invalidates the cache when writing to the database, and updates with new data
	6. most commonly used
3. NONSTRICT_READ_WRITE
	1. during read no lock is acquired
	2. during update after transaction cache is invalidated and not updated
	3. good for read heavy operations
	4. there is a chance that reads may be stale if updates happen
4. TRANSACTIONAL
	1. acquires read and write lock, most strict
	2. updates the cache after transaction
	3. any read during cache lock goes directly to DB
	4. any write during lock waits in queue