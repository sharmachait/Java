# Runnable doesnt expect input and doesnt return
### runnable.run
### can be used with executor service
# Runnable + return == Supplier
### supplier.get
# Runnable + input == Consumer
### Consumer.accept
# Consumer + return == Function
### function.apply
# Supplier + Checked exception == Callable
### java.util.concurrent
### callable.call
### use with executor service

# Functional interfaces
**1. Runnable**
```java
Runnable r = () -> System.out.println("Running"); 
r.run();
```
**2. `Supplier<T>`**
```java
Supplier<String> s = () -> "Hello"; 
String result = s.get();

Supplier<String> s = ()->{
	if(true){
		throw new RuntimeException();
	}else{
		return "";
	}
}
```
 we can not throw checked exceptions in suppliers, it will not compile only runtime exceptions
**3. `Consumer<T>`**
```java
Consumer<String> c = t -> System.out.println(t); 
c.accept("Hello");
```
**4. BiConsumer<T, U>**
```java
BiConsumer<String, Integer> bc = (s, i) -> System.out.println(s + i); 
bc.accept("Count: ", 5);
```
**5. Function<T, R>**
```java
Function<Integer, String> f = i -> "Number: " + i; 
String out = f.apply(10);
```
**6. BiFunction<T, U, R>**
```java
BiFunction<Integer, Integer, String> bf = (a, b) -> "Sum: " + (a + b); 
String sum = bf.apply(3, 4);
```
**7. `Predicate<T>`**
```java
Predicate<String> p = s -> s.isEmpty(); 
boolean isEmpty = p.test("");
```
**8. BiPredicate<T, U>**
```java
BiPredicate<String, Integer> bp = (s, i) -> s.length() == i; 
boolean match = bp.test("abc", 3);
```
**9. `UnaryOperator<T>`**  
_(A specialization of Function where input and output are the same type)_
```java
UnaryOperator<Integer> uo = x -> x * x; 
int squared = uo.apply(5);
```
**10. `BinaryOperator<T>`**  
_(A specialization of BiFunction where all types are the same)_
```java
BinaryOperator<Integer> bo = (a, b) -> a + b; 
int sum = bo.apply(2, 3);
```
**11. `Callable<T>`**  
```java
Callable<String> callable = ()->{
	if(true){
		throw new Exception();
	}else{
		return "";
	}
}

try {
    callable.call();
} catch (Exception e) {
    // handle exception
}

```
# Only use runnable and callable with executor service