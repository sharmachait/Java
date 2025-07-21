## Always make a noargs constructor in entity classes
## in the equals and hashcode override methods always handle the case that id could be null

```java
@Data  
@Entity  
@NoArgsConstructor  
@AllArgsConstructor  
public class Book {  
    @Id  
    @GeneratedValue(strategy = GenerationType.AUTO)  
    private Long id;  
    private String title;  
    private String isbn;  
    private String publisher;  
    
    @Override  
    public boolean equals(Object o) {  
        if(this==o) return true;
        if (o == null || getClass() != o.getClass()) return false;  
        Book book = (Book) o;  
        return Objects.equals(id, book.id);
    }  
    @Override  
    public int hashCode() {  
        return id != null ? Objects.hashCode(id) : 0;  
    }
}
```
## Seeding data via command line runner

the code in the run method will run on startup
```java
@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {
    private final BookRepository bookRepository;
    @Override
    public void run(String... args) throws Exception {
        Book book = Book.builder()
                .isbn("#1257826349186519")
                .title("Goodnight Punpun")
                .publisher("Viz media")
                .build();
        Book savedBook = bookRepository.save(book);
        System.out.println(savedBook.getId());
    }
}
```

## Logging SQL application properties

```yml
spring:  
  application:  
    name: jpa  
  jpa:  
    properties:  
      hibernate:  
        show_sql: true  
        format_sql: true  
logging:  
  level:  
    org:  
      hibernate:  
        orm:  
          jdbc:  
            bind: TRACE
```

```log
Hibernate: 
    insert 
    into
        book
        (isbn, publisher, title, id) 
    values
        (?, ?, ?, ?)
2025-01-19T02:07:14.822+05:30 TRACE 39488 --- [jpa] [main] org.hibernate.orm.jdbc.bind              : binding parameter (1:VARCHAR) <- [#1257826349186519]
2025-01-19T02:07:14.822+05:30 TRACE 39488 --- [jpa] [main] org.hibernate.orm.jdbc.bind              : binding parameter (2:VARCHAR) <- [Viz media]
2025-01-19T02:07:14.822+05:30 TRACE 39488 --- [jpa] [main] org.hibernate.orm.jdbc.bind              : binding parameter (3:VARCHAR) <- [Goodnight Punpun]
2025-01-19T02:07:14.822+05:30 TRACE 39488 --- [jpa] [main] org.hibernate.orm.jdbc.bind              : binding parameter (4:BIGINT) <- [1]
```

## Testing only the Database layer
so that our test remain lightweight and all the beans are not created, only the ones being tested are
with **@DataJpaTest** annotation, it will use the H2 in mem database

```java
@DataJpaTest
public class BookRepositoryTest {
  @Autowired
  BookRepository bookRepository;
  @Test
  void testJpaTest(){
    long countBefore = bookRepository.count();
    bookRepository.save(Book.builder()
      .isbn("asfsdf2342")
      .publisher("Penguin")
      .title("white nights")
      .build()
    );
    long countAfter = bookRepository.count();
    assertEquals(1, countAfter-countBefore);
  }
}
```
#### in case of @DataJpaTest the command line runner doesnt seed the data
if we had asserted the the countBefore be 2 that would have failed
#### by default each test is run in a transaction
this can cause some problems 
lets assume we do some inserts in test number one and check the count in test number 2 the second test would fail

```java
@DataJpaTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class BookRepositoryTest {
  
  @Autowired
  BookRepository bookRepository;
  
  @Test
  @Order(1)
  void testJpaTest() {
    long countBefore = bookRepository.count();
    bookRepository.save(Book.builder()
        .isbn("asfsdf2342")
        .publisher("Penguin")
        .title("white nights")
        .build());
    long countAfter = bookRepository.count();
    assertEquals(1, countAfter - countBefore);
  }
  
  @Test
  @Order(2)
  void testCheckCount() {
    long countBefore = bookRepository.count();
    assertEquals(1, countBefore);
  }
  
}
```

this happens because spring boot rolls back all changes made in a test after the test
which is 99% of the time the behavior that we want
to disable the rollback use **@Rollback(value=false)** on top of the method which i also equivalent to **@Commit**
```java
  @Test
  @Order(1)
  @Rollback(value = false)
  void testJpaTest() {
    long countBefore = bookRepository.count();
    bookRepository.save(Book.builder()
        .isbn("asfsdf2342")
        .publisher("Penguin")
        .title("white nights")
        .build());
    long countAfter = bookRepository.count();
    assertEquals(1, countAfter - countBefore);
  }
```

to be able to seed the data in a **@DataJpaTest** we can provide the base package where the class to seed the data with commandlinerunner is and the Test context will read the Bean as well
```java
@DataJpaTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@ComponentScan(basePackages = {"com.sharmachait.jpa.domain.bootstrap"})
public class BookRepositoryTest {}
```
## Hibernate DDL schema generation tool modes

1. **none** - disables schema generation tool
2. **create-only** - Creates database schema
3. **drop** - drops table 
4. **create** - drops database schema and recreates tables
5. **create-drop** - like create but will drop when shutting down aswell
6. **validate** - validates the schema only
7. **update** - updates the schema for changes in the JPA entities
The tool should only be used for non prod environments
for prod use validate or none
manage the database schema externally or apply once with the app and then turn it off with create - validate

## JPA
### primary key types in hibernate

 1. GenerationType.AUTO - lets hibernate decide based on the database
 2. GenerationType.SEQUENCE - db sequences
 3. GenerationType.IDENTITY - auto incremented db columns
 4. GenerationType.TABLE - use db tables to mimic sequence
 5. GenerationType.UUID - best for indexing performance

### sql tips

```sql
-- For existing column
ALTER TABLE table_name 
ALTER COLUMN column_name 
ADD GENERATED BY DEFAULT AS IDENTITY;

-- Or if creating a new table
CREATE TABLE table_name (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    -- other columns
);
```


