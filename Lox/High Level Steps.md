1. Lexing - tokenizing, regular languages aren’t powerful enough to handle expressions which can nest arbitrarily deeply.
2. Parsing - building an Abstract Syntax Tree from the lexed tokens
	1. as soon as the lexer finds a "string" it should create a String object with value "string"
3. Static Analysis - at this point language specific features come into picture, for expressions like a + b we know we are +ing a and b but we dont know what the entails
	1. we need to know what those variables are, can be done with binding or resolution
	2. for each variable find out where the name is defined and wire the two together, taking care of scope
	3. do type checking, if the types dont allow the operation being performed in the expression we can report an error
	4. we can fill this meta information attained into the Syntax Tree itself
	5. or it may be stored in a lookup table, can be called a symbol table if we store variables and declarations as keys of this table
	6. the best way is to create a new data structure out of this data
4. Intermediate Language - to support different platforms and different higher languages
	1. also provides optimization, once we know what the user is trying to do we replace their code with our prewritten more optimized version of the same thing
	2. for example if some constant is being evaluated everytime the same, then we can calculate that at compile time itself
5. Machine Code Generation - Actually Byte code for a Java like VM
6. VM - a program that emulates a chip supporting your bytecode, it s slower but we get portability out of it
7. Runtime - Garbage Collection, for any VM based language
#### Context Free Grammar
simple tokenizing and lexing isnt enough to handle expressions that next arbitrarily, as we get a flat list of tokens
rules by which the tokens should be grouped together to make expressions and statements are part of the syntactical grammar

is Lexical analysis we group characters to make tokens, and its done by scanning

in syntactical analysis we group the tokens from the previous step to make expressions that can be evaluated as per the spec of the language and its done by the parser

###### Lox Grammar
```cfg
expression     → literal
               | unary
               | binary
               | grouping ;

literal        → NUMBER | STRING | "true" | "false" | "nil" ;
grouping       → "(" expression ")" ;
unary          → ( "-" | "!" ) expression ;
binary         → expression operator expression ;
operator       → "==" | "!=" | "<" | "<=" | ">" | ">="
               | "+"  | "-"  | "*" | "/" ;
```

Pipe means or
() wrap an expression
Things in Capitals are meta literals NUMBER is any number and STRING is string
much like IDENTIFIER
