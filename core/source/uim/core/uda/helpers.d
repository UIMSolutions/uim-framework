module uim.core.uda.helpers;

import std.conv : to;
import std.range.primitives : isInputRange, isOutputRange;
import std.traits;
import std.typecons : Nullable;
import std.traits : Unqual, isInstanceOf;

@safe:

/// Checks if the given symbol represents a field (i.e., not a type, not callable, and can be compiled).
import std.traits : isCallable;

template isField(alias symbol) {
    enum isField = !is(symbol) &&
        !isCallable!symbol &&
        __traits(compiles, { alias Temp = typeof(symbol); }) &&
        !__traits(isTemplate, symbol);
}

version (unittest) {
    // Mock definitions for test cases
    struct TestStruct {
        int memberVar;
        string stringVar;
        static double staticVar;
        enum int manifestConstant = 100;

        void memberFunc() {
        }

        int propertyFunc() @property {
            return 42;
        }
    }

    class TestClass {
        int classVar;
        static TestStruct classStaticStruct;

        void classMethod() {
        }
    }

    int globalVar = 10;
    const float globalConst = 3.14f;
    immutable int globalImmutable = 42;

    void globalFunc() {
    }

    int globalProp() @property {
        return 1;
    }

    template TestTemplate(T) {
        T innerVar;
    }
}

unittest {
    // ==========================================
    // Positive Cases (Should ALL evaluate to true)
    // ==========================================

    // Struct and Class instance fields (accessed via type name)
    static assert(isField!(TestStruct.memberVar));
    static assert(isField!(TestStruct.stringVar));
    static assert(isField!(TestClass.classVar));

    // Static fields
    static assert(isField!(TestStruct.staticVar));
    static assert(isField!(TestClass.classStaticStruct));

    // Global and local variables
    static assert(isField!globalVar);
    static assert(isField!globalConst);
    static assert(isField!globalImmutable);

    int localVar = 5;
    static assert(isField!localVar);

    const string localConst = "test";
    static assert(isField!localConst);

    // Manifest constants (enums)
    static assert(isField!(TestStruct.manifestConstant));

    // Aliases pointing to fields
    alias FieldAlias = TestStruct.memberVar;
    static assert(isField!FieldAlias);

    // ==========================================
    // Negative Cases (Should ALL evaluate to false)
    // ==========================================

    // Basic types and aggregate types
    static assert(!isField!int);
    static assert(!isField!string);
    static assert(!isField!void);
    static assert(!isField!TestStruct);
    static assert(!isField!TestClass);

    // Type aliases
    alias IntAlias = int;
    alias StructAlias = TestStruct;
    static assert(!isField!IntAlias);
    static assert(!isField!StructAlias);

    // Functions and methods
    static assert(!isField!globalFunc);
    static assert(!isField!(TestStruct.memberFunc));
    static assert(!isField!(TestClass.classMethod));

    // @property methods (should be treated as callables, not fields)
    static assert(!isField!globalProp);
    static assert(!isField!(TestStruct.propertyFunc));

    // Function pointers and Delegates
    void function() fnPtr;
    static assert(!isField!fnPtr);

    void delegate() dg;
    static assert(!isField!dg);

    // Templates and Modules
    static assert(!isField!TestTemplate);

    import std.stdio;

    static assert(!isField!std);
}

import std.typecons : Nullable;
import std.traits : Unqual;

/// Checks if the given type is a Nullable type.
template isNullable(T) {
    alias U = Unqual!T;
    enum isNullable = __traits(compiles, {
            U value = U.init;
            bool n = value.isNull;
            auto g = value.get;
        });
}
///
unittest {
    static assert(isNullable!(Nullable!int));
    static assert(isNullable!(Nullable!string));
    static assert(isNullable!(const(Nullable!int))); // Qualifier check

    static assert(!isNullable!int);
    static assert(!isNullable!string);
    static assert(!isNullable!(int*));
}

/// Checks if the given symbol has the specified user-defined attribute (UDA).
template hasUDA(alias symbol, UDA) {
    enum hasUDA = __traits(compiles, getUDAs!(symbol, UDA)) && getUDAs!(symbol, UDA).length > 0;
}
///
unittest {
    struct AttrTag {
        string name;
    }

    struct UDATest {
        @AttrTag("attr")
        int attr;
    }

    static assert(hasUDA!(__traits(getMember, UDATest, "attr"), AttrTag));
}

/// Retrieves the value of the specified user-defined attribute (UDA) for the given symbol.
/// If the UDA is not present or does not have a name, the fallbackName is returned.
template getUDAValue(alias symbol, UDA, string fallbackName) {
    static if (hasUDA!(symbol, UDA)) {

        /// Retrieves the first UDA of the specified type for the given symbol.
        alias firstUDA = getUDAs!(symbol, UDA)[0];
        static if (__traits(compiles, { enum n = firstUDA.name; })) {
                    /// Attempt to retrieve the name of the first UDA if it exists.
                    enum nameValue = firstUDA.name;

                    /// Checks if the retrieved name is not empty and uses it; otherwise, falls back to the provided fallbackName.
                    static if (nameValue != "")
                        enum getUDAValue = nameValue;
                    else
                        enum getUDAValue = fallbackName;
                } else {
                enum getUDAValue = fallbackName;
            }
            } else {
                enum getUDAValue = fallbackName;
            }
            }

            unittest {
                struct TestUda {
                    string name;
                }

                struct TestUda2 {
                    string name;
                }

                struct UDATest {
                    @TestUda("customName")
                    @TestUda2("aname")
                    int attr;

                    int anotherAttr;
                }

                static assert(getUDAValue!(__traits(getMember, UDATest, "attr"), TestUda, "fallback") == "customName");
                static assert(getUDAValue!(__traits(getMember, UDATest, "anotherAttr"), TestUda, "fallback") == "fallback");
            }
