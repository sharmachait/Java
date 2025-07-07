# Immutable classes in java

1. make the class final
2. make all the properties private and final
3. make a parameterized constructor to initialize fields as deep copies so the passed referenced object update doesn't affect the class
4. no setters
5. in the getters return a deep copy / immutable version of the property

```java
final class Student {
  private final String name;
  private final int regNo;
  private final Map<String, String> metadata;
  public Student(String name, int regNo, Map<String, String> metadata){
    this.name = name;
    this.regNo = regNo;
    this.metadata = Map.copyOf(metadata);
  }
  public String getName(){return name;}
  public int getRegNo(){return regNo;}
  public Map<String, String> getMetadata(){return metadata;}
}
```