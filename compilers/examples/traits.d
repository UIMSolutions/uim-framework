/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module compilers.examples.traits;

import std.stdio;
import std.traits;

void main() {
    writeln("=== Traits and Type Introspection Example ===\n");

    // Example 1: Basic type checking
    writeln("1. Basic type checking with traits:");
    
    void checkType(T)(T value) {
        writeln("  Type: ", T.stringof);
        writeln("    Is integral: ", isNumeric!T);
        writeln("    Is floating point: ", isFloatingPoint!T);
        writeln("    Is signed: ", isSigned!T);
        writeln("    Is unsigned: ", isUnsigned!T);
        writeln("    Size in bytes: ", T.sizeof);
    }
    
    checkType(42);
    writeln();
    checkType(3.14);
    writeln();

    // Example 2: Function traits
    writeln("2. Function traits:");
    
    int multiply(int a, int b) {
        return a * b;
    }
    
    writeln("  Function: multiply");
    writeln("    Return type: ", ReturnType!multiply.stringof);
    writeln("    Parameter types: ", Parameters!multiply.stringof);
    writeln("    Parameter count: ", Parameters!multiply.length);
    writeln();

    // Example 3: Struct/Class member introspection
    writeln("3. Struct member introspection:");
    
    struct Employee {
        string name;
        int age;
        double salary;
        
        void work() { }
        void休息() { }
    }
    
    writeln("  Employee struct:");
    writeln("    Field names: ", FieldNameTuple!Employee);
    writeln("    Field types: ", Fields!Employee.stringof);
    writeln("    Number of fields: ", Fields!Employee.length);
    writeln();

    // Example 4: Checking for specific members
    writeln("4. Checking for member existence:");
    
    struct Point {
        int x, y;
        void move(int dx, int dy) { x += dx; y += dy; }
    }
    
    writeln("  Point struct:");
    writeln("    Has member 'x': ", __traits(hasMember, Point, "x"));
    writeln("    Has member 'move': ", __traits(hasMember, Point, "move"));
    writeln("    Has member 'z': ", __traits(hasMember, Point, "z"));
    writeln();

    // Example 5: Getting all members
    writeln("5. Listing all members:");
    
    writeln("  Point members:");
    foreach (member; __traits(allMembers, Point)) {
        writeln("    - ", member);
    }
    writeln();

    // Example 6: Compile-time type manipulation
    writeln("6. Type modification:");
    
    alias IntPtr = int*;
    alias ConstInt = const(int);
    
    writeln("  Original type: int");
    writeln("    Pointer to int: ", (int*).stringof);
    writeln("    Unqualified: ", Unqual!ConstInt.stringof);
    writeln("    Add const: ", ConstOf!int.stringof);
    writeln();

    // Example 7: Checking for function attributes
    writeln("7. Function attributes:");
    
    @safe pure nothrow int safeFunction(int x) {
        return x * 2;
    }
    
    void unsafeFunction(int x) {
    }
    
    writeln("  safeFunction:");
    writeln("    Is @safe: ", isSafe!safeFunction);
    writeln("    Is pure: ", isPure!safeFunction);
    writeln("    Is nothrow: ", isNothrow!safeFunction);
    
    writeln("  unsafeFunction:");
    writeln("    Is @safe: ", isSafe!unsafeFunction);
    writeln("    Is pure: ", isPure!unsafeFunction);
    writeln();

    // Example 8: Array traits
    writeln("8. Array type checking:");
    
    void checkArrayType(T)(T value) {
        writeln("  Type: ", T.stringof);
        writeln("    Is array: ", isArray!T);
        writeln("    Is static array: ", isStaticArray!T);
        writeln("    Is dynamic array: ", isDynamicArray!T);
        static if (isArray!T) {
            writeln("    Element type: ", typeof(value[0]).stringof);
        }
    }
    
    int[] dynamicArray = [1, 2, 3];
    int[5] staticArray = [1, 2, 3, 4, 5];
    
    checkArrayType(dynamicArray);
    writeln();
    checkArrayType(staticArray);
    writeln();

    // Example 9: Checking for callability
    writeln("9. Callable checking:");
    
    struct Callable {
        void opCall(int x) {
            writeln("    Called with: ", x);
        }
    }
    
    Callable callable;
    
    writeln("  Is function: ", isFunction!(multiply));
    writeln("  Is callable (struct with opCall): ", isCallable!Callable);
    writeln();

    // Example 10: Getting function linkage
    writeln("10. Function linkage information:");
    
    extern(C) void cFunction() { }
    void dFunction() { }
    
    writeln("  cFunction linkage: ", functionLinkage!cFunction);
    writeln("  dFunction linkage: ", functionLinkage!dFunction);
    writeln();

    // Example 11: Template for generic printing based on traits
    writeln("11. Generic function using traits:");
    
    void smartPrint(T)(T value) {
        static if (is(T == class) || is(T == struct)) {
            writeln("  Object/Struct with fields:");
            foreach (i, field; value.tupleof) {
                writeln("    ", __traits(identifier, value.tupleof[i]), " = ", field);
            }
        } else static if (isArray!T) {
            writeln("  Array: ", value);
        } else {
            writeln("  Value: ", value);
        }
    }
    
    struct Person {
        string name;
        int age;
    }
    
    smartPrint(Person("Bob", 25));
    smartPrint([1, 2, 3, 4]);
    smartPrint(42);
    writeln();

    // Example 12: Compile-time filtering
    writeln("12. Compile-time type filtering:");
    
    import std.meta : Filter, AliasSeq;
    
    alias Types = AliasSeq!(int, string, float, char[], double, bool);
    alias NumericTypes = Filter!(isNumeric, Types);
    
    writeln("  All types: ", Types.stringof);
    writeln("  Numeric types only: ", NumericTypes.stringof);
    writeln();

    writeln("=== Example Complete ===");
}
