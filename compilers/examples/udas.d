/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module compilers.examples.udas;

import std.stdio;
import std.traits;

void main() {
    writeln("=== User Defined Attributes (UDAs) Example ===\n");

    // Example 1: Simple marker UDAs
    writeln("1. Simple marker attributes:");
    
    struct Deprecated { }
    struct Experimental { }
    
    @Deprecated
    void oldFunction() {
        writeln("  This is an old function");
    }
    
    @Experimental
    void newFunction() {
        writeln("  This is a new experimental function");
    }
    
    writeln("  oldFunction has @Deprecated: ", hasUDA!(oldFunction, Deprecated));
    writeln("  newFunction has @Experimental: ", hasUDA!(newFunction, Experimental));
    writeln();

    // Example 2: UDAs with parameters
    writeln("2. Attributes with parameters:");
    
    struct Author {
        string name;
        string email;
    }
    
    @Author("John Doe", "john@example.com")
    struct MyClass {
        int value;
    }
    
    enum author = getUDAs!(MyClass, Author)[0];
    writeln("  MyClass author: ", author.name, " (", author.email, ")");
    writeln();

    // Example 3: Multiple UDAs on same symbol
    writeln("3. Multiple attributes:");
    
    struct Version {
        int major;
        int minor;
    }
    
    struct License {
        string name;
    }
    
    @Version(1, 0)
    @License("MIT")
    @Author("Jane Smith", "jane@example.com")
    struct Package {
        string name;
    }
    
    enum version_ = getUDAs!(Package, Version)[0];
    enum license = getUDAs!(Package, License)[0];
    enum packageAuthor = getUDAs!(Package, Author)[0];
    
    writeln("  Package metadata:");
    writeln("    Version: ", version_.major, ".", version_.minor);
    writeln("    License: ", license.name);
    writeln("    Author: ", packageAuthor.name);
    writeln();

    // Example 4: UDAs on struct members
    writeln("4. Attributes on struct members:");
    
    struct Serializable { }
    struct MaxLength {
        int length;
    }
    
    struct User {
        @Serializable
        string username;
        
        @Serializable
        @MaxLength(100)
        string email;
        
        string password; // Not serializable
    }
    
    writeln("  User struct field annotations:");
    foreach (i, member; __traits(allMembers, User)) {
        alias field = __traits(getMember, User, member);
        static if (is(typeof(field))) {
            writeln("    ", member, ":");
            writeln("      Has @Serializable: ", hasUDA!(field, Serializable));
            static if (hasUDA!(field, MaxLength)) {
                enum maxLen = getUDAs!(field, MaxLength)[0];
                writeln("      Max length: ", maxLen.length);
            }
        }
    }
    writeln();

    // Example 5: Validation using UDAs
    writeln("5. Validation with attributes:");
    
    struct Range {
        int min;
        int max;
    }
    
    struct Positive { }
    
    struct Product {
        @Range(0, 100)
        int quantity;
        
        @Positive
        @Range(0, 10000)
        double price;
        
        string name;
    }
    
    bool validate(T)(T instance) {
        bool valid = true;
        foreach (i, member; __traits(allMembers, T)) {
            alias field = __traits(getMember, T, member);
            static if (is(typeof(field))) {
                auto value = __traits(getMember, instance, member);
                
                static if (hasUDA!(field, Range)) {
                    enum range = getUDAs!(field, Range)[0];
                    static if (is(typeof(value) : real)) {
                        if (value < range.min || value > range.max) {
                            writeln("    Validation failed: ", member, " (", value, ") not in range [", range.min, ", ", range.max, "]");
                            valid = false;
                        }
                    }
                }
                
                static if (hasUDA!(field, Positive)) {
                    static if (is(typeof(value) : real)) {
                        if (value <= 0) {
                            writeln("    Validation failed: ", member, " (", value, ") must be positive");
                            valid = false;
                        }
                    }
                }
            }
        }
        return valid;
    }
    
    auto validProduct = Product(50, 99.99, "Widget");
    auto invalidProduct = Product(150, -10.0, "Gadget");
    
    writeln("  Validating valid product:");
    if (validate(validProduct)) {
        writeln("    ✓ Product is valid");
    }
    
    writeln("  Validating invalid product:");
    if (!validate(invalidProduct)) {
        writeln("    ✗ Product validation failed");
    }
    writeln();

    // Example 6: Custom serialization using UDAs
    writeln("6. Custom serialization with attributes:");
    
    struct JsonName {
        string name;
    }
    
    struct Ignore { }
    
    struct Employee {
        @JsonName("full_name")
        string name;
        
        @JsonName("years")
        int age;
        
        @Ignore
        string internalId;
        
        double salary;
    }
    
    string toJson(T)(T instance) {
        string result = "{";
        bool first = true;
        
        foreach (i, member; __traits(allMembers, T)) {
            alias field = __traits(getMember, T, member);
            static if (is(typeof(field))) {
                static if (!hasUDA!(field, Ignore)) {
                    if (!first) result ~= ", ";
                    first = false;
                    
                    static if (hasUDA!(field, JsonName)) {
                        enum jsonName = getUDAs!(field, JsonName)[0];
                        result ~= "\"" ~ jsonName.name ~ "\": ";
                    } else {
                        result ~= "\"" ~ member ~ "\": ";
                    }
                    
                    auto value = __traits(getMember, instance, member);
                    static if (is(typeof(value) == string)) {
                        result ~= "\"" ~ value ~ "\"";
                    } else {
                        import std.conv : to;
                        result ~= value.to!string;
                    }
                }
            }
        }
        
        result ~= "}";
        return result;
    }
    
    auto employee = Employee("Alice Johnson", 30, "EMP001", 75000.0);
    writeln("  Employee serialization:");
    writeln("    ", toJson(employee));
    writeln();

    // Example 7: HTTP route annotations
    writeln("7. HTTP routing attributes:");
    
    struct Route {
        string path;
        string method;
    }
    
    struct Controller {
        @Route("/users", "GET")
        void listUsers() {
            writeln("    Listing all users...");
        }
        
        @Route("/users/:id", "GET")
        void getUser() {
            writeln("    Getting user by ID...");
        }
        
        @Route("/users", "POST")
        void createUser() {
            writeln("    Creating new user...");
        }
    }
    
    writeln("  Controller routes:");
    foreach (member; __traits(allMembers, Controller)) {
        static if (is(typeof(__traits(getMember, Controller, member)))) {
            alias method = __traits(getMember, Controller, member);
            static if (hasUDA!(method, Route)) {
                enum route = getUDAs!(method, Route)[0];
                writeln("    ", route.method, " ", route.path, " -> ", member);
            }
        }
    }
    writeln();

    // Example 8: Dependency injection markers
    writeln("8. Dependency injection attributes:");
    
    struct Inject { }
    struct Singleton { }
    
    @Singleton
    class DatabaseService {
        void connect() {
            writeln("    Database connected");
        }
    }
    
    class UserService {
        @Inject
        DatabaseService db;
        
        void saveUser() {
            writeln("    Saving user to database...");
        }
    }
    
    writeln("  UserService dependencies:");
    foreach (i, member; __traits(allMembers, UserService)) {
        alias field = __traits(getMember, UserService, member);
        static if (is(typeof(field))) {
            static if (hasUDA!(field, Inject)) {
                writeln("    ", member, " is marked for injection");
            }
        }
    }
    writeln();

    writeln("=== Example Complete ===");
}
