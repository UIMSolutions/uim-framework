module uim.xml.writers.reflexive;

import dxml.writer;
import std.conv : to;
import std.range.primitives : isInputRange, isOutputRange;
import std.traits : getUDAs, hasUDA, isAssociativeArray, isCallable, isSomeString;
import std.typecons : Nullable;
import uim.xml.writers.uda;
import uim.core.uda.helpers : isField, isNullable, getUDAValue;

@safe:

// --- Die selbstreflektierende Writer-Klasse ---

final class ReflectiveXmlWriter(Output) if (isOutputRange!(Output, char)) {
    private XMLWriter!Output writer;

    this(Output output) {
        this.writer = xmlWriter(output);
    }

    /// Schreibt ein beliebiges struct/class T als XML-Element mit gegebenem Tag-Namen.
    void write(T)(string tagName, auto ref T value)
            if (is(T == struct) || is(T == class)) {
        static if (is(T == class)) {
            if (value is null)
                return;
        }

        writer.openStartTag(tagName);
        writeAttributes(value);
        writer.closeStartTag();
        writeChildren(value);
        writer.writeEndTag(tagName);
    }

private:

    // 1. Pass: alle @XmlAttribute-Felder als Attribute schreiben
    void writeAttributes(T)(auto ref T value) {
        static foreach (string member; __traits(allMembers, T)) {
            {
                // Verhindert Compile-Fehler bei privaten oder ungültigen Symbolen
                static if (__traits(compiles, __traits(getMember, value, member))) {
                    alias field = __traits(getMember, T, member);

                    static if (isField!field && !hasUDA!(field, XmlIgnore)) {
                        static if (hasUDA!(field, XmlAttribute)) {
                            enum attrName = getUDAValue!(field, XmlAttribute, member);
                            auto fieldValue = __traits(getMember, value, member);

                            // Nullable Support
                            static if (isNullable!(typeof(fieldValue))) {
                                if (!fieldValue.isNull_)
                                    writer.writeAttr(attrName, fieldValue.get.to!string);
                            } else {
                                writer.writeAttr(attrName, fieldValue.to!string);
                            }
                        }
                    }
                }
            }
        }
    }

    // 2. Pass: alle übrigen Felder als Kind-Elemente (oder Text) schreiben
    void writeChildren(T)(auto ref T value) {

        /// Writes all child elements (or text) for the given value.
        static foreach (string member; __traits(allMembers, T)) {
            {
                static if (__traits(compiles, __traits(getMember, value, member))) {
                    alias field = __traits(getMember, T, member);

                    /// Determines if the current field should be written as a child element.
                    static if (isField!field && !hasUDA!(field, XmlIgnore) && !hasUDA!(field, XmlAttribute)) {
                        auto fieldValue = __traits(getMember, value, member);
                        alias FieldType = typeof(fieldValue);
                        enum elemName = getUDAValue!(field, XmlElement, member);

                        /// Writes the current field as a child element or text based on its attributes and type.
                        static if (hasUDA!(field, XmlText)) {
                            writer.writeText(fieldValue.to!string);
                        } else static if (isNullable!FieldType) {
                            if (!fieldValue.isNull_)
                                writeTypedValue(elemName, fieldValue.get);
                        } else {
                            writeTypedValue(elemName, fieldValue);
                        }
                    }
                }
            }
        }
    }

    // Hilfsmethode zur Typunterscheidung der Felder
    void writeTypedValue(V)(string tag, auto ref V val) {
        static if (is(V == class)) {
            if (val !is null)
                write(tag, val);
        } else static if (is(V == struct)) {
            write(tag, val);
        } else static if (isInputRange!V && !isSomeString!V) {
            // Unterstützt Dynamic Arrays, Static Arrays, Slices und custom Ranges
            foreach (ref item; val) {
                writeTypedValue(tag, item);
            }
        } else static if (isAssociativeArray!V) {
            // Formatiert AAs als Liste von Key-Value-Einträgen
            writer.writeStartTag(tag);
            foreach (key, ref item; val) {
                writer.writeStartTag("entry");
                writer.writeAttr("key", key.to!string);
                writeTypedValue("value", item);
                writer.writeEndTag("entry");
            }
            writer.writeEndTag(tag);
        } else {
            // Primitiver Typ / String / Enum
            writer.writeTaggedText(tag, val.to!string);
        }
    }
}
// --- Meta-Programming / CTFE Helpers ---

/// Convenience-Factory Analog zu dxml.writer.xmlWriter
auto reflectiveXmlWriter(Output)(Output output) {
    return new ReflectiveXmlWriter!Output(output);
}

unittest {
    import std.algorithm.searching : canFind;

    class StringSink {
        string data;

        @safe void put(char ch) {
            data ~= ch;
        }

        @safe void put(const(char)[] text) {
            data ~= text;
        }
    }

    struct Root {
        @XmlText string text;
    }

    auto output = new StringSink();
    auto writer = reflectiveXmlWriter(output);
    writer.write("root", Root("Hello, World!"));

    assert(output.data.canFind("<root"));
    assert(output.data.canFind("Hello, World!"));
    assert(output.data.canFind("</root>"));

    // import std.stdio : writeln;
    // writeln(output.data);

    // Resulting XML:
    // <root>
    //     Hello, World!
    // </root>

    auto output2 = new StringSink();
    auto writer2 = reflectiveXmlWriter(output2);
    writer2.write("root", Root("Hello, World!"));

    // import std.stdio : writeln;
    // writeln(output.data);

    // Resulting XML:
    // <root>
    //     Hello, World!
    // </root>

    assert(output2.data.canFind("<root"));
    assert(output2.data.canFind("Hello, World!"));
    assert(output2.data.canFind("</root>"));

    struct Root2 {
        @XmlElement
        string element;

        @XmlAttribute
        string attribute;

        @XmlElement
        string anotherElement;

        @XmlElement
        string yetAnotherElement;

        @XmlIgnore
        string ignoredElement;

        @XmlText string text;
    }

    auto output3 = new StringSink();
    auto writer3 = reflectiveXmlWriter(output3);
    writer3.write("root2", Root2("elementValue", "attributeValue", "anotherElementValue", "yetAnotherElementValue", "ignoredElementValue", "Text content"));

    assert(output3.data.canFind("<root2"));
    assert(output3.data.canFind("elementValue"));
    assert(output3.data.canFind("attributeValue"));
    assert(output3.data.canFind("anotherElementValue"));
    assert(output3.data.canFind("yetAnotherElementValue"));
    assert(!output3.data.canFind("ignoredElementValue"));
    assert(output3.data.canFind("Text content"));

}
