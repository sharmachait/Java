# custom validations for things like passwords
1. create the annotation interface
```java
@Documented
@Constraint(validatedBy = PasswordStrengthValidator.class)
@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface PasswordValidator{
	String message() default "Please choose a string password";
	Class<?>[] groups() default {};
	Class<? extends Payload>[] payload() default {};
}
```
PasswordStrengthValidator is where the actual logic is implmented
### Example
For example, you might have different classes that implement the `Payload` interface:
```java
class MyPayload implements Payload { /* Implementation */ } 
class AnotherPayload implements Payload { /* Implementation */ }
```
Then you could use the `payload` attribute like this:
```java 
@PasswordValidator(payload = {MyPayload.class, AnotherPayload.class})
```

2. implement the class that has the validation logic
```java
public class PasswordStrengthValidator implements 
		ConstraintValidator<PasswordValidator, String>{
	Set<String> weakPasswords;
	@Override 
	public void initialize(PasswordValidator passwordValidator){
		weakPasswords = new HashSet<>(Arrays.asList("12345", "password", "qwerty"));
	}
	@Override
	public boolean isValid(String password, ConstraintValidatorContext ctx){
		return password!=null && (!weakPasswords.contains(password));
	}
}
```

3. use the annotation
```java
@PasswordValidator
private String pwd;
```
# another example, matching two fields like password and confirm password

if we want to perform validations on two fields the field fieldMatch and the list are required
because it takes two values it need to be mentioned on top of the class with the two values that we need to validate
```java
@Constraint(valdiatedBy = FieldsValueMathValidator.class)
@Target({ ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface fieldsValueMatch{
	String message() default "values dont match";
	Class<?>[] groups() default {};
	Class<? extends Payload>[] payload() default {};
	
	String field();
	String fieldMatch();
	
	@Target({ElementType.TYPE})
	@Retention(RetentionPolicy.RUNTIME)
	@interface List{
		FieldsValueMatch[] value();
	}
}
```

for the fieldsValueMatchValidator 
```java
public class FieldsValueMathValidator implements
		ConstraintValidator<FieldsValueMatch, Object> {
	private String field;//these are just the names of the fields
	private String fieldMatch;
	@Override
	public void initialize(FieldsValueMatch ann){
		this.field = ann.field();
		this.fieldMathc = ann.fieldMathc();
	}
	@Override
	public boolean isValid(Object value, ContrainsValidatorContext ctx){
		Object fieldValue = new BeanWrapperImpl(value).getPropertyValue(field);
			//this is just reflection
		Object fieldMatchValue = new BeanWrapperImpl(value).getPropertyValue(fieldMatch);
		if(fieldValue!=null){
			return fieldValue.equals(fieldValueMatch);
		}
		return fieldValueMatch == null;
	}
}
```

to use this multi value custom validation
```java
@Data
@Entity
@FieldsValueMatch.List({
	@FieldsValueMatch(
		field = "password",
		fieldMatch = "confirmPassword",
		message = "Passwords do not match!"
	),
	@FieldsValueMatch(
		field = "email",
		fieldMatch = "confirmEmail",
		message = "Emails do not match!"
	)
})
public class User {
	private String password;
	@Transient
	private String confirmPassword;
	@Email
	private String email;
	@Email
	@Transient
	private String confirmEmail;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id
}
```
@Transient is used to tell JPA that a field or property in an entity that should not be persisted to the database
