/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.helpers.classes;

import uim.oop;
import std.stdio;

@safe:

// Test baseName function with simple class
unittest {
    class SimpleClass {}
    auto info = SimpleClass.classinfo;
    assert(baseName(info) == "SimpleClass", "baseName should return 'SimpleClass'");
}

// Test baseName with deeply nested namespace
unittest {
    class NestedClass {}
    auto info = NestedClass.classinfo;
    string name = baseName(info);
    assert(name == "NestedClass", "baseName should extract last segment");
}

// Test baseName with single character class name
unittest {
    class A {}
    auto info = A.classinfo;
    assert(baseName(info) == "A", "baseName should handle single character names");
}

// Test classFullname with null instance
unittest {
    Object nullObj = null;
    assert(classFullname(nullObj) == "null", "classFullname should return 'null' for null instance");
}

// Test classFullname with valid instance
unittest {
    class TestClass {}
    auto obj = new TestClass();
    string fullName = classFullname(obj);
    assert(fullName.length > 0, "classFullname should return non-empty string");
    assert(fullName[$ - 9 .. $] == "TestClass", "classFullname should end with class name");
}

// Test classname with null instance
unittest {
    Object nullObj = null;
    assert(classname(nullObj) is null, "classname should return null for null instance");
}

// Test classname with valid instance
unittest {
    class MyClass {}
    auto obj = new MyClass();
    assert(classname(obj) == "MyClass", "classname should return 'MyClass'");
}

// Test classname with inheritance chain
unittest {
    class BaseClass {}
    class DerivedClass : BaseClass {}
    class FinalClass : DerivedClass {}
    
    auto base = new BaseClass();
    auto derived = new DerivedClass();
    auto final_ = new FinalClass();
    
    assert(classname(base) == "BaseClass", "classname should return 'BaseClass'");
    assert(classname(derived) == "DerivedClass", "classname should return 'DerivedClass'");
    assert(classname(final_) == "FinalClass", "classname should return 'FinalClass'");
}

// Test with interface implementation
unittest {
    interface ITestInterface {}
    class TestImpl : ITestInterface {}
    
    auto obj = new TestImpl();
    assert(classname(obj) == "TestImpl", "classname should work with interface implementations");
}

// Test multiple instances of same class
unittest {
    class MultiInstance {}
    auto obj1 = new MultiInstance();
    auto obj2 = new MultiInstance();
    
    assert(classname(obj1) == classname(obj2), "Same class instances should have same classname");
    assert(classFullname(obj1) == classFullname(obj2), "Same class instances should have same classFullname");
}

// Test with generic class
unittest {
    class GenericClass(T) {
        T value;
    }
    
    auto intInstance = new GenericClass!int();
    auto stringInstance = new GenericClass!string();
    
    // Generic class names will include type parameters
    assert(classname(intInstance).length > 0);
    assert(classname(stringInstance).length > 0);
}

// Test with abstract class
unittest {
    abstract class AbstractBase {}
    class ConcreteClass : AbstractBase {}
    
    auto obj = new ConcreteClass();
    assert(classname(obj) == "ConcreteClass", "classname should work with abstract base classes");
}

// Test classname consistency
unittest {
    class ConsistencyTest {}
    auto obj = new ConsistencyTest();
    
    string name1 = classname(obj);
    string name2 = classname(obj);
    string name3 = classname(obj);
    
    assert(name1 == name2 && name2 == name3, "classname should be consistent across calls");
}

// Test with nested classes
unittest {
    class Outer {
        class Inner {}
    }
    
    auto outer = new Outer();
    auto inner = outer.new Inner();
    
    assert(classname(outer) == "Outer", "classname should work with outer class");
    assert(classname(inner) == "Inner", "classname should work with nested inner class");
}