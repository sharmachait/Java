# 1 Singleton per application context, but our application can have multiple contexts in that case we will end up having multiple beans
# 2 Prototype - transient per invocation
# 3 Request - scoped per HTTP request
# 4 Session - scoped per HTTP session
# 5 Application - When a bean is defined with _application_ scope, Spring creates only one instance of that bean for the entire lifetime of the web application, useful when you want to share a bean across all components in a web application, regardless of how many Spring contexts are present

## to define the scope of a bean

```java
@Component
@Scope(BeanDefinition.SCOPE_SINGLETON)
public class VehicleService{

}
```
We should not use singleton stateful objects in multithreaded scenario where we want to change the  state
## lazy initialization
we can make the bean initialization lazy with @Lazy
```java
@Component
@Scope(BeanDefinition.SCOPE_SINGLETON)
@Lazy
public class VehicleService{

}
```

lazy initialization can cause runtime exceptions
## Prototype scope
```java
@Component
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class VehicleService{

}
```
for prototype scope the default is lazy initialization
safe to use in multithreaded scenarios
Injected at startup time only if some other singleton bean depends on it, and the instance provided to the singleton object by the IOC container wont be destroyed as long as the singleton object is alive
Inside the singleton class the prototype bean will effectively be singleton
# immutable state classes should be made singleton
# Mutable State classes should be made prototype