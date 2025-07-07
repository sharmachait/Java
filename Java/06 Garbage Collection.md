## Types of GC algorithms

1. Serial GC - single thread is used to do GC, halts the entire program when it runs
    
2. Parallel GC - default since Java 8, depending on the Cores multiple threads work on GC
    
3. Concurrent Mark and sweep - GC threads and application threads work all parallelly, doesnt stop App threads when GC threads are working, but not guaranteed
    
4. G1 GC - tries to guarantee that app threads will not be stopped when GC happens, also tries to compact the freed up memory for sequential allocation