## two types stack and heap, both managed by JVM

### stack

- less memory than the heap
    
- scoped temporary variables
    
- memory blocks for methods, methods scoped variables
    
- Primitive data types
    
- References to heap objects
    
    - references can be of two types strong and weak
        
        - STRONG reference -> Person p =new Person(); GC wont clear it
            
        - WEAK reference -> 
	        - `WeakReference<Person> weakRef = new WeakReference<>(new Person()); `
	        - GC can clear it up when ever it runs
            
        - SOFT reference ->
	        - `SoftReference<Person> softPerson = new SoftReference<>(new Person());`
	        - can let GC clear it up, but only when there is no space left in the heap
            
- each thread has its own stack
    
- all threads share a common heap

when stack goes out of scope and references to heap are deleted there remains object in the heap which no one references , those are cleared by the garbage collector

### heap

heap is divided into two parts, Young generation, Old generation

young generation is divided into three parts Eden, S0 and S1 (S stands for survivor space)

whenever we create a new Object() it goes into eden space

lets say we have 5 Objects in Eden

when ever Mark and sweep is invoked

it marks all the objects that are no longer referenced, in Eden and survivor space as well

then it sweeps the left over unmarked objects to the survivor space and deletes the ones that were marked, and an age is associated with all the survivors

then is called Minor GC that pushed from eden to S0

in the second iteration of the Mark and sweep it will sweep the objects from Eden and S0 to S1 as last time it used S0, it will increase the age of the survivors

and it will clear up eden and S0

Survivor objects swap between S0 and S1 and one of S0 or S1 are completely cleaned up

when the age of some objects reach threshold they are promoted to Old generation

and this process of moving to Old generation is called Major GC

they are cleared from the Old generation using the same mark and sweep algorithm

## Meta space

Along side Heap we also have Meta-Space which stored class Static variables and class Metadata from which objects can be created

