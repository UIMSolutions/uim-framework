/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module compilers.examples.string_mixins;

import std.stdio;

void main() {
    writeln("=== String Mixins Example ===\n");

    // Example 1: Basic string mixin
    writeln("1. Basic string mixin:");
    mixin("int x = 42;");
    writeln("  x = ", x);
    
    mixin(`
        int y = 100;
        string greeting = "Hello from mixin!";
    `);
    writeln("  y = ", y);
    writeln("  greeting = ", greeting);
    writeln();

    // Example 2: Generate functions at compile-time
    writeln("2. Generating functions with string mixins:");
    
    string generateGetter(string type, string name) {
        return type ~ " get" ~ name ~ "() { return _" ~ name ~ "; }";
    }
    
    string generateSetter(string type, string name) {
        return "void set" ~ name ~ "(" ~ type ~ " value) { _" ~ name ~ " = value; }";
    }
    
    class Person {
        private string _name;
        private int _age;
        
        mixin(generateGetter("string", "name"));
        mixin(generateSetter("string", "name"));
        mixin(generateGetter("int", "age"));
        mixin(generateSetter("int", "age"));
    }
    
    auto person = new Person();
    person.setname("Alice");
    person.setage(30);
    writeln("  Person: ", person.getname(), ", age ", person.getage());
    writeln();

    // Example 3: Generate multiple similar functions
    writeln("3. Generating multiple mathematical operations:");
    
    string generateMathOp(string op, string name) {
        return `int ` ~ name ~ `(int a, int b) { return a ` ~ op ~ ` b; }`;
    }
    
    mixin(generateMathOp("+", "add"));
    mixin(generateMathOp("-", "subtract"));
    mixin(generateMathOp("*", "multiply"));
    mixin(generateMathOp("/", "divide"));
    
    writeln("  add(10, 5) = ", add(10, 5));
    writeln("  subtract(10, 5) = ", subtract(10, 5));
    writeln("  multiply(10, 5) = ", multiply(10, 5));
    writeln("  divide(10, 5) = ", divide(10, 5));
    writeln();

    // Example 4: Generate switch cases
    writeln("4. Generating switch cases:");
    
    string generateColorSwitch() {
        string[] colors = ["red", "green", "blue", "yellow"];
        string result = "string getColorCode(string color) { switch(color) {";
        
        foreach (i, color; colors) {
            result ~= "case \"" ~ color ~ "\": return \"#" ~ color ~ "\";";
        }
        
        result ~= "default: return \"#unknown\";";
        result ~= "}}";
        return result;
    }
    
    mixin(generateColorSwitch());
    
    writeln("  Color code for 'red': ", getColorCode("red"));
    writeln("  Color code for 'blue': ", getColorCode("blue"));
    writeln("  Color code for 'purple': ", getColorCode("purple"));
    writeln();

    // Example 5: Generate property declarations
    writeln("5. Generating properties with validation:");
    
    string generateProperty(string type, string name, string validation = "") {
        string result = "private " ~ type ~ " _" ~ name ~ ";";
        result ~= "@property " ~ type ~ " " ~ name ~ "() { return _" ~ name ~ "; }";
        result ~= "@property void " ~ name ~ "(" ~ type ~ " value) {";
        if (validation.length > 0) {
            result ~= validation;
        }
        result ~= "_" ~ name ~ " = value; }";
        return result;
    }
    
    class ValidatedData {
        mixin(generateProperty("int", "score", "if (value < 0 || value > 100) throw new Exception(\"Score must be 0-100\");"));
        mixin(generateProperty("string", "name", "if (value.length == 0) throw new Exception(\"Name cannot be empty\");"));
    }
    
    auto data = new ValidatedData();
    data.name = "Test";
    data.score = 85;
    writeln("  ValidatedData: ", data.name, ", score: ", data.score);
    
    try {
        data.score = 150; // This will throw
    } catch (Exception e) {
        writeln("  Caught validation error: ", e.msg);
    }
    writeln();

    // Example 6: Code generation from template
    writeln("6. Generating code from templates:");
    
    template GenericContainer(T) {
        class Container {
            private T[] items;
            
            void add(T item) { items ~= item; }
            T get(size_t index) { return items[index]; }
            size_t length() { return items.length; }
            
            mixin(`
                void clear() { items = []; }
                bool isEmpty() { return items.length == 0; }
            `);
        }
    }
    
    alias IntContainer = GenericContainer!int.Container;
    alias StringContainer = GenericContainer!string.Container;
    
    auto intCont = new IntContainer();
    intCont.add(1);
    intCont.add(2);
    intCont.add(3);
    writeln("  IntContainer length: ", intCont.length());
    writeln("  IntContainer[1]: ", intCont.get(1));
    
    auto strCont = new StringContainer();
    strCont.add("Hello");
    strCont.add("World");
    writeln("  StringContainer length: ", strCont.length());
    writeln("  StringContainer[0]: ", strCont.get(0));
    writeln();

    writeln("=== Example Complete ===");
}
