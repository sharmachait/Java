#### used when we want to run some code before and after a function is called, like logging.
we are basically trying to intercept function calls before after around or after returning or after throwing
essentially function level middlewares

# AOP jargon
## Aspect - 
some logic thats common in a lot of functions and can be extracted out into a pluggable aspect to run before or after the functions, like logging of calculating how much time the function execution took

## Advice - 
what defines when to run the aspect, when to intercept the control flow around a function

## Pointcut - 
what all methods need to be wrapped in the wrapper that defines the aspect logic, what all functions to intercept

## JoinPoint - 
trigger for the aspect, in spring its always the function call

## Target object - 
bean with the Pointcut method defined in it, the bean whose methods are being intercepted

# Mechanism of AOP
the AOP framework achieves this intercepting behaviour using proxy objects with wrapper methods that wrap the method we defined in the aspects
Spring, instead of giving us a reference to the Bean we defined gives us the reference to the Proxy object instead
This process is called weaving

# Advices

### @Before
### @After
### @AfterReturning
### @AfterThrowing
### @Around

# Initializing AOP
## step 0 adding the dependency
```xml
<dependency>
	<groupID>org.SpringFramework</groupID>
	<artifactID>spring.context</artifactID>
	<version>6.0.8</version>
</dependency>
```
### step 1 - Enable Proxy objects in the AppConfig
```java
@Configuration
@ComponentScan(basePackages = {"com.Project"})
@EnableAspectJAutoProxy
public class AppConfig{

}
```

### step 2 - Create an Aspect component
because we are using @Around we need to use Poroceeding joinpoint
```java
@Aspect
@Component
public class LoggerAspect{
	@Around("execution(* com.beans.*.*(..))")
	public void log(ProceedingJoinPoint JP) throws Thorwable{
		//before logic
		JP.proceed();
		JP.getSignature().toString();
		//after logic
	}
}
```

where the full point cut expression is
```java
	execution(modifier? ret-type declaring-type?name(param)throwing)
```
just a giant regex to match methods
modifier is the access modifier of the method
declaring type is the regex that macher the class of the method

#### an example of @before advice
with before we also get access to the arguments when we define them in the pointcut expression
```java
@Aspect
@Component
public class LoggerAspect{
	@Before("execution(* com.beans.*.*(..)) && args(VehicleStarted,..)")
	public void Check(JoinPoint JP, boolean VehicleStarted){
		if(!VehicleStarted){
			throw new RuntimeException("Not Started");
		}
	}
}
```

Args is another type of point cut used to match methods we certain arguments

if we have multiple aspects for the same method their execution order is random
but we can specify the order
```java
@Aspect
@Component
@Order(1)
public class LoggerAspect{
	@Around("execution(* com.beans.*.*(..))")
	public void log(ProceedingJoinPoint JP) throws Thorwable{
	}
}
```

#### an example of @AfterReturnng advice and @AfterThrowing
```java
@Aspect
@Component
public class LoggerAspect{
	@AfterReturning("execution(* com.beans.*.*(..))", returning="retval")
	public void logStatus(JoinPoint JP, Object retVal){
		Sout(retVal);
	}
}
```

```java
@Aspect
@Component
public class LoggerAspect{
	@AfterThrowing("execution(* com.beans.*.*(..))", thowring="e")
	public void logStatus(JoinPoint JP, Exception e){
		Sout(e.getMessage());
	}
}
```

# creating an aspect to log how much time each method took and another to log the error from each method
```java
@Slf4j
@Aspect
@Component
public class LoggerAspect {
	@Around("execution(* com.sharmachait.wazir..*(..))")
	public Object log(ProceedingJoinPoint jp) throws throwable {
		log.info(jp.getSignature().toString() + " method execution start");
		Instant st = Instant.now();
		
		Object returnObj = jp.proceed(); // null if the method doesnt return anything
		
		Instant fin = Instant.now();
		long timeElapsed = Duration.between(st,fin).toMillis();
		log.info("Time took to execute " + jp.getSignature().toString() + " " + timeElapsed);
		log.info(jp.getSignature().toString() + " method execution end");
		
		return returnObj;
	}
	
	@AfterThrowing(value = "execution(* com.sharmachait.wazir..*(..))")
	public void logException(JoinPoint jp, Exception e){
		log.error(jp.getSignature() + " an exception happened due to " + e.getMessage());
	}
	
}
```

another type of point cut is within instead of execution, simpler to use this when we wan to intercept all methods within a package

```java
@Aspect
@Component
public class LoggerAspect{
	@Around("within(com.beans..*") // any class within com.beans package
	public void log(ProceedingJoinPoint JP) throws Thorwable{
		//before logic
		JP.proceed();
		JP.getSignature().toString();
		//after logic
	}
	@Around("within(com.beans.Store") // only for the Store class in the beans package
	public void log(ProceedingJoinPoint JP) throws Thorwable{
		//before logic
		JP.proceed();
		JP.getSignature().toString();
		//after logic
	}
}
```

to be able to run an Aspect for any class that has a particular annotation we can match that in the point cut as well
for example to run for any service class

```java
@Aspect
@Component
public class LoggerAspect{
	@Around("@within(org.springframework.stereotype.Service")
	public void log(ProceedingJoinPoint JP) throws Thorwable{
		//before logic
		JP.proceed();
		JP.getSignature().toString();
		//after logic
	}
}
```



