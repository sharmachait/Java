# Singleton

ways of creating Singleton classes

1. Eager
2. Lazy
3. Lazy with Synchronization block
4. Double Check lock
### Eager

```java
public class DBConnection {
  private static DBConnection conObject = new DBConnection();
  private DBConnection(){}
  public static DBConnection get Instance(){ return conObject; }
}
```

### Lazy

```java
public class DBConnection {
  private static DBConnection conObject = null;
  private DBConnection(){}
  public static DBConnection get Instance(){ 
    if(conObject==null){
      conObject = new DBConnection();
    } 
    return conObject;
  }
}
```

But Lazy is not thread safe

### Lazy with synchronized

```java
public class DBConnection {
  private static DBConnection conObject = null;
  private DBConnection(){}
  synchronized public static DBConnection get Instance(){ 
    if(conObject==null){
      conObject = new DBConnection();
    } 
    return conObject;
  }
}
```

Demerit is that this method blocks other threads

### Double Check lock

```java
public class DatabaseConnection {
  private static volatile DatabaseConnection conObject;
  private DatabaseConnection(){}
  public static DatabaseCOnnection getInstance(){
    if(conObject == null){
      synchronized(DatabaseConnection.class){
        if(conObject == null){
          conObject = new DatabaseConnection();
        }
      }
    }
    return conObject;
  }
}
```

benefit is that synchronized block is entered only once when the variable was initially null

for all other subsequent method calls it wont enter synchronized block

as the variable itself is volatile