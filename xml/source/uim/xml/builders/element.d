module uim.xml.builders.element;

import uim.xml;

@safe:

class XMLElement {
private:
    string _name;
    string _text;
    XMLAttribute[] _attributes;
    XMLElement[] _children;

public:
    this(string name) {
        _name = name;
    }

    @property string name() const {
        return _name;
    }

    bool hasAttribute(string name) const {
        return _attributes.canFind!(a => a.name == name);
    }

    // Returns the value of the attribute with the given name, null if absent
    string attributeValue(string name) const {
        foreach (item; _attributes) {
            if (item.name == name) {
                return item.value;
            }
        }
        return null;
    }

    unittest {
        auto node = element("Label").attribute("id", "nameLabel").attribute("name", "Name");
        assert(node.hasAttribute("id"));
        assert(node.hasAttribute("name"));
        assert(!node.hasAttribute("text"));

        writeln(node.render());
    }

    XMLElement attribute(string name, string value) {
        foreach (ref item; _attributes) {
            if (item.name == name) {
                item.value = value;
                return this;
            }
        }

        _attributes ~= XMLAttribute(name, value);
        return this;
    }

    XMLElement attribute(XMLAttribute value) {
        return attribute(value.name, value.value);
    }

    XMLElement text(string value) {
        _text = value;
        return this;
    }

    XMLElement add(XMLElement child) {
        _children ~= child;
        return this;
    }

    unittest {
        auto node = element("Label");
        node.add(element("Text").attribute("value", "Hello"));
        auto xml = node.render();
        assert(xml.canFind("<Label"));
        assert(xml.canFind("<Text"));
        assert(xml.canFind("value=\"Hello\""));

        // writeln(xml);
        // <Label>
        //     <Text value="Hello"/>
        // </Label>
    }

    XMLElement addIf(bool condition, XMLElement child) {
        if (condition) {
            _children ~= child;
        }
        return this;
    }

    unittest {
        auto node = element("Label").attribute("id", "nameLabel").attribute("text", "Name");
        node.addIf(true, element("Text").attribute("value", "Hello"));
        auto xml = node.render();
        assert(xml.canFind("<Label"));
        assert(xml.canFind("<Text"));
        assert(xml.canFind("value=\"Hello\""));

        // writeln(xml);
        // <Label id="nameLabel" text="Name">
        //   <Text value="Hello"/>
        // </Label>

        node = element("Label").attribute("id", "nameLabel").attribute("text", "Name");
        node.addIf(false, element("Text").attribute("value", "Hello"));
        xml = node.render();
        assert(xml.canFind("<Label"));
        assert(!xml.canFind("<Text"));
        assert(!xml.canFind("value=\"Hello\""));

        // writeln(xml);
        // <Label id="nameLabel" text="Name"/>
    }

    XMLElement withChildren(XMLElement[] children) {
        _children ~= children;
        return this;
    }

    XMLElement[] children() {
        return _children.dup;
    }

    string render(bool pretty = true, size_t indentSize = 2) const {
        auto buf = appender!string();
        renderInto(buf, 0, pretty, indentSize);
        return buf.data;
    }

private:
    static string makeIndent(size_t level, size_t indentSize) {
        auto buf = appender!string();
        foreach (_; 0 .. level * indentSize) {
            buf.put(' ');
        }
        return buf.data;
    }

    void renderInto(ref Appender!string buf, size_t level, bool pretty,
        size_t indentSize) const {
        string indent;
        if (pretty) {
            indent = makeIndent(level, indentSize);
            buf.put(indent);
        }

        buf.put("<");
        buf.put(_name);

        foreach (attribute; _attributes) {
            buf.put(" ");
            buf.put(attribute.name);
            buf.put("=\"");
            buf.put(escapeXml(attribute.value));
            buf.put("\"");
        }

        bool hasChildren = _children.length > 0;
        bool hasText = _text.length > 0;

        if (!hasChildren && !hasText) {
            buf.put("/>");
            if (pretty) {
                buf.put("\n");
            }
            return;
        }

        buf.put(">");

        if (hasText) {
            buf.put(escapeXml(_text));
        }

        if (hasChildren) {
            if (pretty) {
                buf.put("\n");
            }
            foreach (child; _children) {
                child.renderInto(buf, level + 1, pretty, indentSize);
            }
            if (pretty) {
                buf.put(indent);
            }
        }

        buf.put("</");
        buf.put(_name);
        buf.put(">");
        if (pretty) {
            buf.put("\n");
        }
    }
}

XMLElement element(string name) {
    return new XMLElement(name);
}

unittest {
    auto node = element("Label").attribute("id", "nameLabel").attribute("text", "Name");
    auto xml = node.render();
    assert(xml.canFind("<Label"));
    assert(xml.canFind("id=\"nameLabel\""));
}
