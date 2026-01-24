/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module compilers.examples.templates;

import std.stdio;
import std.traits;
import std.conv;

void main() {
    writeln("=== Template Metaprogramming Example ===\n");

    // Example 1: Basic function template
    writeln("1. Basic function template:");
    
    T add(T)(T a, T b) {
        return a + b;
    }
    
    writeln("  add(5, 10) = ", add(5, 10));
    writeln("  add(3.14, 2.86) = ", add(3.14, 2.86));
    writeln("  add(\"Hello, \", \"World!\") = ", add("Hello, ", "World!"));
    writeln();

    // Example 2: Template constraints
    writeln("2. Template with constraints:");
    
    T multiply(T)(T a, T b) if (isNumeric!T) {
        return a * b;
    }
    
    writeln("  multiply(4, 5) = ", multiply(4, 5));
    writeln("  multiply(2.5, 3.0) = ", multiply(2.5, 3.0));
    // multiply("a", "b"); // Would not compile - string is not numeric
    writeln();

    // Example 3: Template specialization
    writeln("3. Template specialization:");
    
    struct Container(T) {
        T value;
        string describe() {
            return "Container holds: " ~ value.to!string;
        }
    }
    
    // Specialization for strings
    struct Container(T : string) {
        T value;
        string describe() {
            return "String container holds: \"" ~ value ~ "\"";
        }
    }
    
    auto intContainer = Container!int(42);
    auto stringContainer = Container!string("Hello");
    
    writeln("  ", intContainer.describe());
    writeln("  ", stringContainer.describe());
    writeln();

    // Example 4: Recursive templates for compile-time factorial
    writeln("4. Recursive template (factorial):");
    
    template Factorial(int n) {
        static if (n <= 1)
            enum Factorial = 1;
        else
            enum Factorial = n * Factorial!(n - 1);
    }
    
    writeln("  Factorial(5) = ", Factorial!5);
    writeln("  Factorial(10) = ", Factorial!10);
    writeln("  Factorial(15) = ", Factorial!15);
    writeln();

    // Example 5: Template tuple parameters
    writeln("5. Template with tuple parameters:");
    
    template Sum(T...) {
        static if (T.length == 0)
            enum Sum = 0;
        else
            enum Sum = T[0] + Sum!(T[1..$]);
    }
    
    writeln("  Sum of (1, 2, 3, 4, 5) = ", Sum!(1, 2, 3, 4, 5));
    writeln("  Sum of (10, 20, 30) = ", Sum!(10, 20, 30));
    writeln();

    // Example 6: Type selection based on size
    writeln("6. Type selection template:");
    
    template SelectType(int size) {
        static if (size <= 1)
            alias SelectType = ubyte;
        else static if (size <= 2)
            alias SelectType = ushort;
        else static if (size <= 4)
            alias SelectType = uint;
        else
            alias SelectType = ulong;
    }
    
    SelectType!1 small = 255;
    SelectType!2 medium = 65535;
    SelectType!4 large = 4294967295;
    
    writeln("  Type for size 1: ", typeof(small).stringof, " = ", small);
    writeln("  Type for size 2: ", typeof(medium).stringof, " = ", medium);
    writeln("  Type for size 4: ", typeof(large).stringof, " = ", large);
    writeln();

    // Example 7: Compile-time string manipulation
    writeln("7. Compile-time string generation:");
    
    template GenerateGetters(string[] fields) {
        static if (fields.length == 0)
            enum GenerateGetters = "";
        else
            enum GenerateGetters = 
                "auto get" ~ fields[0] ~ "() { return " ~ fields[0] ~ "; }\n" ~
                GenerateGetters!(fields[1..$]);
    }
    
    struct Person {
        string name;
        int age;
        
        mixin(GenerateGetters!(["name", "age"]));
    }
    
    auto person = Person("Alice", 30);
    writeln("  person.getName() = ", person.getName());
    writeln("  person.getage() = ", person.getage());
    writeln();

    // Example 8: Template for range checking
    writeln("8. Compile-time range validation:");
    
    template InRange(T, T min, T max) {
        T enforce(T value) {
            static assert(min <= max, "Invalid range: min must be <= max");
            if (value < min || value > max)
                throw new Exception("Value out of range");
            return value;
        }
    }
    
    alias Percentage = InRange!(int, 0, 100);
    
    try {
        writeln("  Valid percentage: ", Percentage.enforce(50));
        writeln("  Valid percentage: ", Percentage.enforce(0));
        // writeln("  Invalid: ", Percentage.enforce(150)); // Would throw
    } catch (Exception e) {
        writeln("  Caught exception: ", e.msg);
    }
    writeln();

    // Example 9: Variadic template function
    writeln("9. Variadic template function:");
    
    void printAll(T...)(T args) {
        foreach (arg; args) {
            write(arg, " ");
        }
        writeln();
    }
    
    write("  printAll with mixed types: ");
    printAll(1, "hello", 3.14, true);
    writeln();

    // Example 10: Template for power calculation
    writeln("10. Compile-time power calculation:");
    
    template Pow(int base, int exp) {
        static if (exp == 0)
            enum Pow = 1;
        else static if (exp == 1)
            enum Pow = base;
        else
            enum Pow = base * Pow!(base, exp - 1);
    }
    
    writeln("  2^10 = ", Pow!(2, 10));
    writeln("  3^5 = ", Pow!(3, 5));
    writeln("  5^3 = ", Pow!(5, 3));
    writeln();

    writeln("=== Example Complete ===");
}
