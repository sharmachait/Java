
Supports group-based validation, so you can apply different sets of constraints based on the context (e.g., one set for creation, another for updates).

lets say we have a POST controller that expects all the fields
and we have a PUT controller that doesnt expect the registration-date field

and we are using the same DTO in both the controllers

if we add a @Valid annotation in both the controllers that wont work because Registered date will have @NotNull for the POST controller Request Body

but it will be null for the PUT controller Request Body

so we need a way to perform a different kind of validation for the PUT controller than for the POST controller

## 1. create an interface to be able to mark groups
```java
public interface CreatePatientValidationGroup {  
}
```
## 2. mark the properties validations with the group they need to be triggered for
```java
public class PatientRequestDTO {  
	  
	@NotBlank(message = "Name is required")  
	@Size(max = 100, message = "Name cannot exceed 100 characters")  
	private String name;  
	  
	@NotBlank(message = "Email is required")  
	@Email(message = "Email should be valid")  
	private String email;  
	  
	@NotBlank(message = "Address is required")  
	private String address;  
	  
	@NotBlank(message = "Date of birth is required")  
	private String dateOfBirth;  
	  
	@NotBlank(groups = CreatePatientValidationGroup.class,  
	        message = "Registered date is required")  
	private String registeredDate;
}
```
## 3. trigger the required set of validations in the required places
```java
@PostMapping  
public ResponseEntity<PatientResponseDTO> createPatient(  
        @Validated({Default.class, CreatePatientValidationGroup.class}) @RequestBody PatientRequestDTO patientRequestDTO  
) {  
    PatientResponseDTO patientResponseDTO = patientService.createPatient(patientRequestDTO);  
    return ResponseEntity.ok().body(patientResponseDTO);  
}
  
@PutMapping("/{id}")  
public ResponseEntity<PatientResponseDTO> createPatient(  
        @PathVariable UUID id,  
        @Validated({Default.class}) @RequestBody PatientRequestDTO patientRequestDTO  
) {  
    PatientResponseDTO patientResponseDTO = patientService.updatePatient(id, patientRequestDTO);  
    return ResponseEntity.ok().body(patientResponseDTO);  
}
```

# Validations do not automatically apply to the nested objects
use @Valid annotation on top of child fields
```java
public class Parent {

    @Valid // This enables validation of the nested Child object
    @NotNull(message = "Child cannot be null")
    private Child child;

    // getters and setters
}

public class Child {

    @NotBlank(message = "Name cannot be empty")
    private String name;

    // getters and setters
}
```