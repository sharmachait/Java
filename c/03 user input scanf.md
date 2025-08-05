scanf needs the address of the variable to be passed int which we can do with `&` ampersand 
```c
int main() {  
    int a=0;  
    float b=0.0;  
    char c='\0';  
    char d[30]="";  
  
    scanf("%d", &a);  
    scanf("%f", &b);  
    scanf("%c", &c);  
    scanf("%s", d);  
  
    printf("%d\n", a);  
    printf("%f\n", b);  
    printf("%c\n", c);  
    printf("%s\n", d);  
    return 0;  
}
```

this doesnt work as expected
because when we press enter after entering a float the new line character remains in the buffer and is read into the variable c

to fix it 
```c
scanf(" %c", &c); // Note the space before %c!
```
the empty space tells it to skip any empty space in the buffer 
wont work if we want to read an empty space potentially

best way is to use getchar() to consume the left over new line

```c
int main() {  
    int a=0;  
    float b=0.0;  
    char c='\0';  
    char d[30]="";  
  
	scanf("%d", &a);
	scanf("%f", &b);
	getchar();          // Only before reading the character
	scanf("%c", &c);
	scanf("%s", d);

    printf("%d\n", a);  
    printf("%f\n", b);  
    printf("%c\n", c);  
    printf("%s\n", d);  
    return 0;  
}
```

### issues with scanf and strings
1. scanf cant read empty spaces, so it stops reading after the first ' ' 
2. we should not pass in the char array with &, arrays already are references to memory addresses
for strings we should use fgets instead
```c
fgets(name, sizeof(name), stdin);
```
fgets does clean up the new line after itself (matter of fact we have that new line character as part of name) 

but only if there is enough space in the name char array for it


```c
int main() {  
    char c='\0';  
    char d[2]="";  
    fgets(d, sizeof(d), stdin);  
    scanf("%c", &c );  
  
    printf("%s\n", d);  
    return 0;  
}
```

this works only only if we enter a single character for name if we enter 2 and then press enter it will put that new line character into the variable c

```c
int main() {  
    char c='\0';  
    char d[2]="";  
    char e='\0';  
    
    fgets(d, sizeof(d), stdin);  
    scanf("%c", &c );  
    scanf("%c", &e );  
  
    printf("%s\n", d);  
    printf("%c\n", c);  
    printf("%c\n", e);  
    return 0;  
}
```

```output
sss

s
s
s
```

fgets also requires a `getchar()` before itself we there is an new line character in the buffer from the previous user input

we can clear the new line character from 
`fgets(name, sizeof(name), stdin)`
the name variable in by setting it to '\0'

but to do it we need to know the length of the string and for that we will include the string header file to perform string functions
it gives us functions like `strlen()` 
```c
fgets(name, sizeof(name), stdin);
name[strlen(name) - 1] = '\0';
```

# strlen() vs sizeof()
strlen returns the length of the string
sizeof returns the size of the array in bytes and not the length of the string, which we give to it at the time of declaration `char name[30]`

strlen() calculates the length of the string only up till the '\0' character as it serves as a terminator