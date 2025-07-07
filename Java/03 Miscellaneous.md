# Static class can only be nested
# final class can not have children classes

# Abstract class can not be instantiated but do have constructors to server the purpose of super() if a class inherits from it
- abstract methods don't have a body
- abstract methods must be implemented by subclasses
- abstract methods can not be static private or final
- abstract classes can implement interfaces
## ## **Differences between Static and Non-static Nested Classes**

1. A static nested class may be instantiated without instantiating its outer class.
2. Inner classes can access both static and non-static members of the outer class. A static class can access only the static members of the outer class.
```java
OuterClass outerObject = new OuterClass();
OuterClass.InnerClass innerObject = outerObject.new InnerClass();

OuterClass.StaticInnerClass  a = new OuterClass.StaticInnerClass();
```

