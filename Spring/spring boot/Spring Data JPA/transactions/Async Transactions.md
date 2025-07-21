# Best way to use
call the transactional method from an async method
```java
@Component
public class UserService {
	@Autowired
	UserUtility userUtility;
	@Async
	public CompletableFuture<String> updateUserAsync(){
		userUtility.updateUserTransaction();
		return CompletableFuture.completedFuture("user updated");
	}
}
@Component
public class UserUtility{
	@Transactional
	public void updateUserTransaction(){}
}
```

1. Transactional -> Async, bad, context is not carried forward 
2. Transactional + Async, bad, new transaction always
3. Async -> Transactional, Best way

if from a transactional method we call an Async method the transactional context is not passed to it, so it wont run in the transaction

```java
@Component
public class UserService {
	@Autowired
	UserUtility userUtility;
	@Transactional
	public void updateUser(){
		// step 1
		// step 2
		userUtility.updateUserBalance();
	}
}
@Component
public class UserUtility {
	@Async
	public void updateUserBalance(){}
}
```

we can not expect the above method to run in a transaction

a work around is that the service method that is transactional should it self be asynchronous
```java
@Component
public class UserService {
	@Async
	@Transactional
	public void updateUser(){
		// step 1
		// step 2
		userUtility.updateUserBalance();
	}
}
```

but there is an issue with this as well
if this method is called from another transactional method and the propagation level uses the parent transaction, because of the async annotation the transactional context wont be carried forward to this method
only REQUIRES_NEW is safe in that case
in all other cases a new transaction will be created in the new thread


