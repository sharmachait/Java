# 1 bean name
```java
public class Person{
	private Vehicle veh;
	@Autowired
	public void setVehicle(Vehicle vehicle1){
		this.veh = vehicle;
	}
}
```
the bean with the name vehicle1 will be injected here
# 2 primary bean
by default the bean with the primary annotation is injected
![[Pasted image 20240914120150.png]]
# 3 giving the Autowired variable a qualifier
best way
```java
@Component
public class MyService {
	
    private final ExampleService exampleService;
	
    public MyService(@Qualifier("exampleServiceBean") ExampleService exampleService) {
        this.exampleService = exampleService;
    }
}

```