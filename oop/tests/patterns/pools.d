/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.pools;

import uim.oop;
import std.stdio;

@safe:

// Test basic pool interface
unittest {
    interface IPoolable {
        void reset();
    }
    
    class PooledObject : IPoolable {
        private int _value;
        
        this() { _value = 0; }
        
        void setValue(int v) { _value = v; }
        int getValue() { return _value; }
        
        void reset() { _value = 0; }
    }
    
    auto obj = new PooledObject();
    obj.setValue(42);
    assert(obj.getValue() == 42, "Object should store value");
    
    obj.reset();
    assert(obj.getValue() == 0, "Reset should clear value");
}

// Test pool acquire and release
unittest {
    class SimplePooled {
        private bool _inUse;
        
        this() { _inUse = false; }
        
        void acquire() { _inUse = true; }
        void release() { _inUse = false; }
        bool inUse() { return _inUse; }
    }
    
    auto obj = new SimplePooled();
    assert(!obj.inUse(), "Object should not be in use initially");
    
    obj.acquire();
    assert(obj.inUse(), "Object should be in use after acquire");
    
    obj.release();
    assert(!obj.inUse(), "Object should not be in use after release");
}

// Test pool capacity management
unittest {
    class PoolItem {
        private int _id;
        
        this(int id) { _id = id; }
        int id() { return _id; }
    }
    
    PoolItem[] pool;
    enum MAX_SIZE = 5;
    
    // Fill pool
    foreach (i; 0 .. MAX_SIZE) {
        pool ~= new PoolItem(i);
    }
    
    assert(pool.length == MAX_SIZE, "Pool should contain MAX_SIZE items");
    
    // Test item retrieval
    auto item = pool[0];
    assert(item.id == 0, "First item should have id 0");
}

// Test scoped pool cleanup
unittest {
    class Resource {
        private bool _cleaned;
        
        this() { _cleaned = false; }
        
        void cleanup() { _cleaned = true; }
        bool isCleaned() { return _cleaned; }
    }
    
    auto resource = new Resource();
    assert(!resource.isCleaned(), "Resource should not be cleaned initially");
    
    resource.cleanup();
    assert(resource.isCleaned(), "Resource should be cleaned after cleanup");
}

// Test thread-safe pool concept
unittest {
    shared class ThreadSafeCounter {
        private int _count;
        
        this() shared { _count = 0; }
        
        void increment() shared {
            synchronized(this) {
                _count++;
            }
        }
        
        int getCount() shared {
            synchronized(this) {
                return _count;
            }
        }
    }
    
    auto counter = new shared ThreadSafeCounter();
    assert(counter.getCount() == 0, "Counter should start at 0");
    
    counter.increment();
    assert(counter.getCount() == 1, "Counter should be 1 after increment");
}

// Test pool reuse
unittest {
    class ReusableObject {
        private int _useCount;
        
        this() { _useCount = 0; }
        
        void use() { _useCount++; }
        int useCount() { return _useCount; }
        void reset() { _useCount = 0; }
    }
    
    auto obj = new ReusableObject();
    
    obj.use();
    obj.use();
    assert(obj.useCount() == 2, "Object should track uses");
    
    obj.reset();
    assert(obj.useCount() == 0, "Reset should clear use count");
    
    obj.use();
    assert(obj.useCount() == 1, "Object should be reusable");
}