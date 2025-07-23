## auditing
for columns like createdAt, createdBy, updatedAt and updatedBy with the help of annotations

to switch on auditing
1. annotate the base entity with the required fields
```java
@EntityListeners(AuditingEntityListener.class)// required for auditing
@MappedSuperclass  
@Data  
@AllArgsConstructor  
@RequiredArgsConstructor  
public class BaseEntity {  
    @CreatedDate  
    @Column(updatable = false)  
    private LocalDateTime createdAt;  
  
    @LastModifiedDate  
    @Column(insertable = false)  
    private LocalDateTime updatedAt;  
  
    @CreatedBy  
    @Column(updatable = false)  
    private String createdBy;  
  
    @LastModifiedBy  
    @Column(insertable = false)  
    private String updatedBy;  
}
```

but how will the framework know what is the current time and who is logged in?

2. to let JPA know who is logged in we need to implement AuditorAware Interface and register a bean for it
```java
@Component("auditAwareImpl")
public class JwtAuditAwareImpl implements AuditorAware<String> {
    @Autowired
    private HttpServletRequest request;
    @Autowired 
    private Environment env;
    @Override
    public Optional<String> getCurrentAuditor() {
        // Get Authorization header
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            // Extract token
            String token = authHeader.substring(7);
            try {
                // Parse token and extract username
                // This depends on your JWT structure and library
                String username = extractUsernameFromToken(token);
                return Optional.of(username);
            } catch (Exception e) {
                // Log the exception
                return Optional.empty();
            }
        }
        return Optional.empty();
    }
    private String extractUsernameFromToken(String token) {
        // Using JWT library like jjwt
        Claims claims = Jwts.parser()
                .setSigningKey(env.getProperty("jwtsecret")) // Use your actual signing key
                .parseClaimsJws(token)
                .getBody();
        return claims.getSubject(); // Assuming subject contains username
    }
}
```
3. enable auditing by annotating the entry point with the bean we just injected
```java
@SpringBootApplication  
@EnableJpaAuditing(auditorAwareRef = "auditAwareImpl")  
public class AccountsApplication {  
    public static void main(String[] args) {  
       SpringApplication.run(AccountsApplication.class, args);  
    }  
}
```


