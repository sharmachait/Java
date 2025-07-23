# Entity Inheritance in DB

Imagine a scenario where we have an entity that us resource but there are three kinds of resources, Audio Video and Text
should we have three tables?
should we have one table Resource with columns of all the properties? should we have a column that defined the type of resource we are working with?
how to do that with JPA?

![[Pasted image 20241026151958.png]]

## single table strategy
```java
@Data
@Entity
@Inheritance
@DiscriminatorColumn(name = "resource_type")
public class Resource{
	@Id
	@Generated
	private Long id;
	private String name;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@DiscriminatorValue("Video")
public class Video extends Resource{
	private int length;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@DiscriminatorValue("File")
public class File extends Resource{
	private String type;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@DiscriminatorValue("Text")
public class Text extends Resource{
	private String content;
}
```

this will create a single resource table in the database with three columns from the children entity as well, namely length type content
to differentiate the rows of different types from each other we have the discriminator column
we dont have to populate that value. Spring will do it for us. it will create a column named resource_type and populate the discriminator values for us, all we have to do is save a Video type object or file or text
create repositories for the children classes not the parent

## Join table strategy
in this strategy each subclass will have its own table and have a foreign key into the resource table so that we can get the common values out from that table
not suitable when we have to query the entire inheritance hierarchy all the time as joins are slow
doesnt require discriminator column
```java
@Data
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public class Resource{
	@Id
	@Generated
	private Long id;
	private String name;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
public class Video extends Resource{
	private int length;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
public class File extends Resource{
	private String type;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
public class Text extends Resource{
	private String content;
}
```

and thats all we need to do
now when ever we do something like videoRepository.save(video)
it will run two inserts for us

## separate table strategy
3 tables for the 3 types are created
with no common properties fetched out into a 4th table
most efficient queries
good for small number of types or sub classes
```java
@Data
@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public class Resource{
	@Id
	@Generated
	private Long id;
	private String name;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Polymorphism(type = PolymorphismType.EXPLICIT)
public class Video extends Resource{
	private int length;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Polymorphism(type = PolymorphismType.EXPLICIT)
public class File extends Resource{
	private String type;
}

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Polymorphism(type = PolymorphismType.EXPLICIT)
public class Text extends Resource{
	private String content;
}
```

now if we query the resource repository it will create a union on all the tables and thats slow
if we want only the columns related to the resource, and query on resource, we want to exclude Video, file and text from that query
we can do that by mentioning `@Polymorphism(type = PolymorphismType.EXPLICIT)` on top of the sub classes