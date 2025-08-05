- printf() doesnt print new line we will need to add \n manually if we need a new line
- printf() doesnt print a number to do it we need to give a format specifier
```c
int a = 2;
float gpa = 2.5;
printf("%d\n",a);
printf("%f\n",gpa);
```

### Data types
- int - format specifier `%d`
- float - format specifier `%f`, floats will have 6 digits after the decimal by default
	- to get a specific number of digits use `%.1f`
- double - to get more precision, format specifier `%lf`, with this it will still only print 6 digits, use `%.15lf` to print more numbers after decimal
- char - format specifier `%c`
- `char[]` - format specifier `%s`
```c
char name[] = "bro code";
printf("%s\n", name);
```
- booleans - format specifier `%d`
	- require including a header file
```c
#include <stdio.h>
#include <stdbool.h>

int main(){
	bool b = true;
	printf("%d", b);
	return 0;
}
```

