just a contract shared between the backend and the frontend
defines the shape of the data

message.proto
```protobuf
syntax="proto3";

message Person {
	string name = 1;
	int32 age = 2;
}
message GetPersonByNameRequest {
	string name = 1;
}
service PersonService {
	rpc AddPerson(Person) returns (Person);
	rpc GetPersonByName(GetPersonByNameRequest) returns (Person);
}
```

the one and two in the above example are known as field numbers they are used for backwards compatibility when we change the order of fields in our message as long as they have the same field number we will be backwards compatible in our contracts

## protobuf data types

### scalar
- int32, int64, uint32, uint64
- float, double
- bool
- string
- bytes
we can also have nested messages

```protobuf
message Address {
	string street = 1;
	string housenumber = 2;
}
message person {
	string name = 1;
	int32 age = 2;
	repeated string phoneNumber = 3;
	Address address = 4;
}
```
we can also have arrays of the types using the repeated keyword
### enum
```protobuf
enum PhoneType {
	MOBILE = 0;
	LANDLINE = 1;
}
message PhoneNumber {
  string number = 1;
  PhoneType type = 2;
}
```
enum can be used in another message
while compressing we only need to give 0 or 1 the library will take care of replacing it with MOBILE or LANDLINE
### maps
```protobuf
message MapName {
	map<string, int32> id_to_age = 1;
}
```

# Generating Stubs
> mvn compile 