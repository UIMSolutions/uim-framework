/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.attributes.attribute;

import uim.htmls;

@safe:

/// Represents an HTML attribute with name and value
class DHtmlAttribute : /* UIMObject, */ IHtmlAttribute {
    protected string _name;
    protected string _value;

    // Getter for name
    override string name() { return _name; }
    
    // Setter for name
    override IHtmlAttribute name(string value) { _name = value; return this; }
    
    // Getter for value
    override string value() { return _value; }
    
    // Setter for value
    override IHtmlAttribute value(string val) { _value = val; return this; }

    this() {
        // super();
    }

    this(string attributeName, string attributeValue = null) {
        this();
        this.name(attributeName);
        this.value(attributeValue);
    }

    /// Convert attribute to string representation
    override string toString() {
        if (_value.length == 0) {
            return _name;
        }
        return _name ~ `="` ~ _value ~ `"`;
    }

    /// Create a new attribute
    static IHtmlAttribute create(string name, string value = null) {
        return new DHtmlAttribute(name, value);
    }
}

auto HtmlAttribute() { return new DHtmlAttribute(); }
auto HtmlAttribute(string name, string value = null) { return new DHtmlAttribute(name, value); }

unittest {
    auto attr = HtmlAttribute("class", "test");
    assert(attr.name == "class");
    assert(attr.value == "test");
    assert(attr.toString() == `class="test"`);
}
