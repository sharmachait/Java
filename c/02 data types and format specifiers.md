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
char name[4]; // string of size 4 only allowed
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
when we dont assign any value to any variable
the default is garbage value that is any value that was at that memory location by, perhaps, some other program that is now free to use
```c
int main() {   
	int a;  
    float b;  
    char c;  
    char d[30];  
    return 0;  
}
```
**%% so its good practice to always assign some default values to variables %%** 
traditionally char is set to '\0' the null character and the string to an empty string
# format specifiers
character defines the data type
we can also give it modifiers for width, precision and flags

- d = decimal/int
- f = float
- lf - long float double
- c - character
- s - strings

## width
minimum number of characters to print, `%3d` prints 3 characters, `%-3d` justifies them to the left
```c
int a = 1;
int b = 10;
int c = 100;

printf("%3d\n", a); // "__1"
printf("%3d\n", b); // "_10"
printf("%3d\n", b); // "100"

printf("%-3d\n", a); // "1__"
printf("%-3d\n", b); // "10_"
printf("%-3d\n", b); // "100"
```
if `width < len(variable.toString())` then the entire thing is printed

## precision
floats are displayed with 5 digits after the decimal
we can specify the number of digits to display with `%.3f`

and if the precision is too low for the number it is rounded 19.99 with `%.1f` would be printed as 20.0
```c
float a = 19.99;
float b = 1.99;
float c = -100.99;

printf("%f\n", a); // 19.990000
printf("%f\n", b); // 1.990000
printf("%f\n", c); // -100.990000

printf("%.3f\n", a); // 19.990000
printf("%.3f\n", b); // 1.990000
printf("%.3f\n", c); // -100.990000

printf("%.1f\n", a); // 20.0
```