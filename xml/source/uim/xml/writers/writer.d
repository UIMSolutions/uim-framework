module uim.xml.writers.writer;

import uim.core;
import dxml.writer;

@safe:

alias StringAppender = Appender!string;

class OOPXMLWriter(T = string) {
    alias StringAppender = Appender!T;

    private StringAppender _appender;
    private XMLWriter!StringAppender _writer;

    private bool _inStartTag = false;
    private string[] _elementStack;

    this() {
        _appender = appender!T;
        _writer = XMLWriter!StringAppender(_appender);
    }

    /// Stellt sicher, dass das aktuelle Start-Tag (mit `>`) geschlossen wird,
    /// bevor Kinder, Text oder das End-Tag geschrieben werden.
    private void ensureStartTagClosed() {
        if (_inStartTag) {
            _writer.closeStartTag();
            _inStartTag = false;
        }
    }

    auto addElement(string name) {
        ensureStartTagClosed();
        _writer.openStartTag(name); // Schreiben von `<name`
        _inStartTag = true;
        _elementStack ~= name;
        return this;
    }

    auto addAttribute(string name, string value) {
        if (_inStartTag) {
            _writer.writeAttr(name, value); // Funktioniert jetzt, da Start-Tag offen ist!
        }
        return this;
    }

    auto addAttributes(string[string] attrs) {
        foreach (name, value; attrs) {
            addAttribute(name, value);
        }
        return this;
    }

    auto endElement() {
        ensureStartTagClosed();
        if (_elementStack.length > 0) {
            string tagName = _elementStack[$ - 1];
            _elementStack.popBack();
            _writer.writeEndTag(tagName);
        }
        return this;
    }

    auto addComment(string text) {
        ensureStartTagClosed();
        _writer.writeComment(text);
        return this;
    }

    auto addText(string content) {
        ensureStartTagClosed();
        _writer.writeText(content);
        return this;
    }

    override string toString() {
        ensureStartTagClosed();
        while (_elementStack.length > 0) {
            endElement();
        }
        return _appender.data.idup;
    }
}

unittest {
    auto writer = new OOPXMLWriter!string();
    writer.addElement("mvc:View")
        .addAttribute("controllerName", "projects.app.controller.App")
        .addAttribute("xmlns:mvc", "sap.ui.core.mvc")
        .addAttributes(["xmlns":"sap.m", 
                        "displayBlock":"true"])
        .addComment("This is a comment")
        .addElement("SplitApp")
        .endElement()
    .endElement();
    writeln(writer.toString());
}

// @safe:
// class XMLWriter(OR = Appender!string) {
//     private XMLWriter!OR* _writer;
//     private OR _output;

//     this(string baseIndent = "    ") {
//         _output = appender!string();
//         _writer = new XMLWriter!OR(_output, baseIndent);
//     }

//     XMLWriter!OR startElement(string name) @safe {
//         _writer.writeStartTag(name);
//         return this;
//     }

//     XMLWriter!OR startElement(string name, string[string] attrs) @safe {
//         _writer.openStartTag(name);
//         foreach (k, v; attrs)
//             _writer.writeAttr(k, v);
//         _writer.closeStartTag();
//         return this;
//     }

//     XMLWriter!OR text(string content) @safe {
//         _writer.writeText(content, Newline.no);
//         return this;
//     }

//     XMLWriter!OR endElement() @safe {
//         _writer.writeEndTag();
//         return this;
//     }

//     XMLWriter!OR comment(string text) @safe {
//         _writer.writeComment(text);
//         return this;
//     }

//     string toString() const @safe {
//         return _output.data;
//     }
// }
// ///
// unittest {
//     auto writer = new XMLWriter!string();
//     writer.startElement("root");
//     writer.text("Hello, World!");
//     writer.endElement();
//     assert(writer.toString() == "<root>Hello, World!</root>");

//     writer.comment("This is a comment");
//     assert(writer.toString() == "<root>Hello, World!</root><!--This is a comment-->");

//     writer.startElement("child", ["attr" : "value"]);
//     writer.endElement();
//     assert(writer.toString() == "<root>Hello, World!</root><!--This is a comment--><child attr=\"value\"></child>");
// }
