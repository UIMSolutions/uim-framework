module uim.core.uda.helpers;

import std.conv : to;
import std.range.primitives : isInputRange, isOutputRange;
import std.traits : getUDAs, hasUDA, isAssociativeArray, isCallable, isSomeString;
import std.typecons : Nullable;

@safe:

template isField(alias symbol) {
    enum isField = !is(symbol) &&
        !isCallable!symbol &&
    __traits(compiles, { alias SymbolType = typeof(symbol); });
}

unittest {
    struct FieldProbe {
        int value;
    }

    static assert(isField!(__traits(getMember, FieldProbe, "value")));
}

/// Checks if the given type is a Nullable type.
template isNullable(T) {
    enum isNullable = is(T : Nullable!U, U);
}

unittest {
    static assert(isNullable!(Nullable!int));
}

/// Checks if the given symbol has the specified user-defined attribute (UDA).
template hasUDA(alias symbol, UDA) {
    enum hasUDA = __traits(compiles, getUDAs!(symbol, UDA)) && getUDAs!(symbol, UDA).length > 0;
}

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

        /// Checks if the first UDA has a name and retrieves it if available.
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