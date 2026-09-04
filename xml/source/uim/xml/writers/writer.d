module uim.xml.writers.writer;

import dxml.writer;

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
