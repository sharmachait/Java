# just like @Transactional @Async wont work if the calling method is in the same class as the @Async method because it also works on AOP
## JPA repositories can work with futures

but we need to @EnableAsync on the main class
```java
@SpringBootApplication
@EnableAsync
public class SpringBootApplication {
	public static void main(String args[]){
		
	}
}
```

```java
public interface BookRepository extends JpaRepository<Book, Long>{
	@Async
	CompleteableFuture<Book> findByName(String Name);
}
```

Can also be done at the service layer
```java
@Service
public class UserService {
    
    private final UserRepository userRepository;
    
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    
    @Async
    public CompletableFuture<User> saveUserAsync(User user) {
        User saved = userRepository.save(user);
        return CompletableFuture.completedFuture(saved);
    }
}
```

This way of Async tasks uses SimpleAsyncTaskExecutor, which creates a new thread every time required
only if we dont have any bean of some executor injected into the IOC container, if we have then Spring boot can use that

@EnableAsync injects a ThreadPoolTaskExecutor for us

its not good practice to use this executor
## Demerits
#### 1. Underutilization of threads
fixed min pool size and too large of a queue, possible that tasks keep waiting in the queue, instead of creating a new thread
#### 2. Thread Exhaustion
since max pool size is too large its possible too many threads are created causing
#### 3. high memory usage

# We should inject our own custom ThreadPoolTaskExecutor with more reasonable constants

```java
@Configration
public class AppConfig{
	@Bean(name="threadPoolExecutorCustom")
	public Executor taskPoolExecutor(){
		int minPoolSize = 2;
		int maxPoolSize = 4;
		int queueSize = 3;
		
		ThreadPoolTaskExecutor exe = new ThreadPoolTaskExecutor();
		exe.setCorePoolSize(minPoolSize);
		exe.setMaxPoolSize(maxPoolSize);
		exe.setQueueCapacity(queuesize);
		exe.setThreadNamePrefix("Custom-Executor-Thread");
		exe.initialize();
		
		return exe
	}
}
```

but the best way to configure executor is to implement AsyncConfigurer so that this executor is set as default
with this way we can use any of the plain java executors maybe even virtual thread executor
```java
@Configuration
public class AppConfig implements AsyncConfigurer {
	private ThreadPoolExecutor poolExecutor;
	@Override
	public synchronized Executor getAsyncExecutor(){
		if(poolExecutor == null){
			int minPoolSize = 2;
			int maxPoolSize = 4;
			int queueSize = 3;
			
			poolExecutor = new ThreadPoolExecutor(
				minPoolSize, 
				maxPoolSize, 
				1, 
				TimeUnit.HOURS, 
				new ArrayBlockingQueue<>(queueSize),
				new CustomThreadFactory()	
			);
			
		}
		return poolExecutor
	}
}

class CustomThreadFactory implements ThreadFactory {
	private final AtomicIntoger threadNumber = new AtomicInteger(1);
	@Override
	public Thread newThread(Runnable r){
		Thread th = new Thread(r);
		th.setName("CustomExecutor-"+threadNumber.getAndIncrement());
		return th;
	}
}
```

# Global ExceptionHandling for Async code

Spring boot framework handles all the async uncaught exceptions by logging it for us on its own

![[Pasted image 20250719161051.png]]
for custom error handling inject an implementation of AsyncUncaughtExceptionHandler
```java
@Configuration
public class AppConfig implements AsyncConfigurer {
	
	@Autowired
	private AsyncUncaughtExceptionHandler asyncUncaughtExceptionHandler;
	
	@Override
	public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler(){
		return this.asyncUncaughtExceptionHandler;
	}
	
}

@Component
class CustomAsyncExceptionHandler implements AsyncUncaughtExceptionHandler {
	@Override
	public void handleUncaughtException(Throwable e, Method method, Object... params){
		// custom logic to handle exception
	}
}
```