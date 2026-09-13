module uim.xml.builders.schema;

import std.conv : to;
import uim.xml.builders.attribute : XMLAttribute;
import uim.xml.builders.element : XMLElement, element;

@safe:

/// Converts a size_t value to a string suitable for the "minOccurs" attribute in an XML schema.
private string occurs(size_t value) {
    return to!string(value);
}
unittest {
    assert(occurs(0) == "0");
    assert(occurs(5) == "5");
    assert(maxOccurs(0, false) == "0");
    assert(maxOccurs(5, false) == "5");
    assert(maxOccurs(0, true) == "unbounded");
}

/// Converts a size_t value to a string suitable for the "maxOccurs" attribute in an XML schema. If `unbounded` is true, returns "unbounded".
private string maxOccurs(size_t value, bool unbounded) {
    return unbounded ? "unbounded" : to!string(value);
}
unittest {
    assert(maxOccurs(0, false) == "0");
    assert(maxOccurs(5, false) == "5");
    assert(maxOccurs(0, true) == "unbounded");
}

// class SchemaDocument {
// private:
//     XMLElement _root;

// public:
//     this(string targetNamespace = "", string prefix = "tns") {
//         _root = element("xs:schema")
//             .attribute(XMLAttribute("xmlns:xs", "http://www.w3.org/2001/XMLSchema"))
//             .attribute(XMLAttribute("elementFormDefault", "qualified"));

//         if (targetNamespace.length) {
//             _root.attribute("targetNamespace", targetNamespace);
//             _root.attribute("xmlns:" ~ prefix, targetNamespace);
//         }
//     }

//     SchemaDocument add(XMLElement node) {
//         _root.add(node);
//         return this;
//     }

//     SchemaDocument include(string schemaLocation) {
//         _root.add(element("xs:include")
//             .attribute("schemaLocation", schemaLocation));
//         return this;
//     }

//     SchemaDocument importSchema(string namespaceUri, string schemaLocation = "") {
//         auto node = element("xs:import")
//             .attribute("namespace", namespaceUri);

//         if (schemaLocation.length) {
//             node.attribute("schemaLocation", schemaLocation);
//         }

//         _root.add(node);
//         return this;
//     }

//     string render(bool pretty = true, size_t indentSize = 2) const {
//         return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
//             ~ _root.render(pretty, indentSize);
//     }

//     XMLElement node() const {
//         return _root;
//     }
// }

// class ComplexType {
// private:
//     XMLElement _node;

// public:
//     this(string name, bool mixed = false) {
//         _node = element("xs:complexType")
//             .attribute("name", name);

//         if (mixed) {
//             _node.attribute("mixed", "true");
//         }
//     }

//     ComplexType sequence() {
//         _node.add(element("xs:sequence"));
//         return this;
//     }

//     ComplexType element(
//         string name,
//         string type = "",
//         size_t minOccurs = 1,
//         size_t maxOccursValue = 1,
//         bool unbounded = false)
//     {
//         auto child = element("xs:element")
//             .attribute("name", name)
//             .attribute("minOccurs", occurs(minOccurs))
//             .attribute("maxOccurs", maxOccurs(maxOccursValue, unbounded));

//         if (type.length) {
//             child.attribute("type", type);
//         }

//         auto children = _node.children();
//         if (children.length && children[$ - 1].name == "xs:sequence") {
//             children[$ - 1].add(child);
//         } else {
//             _node.add(child);
//         }

//         return this;
//     }

//     ComplexType attribute(
//         string name,
//         string type = "xs:string",
//         string use = "optional")
//     {
//         _node.add(element("xs:attribute")
//             .attribute("name", name)
//             .attribute("type", type)
//             .attribute("use", use));

//         return this;
//     }

//     XMLElement node() const {
//         return _node;
//     }
// }

// class SimpleType {
// private:
//     XMLElement _node;

// public:
//     this(string name, string baseType) {
//         _node = element("xs:simpleType")
//             .attribute("name", name)
//             .add(element("xs:restriction")
//                 .attribute("base", baseType));
//     }

//     SimpleType enumeration(string value) {
//         auto children = _node.children();
//         children[$ - 1].add(element("xs:enumeration")
//             .attribute("value", value));
//         return this;
//     }

//     SimpleType pattern(string expression) {
//         auto children = _node.children();
//         children[$ - 1].add(element("xs:pattern")
//             .attribute("value", expression));
//         return this;
//     }

//     SimpleType minLength(size_t value) {
//         auto children = _node.children();
//         children[$ - 1].add(element("xs:minLength")
//             .attribute("value", to!string(value)));
//         return this;
//     }

//     SimpleType maxLength(size_t value) {
//         auto children = _node.children();
//         children[$ - 1].add(element("xs:maxLength")
//             .attribute("value", to!string(value)));
//         return this;
//     }

//     XMLElement node() const {
//         return _node;
//     }
// }

// XMLElement schemaElement(
//     string name,
//     string type = "",
//     size_t minOccurs = 1,
//     size_t maxOccursValue = 1,
//     bool unbounded = false)
// {
//     auto node = element("xs:element")
//         .attribute("name", name)
//         .attribute("minOccurs", occurs(minOccurs))
//         .attribute("maxOccurs", maxOccurs(maxOccursValue, unbounded));

//     if (type.length) {
//         node.attribute("type", type);
//     }

//     return node;
// }

// XMLElement complexType(ComplexType value) {
//     return value.node();
// }

// XMLElement simpleType(SimpleType value) {
//     return value.node();
// }