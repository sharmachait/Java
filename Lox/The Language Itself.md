dynamically typed
GC
```c
// Your first Lox program!
print "Hello, world!";
```
### Data types
1. Booleans
```c
true;
false;
```
2. Numbers
```c
123;
12.3;
```
3. Strings
```c
"I am a string";
"";
```
4. Nil
### Expressions
```js
add + me;
//we can also pass strings to +
add - me;
add * me;
add / me;
-negateOperator;
less < than;
lessThan <= orEqual;
greater > than;
greaterThan >= orEqual;
1 == 2;         // false.
"cat" != "dog"; // true.
123 == "123"; // false.
!true;  // false.
!false; // true.
true and false; // false.
true and true;  // true.
false or false; // false.
true or false;  // true.

var imAVariable = "here is my value";
var iAmNil;
var breakfast = "bagels";
print breakfast; // "bagels".

if (condition) {
  print "yes";
} else {
  print "no";
}

var a = 1;
while (a < 10) {
  print a;
  a = a + 1;
}

for (var a = 1; a < 10; a = a + 1) {
  print a;
}

fun printSum(a, b) { // a and b are called paramerers
  print a + b;
  return a + b;
}

// if we dont return anything from the function it returns nil

printSum(1,2); // 1 and 2 are called arguments
```

##### closures
Functions are _first class_ in Lox
```js
fun addPair(a, b) {
  return a + b;
}

fun identity(a) {
  return a;
}

print identity(addPair)(1, 2); // Prints "3".
```

Nested functions are allowed
```js
fun outerFunction() {
	fun localFunction() {
		print "I'm local!";
	}
	localFunction();
}
```

example of closure
```js
fun returnFunction() {
	var outside = "outside";
	
	fun inner() {
		print outside;
	}
	
	return inner;
}

var fn = returnFunction();
fn();
```

for this to work function fn needs to hold a reference to any surrounding variables declared in the same scope as the function

### Classes
```js
class Breakfast {
	cook() {
		print "Eggs a-fryin'!";
	}
	
	serve(who) {
		print "Enjoy your breakfast, " + who + ".";
	}
}
```

When the class declaration is executed, Lox creates a class object and stores that in a variable named after the class. Just like functions, classes are first class in Lox.
```js
// Store it in variables.
var someVariable = Breakfast;

// Pass it to functions.
someFunction(Breakfast);

var breakfast = Breakfast();
print breakfast; // "Breakfast instance".

breakfast.meat = "sausage";
breakfast.bread = "sourdough";

class Breakfast {
    init(meat, bread) {
	    this.meat = meat;
	    this.bread = bread;
    }
	serve(who) {
		print "Enjoy your " + this.meat + " and " + this.bread + ", " + who + ".";
	}
	serve(who) {
		print "Enjoy your breakfast, " + who + ".";
	}
}

var baconAndToast = Breakfast("bacon", "toast");
baconAndToast.serve("Dear Reader");
```
#### Inheritance
Lox supports single inheritance
Every method defined in the superclass is also available to its subclasses.
```js
class Brunch < Breakfast {
	init(meat, bread, drink) {
		super.init(meat, bread);
		this.drink = drink;
	}
	drink() {
		print "How about a Bloody Mary?";
	}
}

var benedict = Brunch("ham", "English muffin");
benedict.serve("Noble Reader");
```

