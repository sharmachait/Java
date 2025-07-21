## Liquibase/Flyway migration manager

- Liquibase supports change scripts in SQL, XML, YAML, JSON
- useful when we use multiple type of DB (non relational) along with our main relational database 
- fly way supports only sql and java 

#### liquibase terminology
 
- ChangeSet  - set of changes to be applied to the database
- Change - A single change to be applied
- Changelog - A file which has a list of ChangeSets to be applied
- Preconditions - conditions to control the execution
- Context - An expression to control if the script should run or not
- ChangeLog Parameters - Placeholder which can be replaced at run time

to allow for easy roll backs
keep ChangeSets in one master ChangeLog and there should be one change per changeSet
never modify a change set, instead add a new changeSet after the previous one
use descriptive change set IDs

we can run liquibase with CLI or the Maven plugin, the Maven plugin can generate the ChangeSet for us

we can use the maven plugin by simply adding it to our pom.xml file
1. Create a text file called `changelog.sql` in the `src/main/resources` directory.
2. then (the ampersant in the connection string needs to be escaped)
```xml
<plugin>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-maven-plugin</artifactId>
    <version>4.31.0</version>
    <configuration>
        <changeLogFile>changelog.sql</changeLogFile>
        <url>jdbc:postgresql://localhost:5432/your_database</url>
        <username>${env.DB_USERNAME}</username>
        <password>${env.DB_PASSWORD}</password>
        <driver>org.postgresql.Driver</driver>
    </configuration>
    <dependencies>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <version>42.7.3</version>
        </dependency>
    </dependencies>
</plugin>
```

#### Generating a changelog from the database

```xml
<plugin>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-maven-plugin</artifactId>
    <version>4.31.0</version>
    <configuration>
	    <!-- <changeLogFile>changelog.sql</changeLogFile> -->
        <outputChangeLogFile>changelogOut.sql</outputChangeLogFile>
        <changeSetAuthor>Chaitu</changeSetAuthor>
        <changelogSchemaName>metaversedb</changelogSchemaName>
        <url>jdbc:postgresql://localhost:5432/your_database</url>
        <username>${env.DB_USERNAME}</username>
        <password>${env.DB_PASSWORD}</password>
        <driver>org.postgresql.Driver</driver>
    </configuration>
    <dependencies>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <version>42.7.3</version>
        </dependency>
    </dependencies>
</plugin>
```

To generate the changelog, you'd typically use Maven commands like:
- `mvn liquibase:diff` for schema differences
- `mvn liquibase:generateChangeLog` to create full changelog

maven liquibase goals are essentially just commands to run to do things with liquibase https://docs.liquibase.com/tools-integrations/maven/commands/home.html

#### liquibase best practices

###### ChangeLog directory structure

The most common way to organize your changelogs is by major release. Make certain to store changelogs in your source control, preferably near the database access code.
The following example specifies the directory `com/example/db/changelog`:
```
com 
	example
		db
			changelog 
				db.changelog-root.xml 
				db.changelog-1.0.xml 
				db.changelog-1.1.xml 
				db.changelog-2.0.xml 
			DatabasePool.java 
			AbstractDAO.java
```

we can include all the other logs in the master log, and only the master log is applied, every other log file has be in the same format as the master and has to have changesets
get the syntax from docs
another way to manage change logs is to crate a new file per object (table index) and include those change logs into one master log
like so

```sql
--liquibase formatted sql 
--include file:com/example/news/news.changelog.sql 
--include file:com/example/directory/directory.changelog.sql
```

https://docs.liquibase.com/concepts/bestpractices.html

the changelog generated for us by liquibase can be included as the first baseline changelog in the master 

##### spring boot + liquibase

use the dependency for it from spring initializr
we can then define properties in the applciation.yml for liquibase like
1. spring.liquibase.change-log
2. spring.liquibase.url
3. spring.liquibase.password
4. spring.liquibase.user

when we use JPA/Hibernate IDs it creates a database sequence for us, the database sequence needs to have an initial value, so we need to provide that with liquibase if we are creating our tables and schemas with liquibase, we need to define a change set to insert value into that

https://docs.liquibase.com/change-types/insert.html#sql_example
```sql
insert into hibernate_sequence values (0)
```

liquibase setup proj https://github.com/springframeworkguru/sdjpa-intro/blob/liq-add-table/src/main/resources/db/changelog/changelog-master.xml

while writing queries bear in mind that firstName should be converted to first_name according to hibernate convention
