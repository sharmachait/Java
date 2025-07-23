1. Application Properties
2. EntityManagerFactory - Data source Object for one data source
3. TransactionManager - one object per data source
4. EntityManager - Session Manager
	1. provides methods to perform CRUD on entitites like persist(), merge(), find(), remove() and createQuery()
	2. all write operations are bounded by transactions, if no transactions throws exception
5. PersistenceContext - Session or the firs level of cache
	1. manages the lifecycle of entities, and caches objects on the basis of sessions
6. Entities - Managed Via JPQL
7. Dialect - The dialect the JDBC driver required to communicate with the DB
8. JDBC driver - database specific   

## Beans we need to inject to be able to use JpaRepositories
Spring boot automatically does that for us
1. DataSource
2. JpaVendorAdapter
3. LocalContainerEntityManagerFactoryBean
4. JpaTransactionManager and PersistenceExceptionTranslationPostProcessor
```java
@Configuration
@EnableTransactionManagement 
@EnableJpaRepositories(basePackages = "com.yourcompany.repositories")
public class AppConfig {
	@Bean
	public DataSource dataSource(){
		HikariDataSource ds = new HikariDataSource();
		ds.setDriverClassName("");
		ds.setJdbcUrl("");
		ds.setUsername("");
		ds.setPassword("");
		return ds;
	}
	@Bean
	public JpaVendorAdapter jpaVendorAdapter(){
		HibernateJpaVendorAdapter adapter = new HibernateJpaVendorAdapter();
		adapter.setGenerateDdl(true);
		adapter.setDatabasePlatform("org.hibernate.dialect.H2Dialect");
		return adapter;
	}
	@Bean
	public LocalContainerEntityManagerFactoryBean entityManagerFactory(
		DataSource ds,
		JpaVendorAdapter jpaVendorAdapter
	){
		LocalContainerEntityManagerFactoryBean emf = new LocalContainerEntityManagerFactoryBean();
		emf.setDataSource(ds);
		emf.setJpaVendorAdapter(jpaVendorAdapter);
		emf.setPackagesToScan("com.yourcompany.domain.model");
		emf.setPersistenceUnitName("UniqueFactoryName");
		return emf;
	}
	@Bean
	public JpaTransactionManager transactionManager(EntityManagerFactory entityManagerFactory){
		return new JpaTransactionManager(entityManagerFactory);
	}
	@Bean 
	public PersistenceExceptionTranslationPostProcessor exceptionTranslation() { 
		return new PersistenceExceptionTranslationPostProcessor(); 
	}
}
```