/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.soap.header;

import uim.soap;
import std.algorithm;
import std.array;

@safe:

/**
 * SOAP Header element
 */
class DSOAPHeaderElement : UIMObject {
    protected string _name;
    protected string _namespace;
    protected string _content;
    protected bool _mustUnderstand;
    protected string _actor;
    
    @property string name() { return _name; }
    @property void name(string value) { _name = value; }
    
    @property string namespace() { return _namespace; }
    @property void namespace(string value) { _namespace = value; }
    
    @property string content() { return _content; }
    @property void content(string value) { _content = value; }
    
    @property bool mustUnderstand() { return _mustUnderstand; }
    @property void mustUnderstand(bool value) { _mustUnderstand = value; }
    
    @property string actor() { return _actor; }
    @property void actor(string value) { _actor = value; }
    
    this() {
        super();
        this._mustUnderstand = false;
    }
    
    this(string elementName, string elementContent) {
        this();
        this._name = elementName;
        this._content = elementContent;
    }
    
    this(string elementName, string elementNamespace, string elementContent) {
        this(elementName, elementContent);
        this._namespace = elementNamespace;
    }
    
    private string escapeXML(string text) @trusted {
        return text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&apos;");
    }
    
    /**
     * Convert to XML
     */
    string toXML(int indent, SOAPVersion ver) {
        string ind = "  ".replicate(indent);
        string result = ind;
        string prefix = ver == SOAPVersion.SOAP11 ? "soap" : "env";
        
        // Start tag
        if (_namespace.length > 0) {
            result ~= "<" ~ _name ~ " xmlns=\"" ~ _namespace ~ "\"";
        } else {
            result ~= "<" ~ _name;
        }
        
        // Add mustUnderstand attribute
        if (_mustUnderstand) {
            if (ver == SOAPVersion.SOAP11) {
                result ~= " " ~ prefix ~ ":mustUnderstand=\"1\"";
            } else {
                result ~= " " ~ prefix ~ ":mustUnderstand=\"true\"";
            }
        }
        
        // Add actor/role attribute
        if (_actor.length > 0) {
            if (ver == SOAPVersion.SOAP11) {
                result ~= " " ~ prefix ~ ":actor=\"" ~ escapeXML(_actor) ~ "\"";
            } else {
                result ~= " " ~ prefix ~ ":role=\"" ~ escapeXML(_actor) ~ "\"";
            }
        }
        
        result ~= ">" ~ escapeXML(_content) ~ "</" ~ _name ~ ">\n";
        
        return result;
    }
}

/**
 * SOAP Header
 */
class DSOAPHeader : UIMObject {
    protected DSOAPHeaderElement[] _elements;
    
    @property DSOAPHeaderElement[] elements() { return _elements; }
    @property void elements(DSOAPHeaderElement[] value) { _elements = value; }
    
    this() {
        super();
        _elements = [];
    }
    
    /**
     * Add header element
     */
    void addElement(DSOAPHeaderElement element) {
        _elements ~= element;
    }
    
    /**
     * Add simple header element
     */
    void addElement(string name, string content) {
        _elements ~= new DSOAPHeaderElement(name, content);
    }
    
    /**
     * Check if header is empty
     */
    bool isEmpty() {
        return _elements.length == 0;
    }
    
    /**
     * Convert to XML
     */
    string toXML(int indent, SOAPVersion ver) {
        if (isEmpty()) {
            return "";
        }
        
        string ind = "  ".replicate(indent);
        string prefix = ver == SOAPVersion.SOAP11 ? "soap" : "env";
        string result = ind ~ "<" ~ prefix ~ ":Header>\n";
        
        foreach (element; _elements) {
            result ~= element.toXML(indent + 1, ver);
        }
        
        result ~= ind ~ "</" ~ prefix ~ ":Header>\n";
        
        return result;
    }
}
