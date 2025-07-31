```cfg
expression     → equality ;
equality       → comparison ( ( "!=" | "==" ) comparison )* ;
comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
term           → factor ( ( "-" | "+" ) factor )* ;
factor         → unary ( ( "/" | "*" ) unary )* ;
unary          → ( "!" | "-" ) unary
               | primary ;
primary        → NUMBER | STRING | "true" | "false" | "nil"
               | "(" expression ")" ;
```
**top-down parser** because it starts from the top or outermost grammar rule (that is expression in our case) and works its way down into the nested subexpressions before finally reaching the leaves of the syntax tree

Each rule becomes a function

## Error detection
As soon as the parser detects an error, it enters panic mode. It knows at least one token doesn’t make sense given its current state in the middle of some stack of grammar productions.

Before it can get back to parsing, it needs to get its state and the sequence of forthcoming tokens aligned such that the next token does match the rule being parsed. This process is called synchronization.

To do that, we select some rule in the grammar that will mark the synchronization point. The parser fixes its parsing state by jumping out of any nested productions until it gets back to that rule. Then it synchronizes the token stream by discarding tokens until it reaches one that can appear at that point in the rule.

Any additional real syntax errors hiding in those discarded tokens aren’t reported, but it also means that any mistaken cascaded errors that are side effects of the initial error aren’t falsely reported either, which is a decent trade-off.

The traditional place in the grammar to synchronize is between statements

The parser promises not to crash or hang on invalid syntax, but it doesn’t promise to return a usable syntax tree if an error is found.

we use Java’s own call stack to track what the parser is doing. Each rule in the middle of being parsed is a call frame on the stack. 
In order to reset that state, we need to clear out those call frames.
The natural way to do that in Java is exceptions. When we want to synchronize, we throw that ParseError object. 
Higher up in the method for the grammar rule we are synchronizing to, we’ll catch it. Since we synchronize on statement boundaries, 
we’ll catch the exception there.
After the exception is caught, the parser is in the right state. All that’s left is to synchronize the tokens.
We want to discard tokens until we’re right at the beginning of the next statement. That boundary is pretty easy to spot—it’s one of the main reasons we picked it. After a semicolon, we’re probably finished with a statement. 
Most statements start with a keyword—for, if, return, var, etc. When the next token is any of those, we’re probably about to start a statement.

In C, a block is a statement form that allows you to pack a series of statements where a single one is expected. 
The comma operator is an analogous syntax for expressions. A comma-separated series of expressions can be given where a single expression is expected (except inside a function call’s argument list). 
At runtime, the comma operator evaluates the left operand and discards the result. Then it evaluates and returns the right operand.
to add support for comma expressions. 
Give them the same precedence and associativity as in C. Write the grammar, and then implement the necessary parsing code.

```cfg

expression     → comma ;

comma          → assignment ( "," assignment )* ;

assignment     → equality ;

```

for ternary

```cfg

expression    → comma ;

comma         → ternary ( "," ternary )* ;

ternary       → assignment ( "?" expression ":" ternary )? ;

assignment    → equality ;

```


|  Lox Type        |  Java Representation  |
| ---------------- | --------------------- |
|  Any Lox value   |  Object               |
|  nil             |  null                 |
|  Boolean         |  Boolean              |
|  number          |  Double               |
|  string          |  String               |

We use Java's Object because Lox is Dynamically typed while java is not 

To determine what data type we are working on we can use instanceof operator of java

A literal always appears somewhere in the user’s source code. 
Lots of values are produced by computation and don’t exist anywhere in the code itself. Those aren’t literals. 
A literal comes from the parser’s domain. Values are an interpreter concept, part of the runtime’s world.