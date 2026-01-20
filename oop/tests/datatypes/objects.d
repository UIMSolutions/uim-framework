/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.datatypes.objects;

import uim.oop;
import std.stdio;

@safe:

// Test basic object creation
unittest {
    class BasicObject {
        private string _name;
        
        this(string name) {
            _name = name;
        }
        
        string name() { return _name; }
    }
    
    auto obj = new BasicObject("Test");
    assert(obj !is null, "Object should be created");
    assert(obj.name == "Test", "Object should have correct name");
}

// Test object interface implementation
unittest {
    interface IIdentifiable {
        string getId();
    }
    
    class IdentifiableObject : IIdentifiable {
        private string _id;
        
        this(string id) {
            _id = id;
        }
        
        string getId() {
            return _id;
        }
    }
    
    auto obj = new IdentifiableObject("id-123");
    assert(obj.getId() == "id-123", "Object should implement interface correctly");
}

// Test object equality
unittest {
    class ValueObject {
        private int _value;
        
        this(int value) {
            _value = value;
        }
        
        int value() { return _value; }
        
        override bool opEquals(Object other) {
            if (auto vo = cast(ValueObject)other) {
                return _value == vo._value;
            }
            return false;
        }
    }
    
    auto obj1 = new ValueObject(42);
    auto obj2 = new ValueObject(42);
    auto obj3 = new ValueObject(100);
    
    assert(obj1 == obj2, "Objects with same value should be equal");
    assert(obj1 != obj3, "Objects with different values should not be equal");
}

// Test object cloning
unittest {
    class CloneableObject {
        private int _data;
        
        this(int data) {
            _data = data;
        }
        
        CloneableObject clone() {
            return new CloneableObject(_data);
        }
        
        int data() { return _data; }
        void setData(int d) { _data = d; }
    }
    
    auto original = new CloneableObject(42);
    auto cloned = original.clone();
    
    assert(original.data == cloned.data, "Clone should have same data");
    
    cloned.setData(100);
    assert(original.data == 42, "Modifying clone should not affect original");
    assert(cloned.data == 100, "Clone should be independent");
}

// Test object hierarchy
unittest {
    class Animal {
        string makeSound() { return "Some sound"; }
    }
    
    class Dog : Animal {
        override string makeSound() { return "Woof"; }
    }
    
    class Cat : Animal {
        override string makeSound() { return "Meow"; }
    }
    
    Animal animal = new Animal();
    Animal dog = new Dog();
    Animal cat = new Cat();
    
    assert(animal.makeSound() == "Some sound", "Base class should return base sound");
    assert(dog.makeSound() == "Woof", "Dog should override makeSound");
    assert(cat.makeSound() == "Meow", "Cat should override makeSound");
}

// Test object composition
unittest {
    class Engine {
        private bool _running;
        
        void start() { _running = true; }
        void stop() { _running = false; }
        bool isRunning() { return _running; }
    }
    
    class Car {
        private Engine _engine;
        
        this() {
            _engine = new Engine();
        }
        
        void start() { _engine.start(); }
        void stop() { _engine.stop(); }
        bool isRunning() { return _engine.isRunning(); }
    }
    
    auto car = new Car();
    assert(!car.isRunning(), "Car should not be running initially");
    
    car.start();
    assert(car.isRunning(), "Car should be running after start");
    
    car.stop();
    assert(!car.isRunning(), "Car should not be running after stop");
}