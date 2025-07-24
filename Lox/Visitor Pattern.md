We have a handful of types, and a handful of high-level operations like “interpret”. For each pair of type and operation, we need a specific implementation. Picture a table:
![[Pasted image 20250724004617.png]]Rows are types, and columns are operations. Each cell represents the unique piece of code to implement that operation on that type.

An object-oriented language like Java assumes that all of the code in one row naturally hangs together. It figures all the things you do with a type are likely related to each other, and the language makes it easy to define them together as methods inside the same class.
![[Pasted image 20250724004633.png]]This makes it easy to extend the table by adding new rows. Simply define a new class. No existing code has to be touched. But imagine if you want to add a new _operation_—a new column. In Java, that means cracking open each of those existing classes and adding a method to it.

Functional paradigm languages in the ML family flip that around. There, you don’t have classes with methods. Types and functions are totally distinct. To implement an operation for a number of different types, you define a single function. In the body of that function, you use _pattern matching_—sort of a type-based switch on steroids—to implement the operation for each type all in one place.

ML, short for “metalanguage” was created by Robin Milner and friends and forms one of the main branches in the great programming language family tree. Its children include SML, Caml, OCaml, Haskell, and F#. Even Scala, Rust, and Swift bear a strong resemblance.

Much like Lisp, it is one of those languages that is so full of good ideas that language designers today are still rediscovering them over forty years later.

This makes it trivial to add new operations—simply define another function that pattern matches on all of the types.

![[Pasted image 20250724004700.png]]But, conversely, adding a new type is hard. You have to go back and add a new case to all of the pattern matches in all of the existing functions.

The Visitor pattern is about approximating the functional style within an OOP language. It lets us add new columns to that table easily. We can define all of the behavior for a new operation on a set of types in one place, without having to touch the types themselves

```java
abstract class Pastry {
	abstract void accept(PastryVisitor visitor);
}

class Beignet extends Pastry {
	@Override
    void accept(PastryVisitor visitor) {
      visitor.visitBeignet(this);
    }
}

class Cruller extends Pastry {
	@Override
    void accept(PastryVisitor visitor) {
      visitor.visitCruller(this);
    }
}
```

We want to be able to define new pastry operations—cooking them, eating them, decorating them, etc.—without having to add a new method to each class every time.

```java
interface PastryVisitor {
    void visitBeignet(Beignet beignet); 
    void visitCruller(Cruller cruller);
}
```

To perform an operation on a pastry, we call its `accept()` method and pass in the visitor for the operation we want to execute. The pastry—the specific subclass’s overriding implementation of `accept()`—turns around and calls the appropriate visit method on the visitor and passes _itself_ to it.

Its about POLYMORPHIC DISPATCH of this object to implementation
```java
Cruller cruller = new Cruller();

cruller.accept(CookVisitor);
```