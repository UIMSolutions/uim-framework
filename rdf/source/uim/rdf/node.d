/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rdf.node;

import uim.rdf;
import std.conv;
import std.algorithm;
import std.array;

@safe:

/**
 * RDF Node type
 */
enum RDFNodeType {
    URI,
    Literal,
    BlankNode
}

/**
 * Base class for RDF nodes
 */
abstract class DRDFNode : UIMObject {
    protected RDFNodeType _nodeType;
    
    @property RDFNodeType nodeType() { return _nodeType; }
    @property void nodeType(RDFNodeType value) { _nodeType = value; }
    
    this(RDFNodeType type) {
        super();
        this._nodeType = type;
    }
    
    abstract string toNTriples();
    abstract string toTurtle();
}

/**
 * RDF URI node
 */
class DRDFUri : DRDFNode {
    protected string _uri;
    
    @property string uri() { return _uri; }
    @property void uri(string value) { _uri = value; }
    
    this() {
        super(RDFNodeType.URI);
    }
    
    this(string uriValue) {
        this();
        this._uri = uriValue;
    }
    
    override string toNTriples() {
        return "<" ~ _uri ~ ">";
    }
    
    override string toTurtle() {
        return "<" ~ _uri ~ ">";
    }
    
    override string toString() {
        return _uri;
    }
}

/**
 * RDF Literal node
 */
class DRDFLiteral : DRDFNode {
    protected string _value;
    protected string _datatype;
    protected string _language;
    
    @property string value() { return _value; }
    @property void value(string val) { _value = val; }
    
    @property string datatype() { return _datatype; }
    @property void datatype(string val) { _datatype = val; }
    
    @property string language() { return _language; }
    @property void language(string val) { _language = val; }
    
    this() {
        super(RDFNodeType.Literal);
    }
    
    this(string literalValue) {
        this();
        this._value = literalValue;
    }
    
    this(string literalValue, string lang) {
        this(literalValue);
        this._language = lang;
    }
    
    /**
     * Create typed literal
     */
    static DRDFLiteral typed(T)(T value) {
        auto literal = new DRDFLiteral();
        literal._value = value.to!string;
        
        static if (is(T == int) || is(T == long)) {
            literal._datatype = "http://www.w3.org/2001/XMLSchema#integer";
        } else static if (is(T == double) || is(T == float)) {
            literal._datatype = "http://www.w3.org/2001/XMLSchema#double";
        } else static if (is(T == bool)) {
            literal._datatype = "http://www.w3.org/2001/XMLSchema#boolean";
        }
        
        return literal;
    }
    
    private string escape(string str) @trusted {
        return str
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t");
    }
    
    override string toNTriples() {
        string result = "\"" ~ escape(_value) ~ "\"";
        
        if (_language.length > 0) {
            result ~= "@" ~ _language;
        } else if (_datatype.length > 0) {
            result ~= "^^<" ~ _datatype ~ ">";
        }
        
        return result;
    }
    
    override string toTurtle() {
        return toNTriples();
    }
    
    override string toString() {
        return _value;
    }
}

/**
 * RDF Blank Node
 */
class DRDFBlankNode : DRDFNode {
    protected string _id;
    private static int _counter = 0;
    
    @property string id() { return _id; }
    @property void id(string value) { _id = value; }
    
    this() {
        super(RDFNodeType.BlankNode);
        _counter++;
        this._id = "b" ~ _counter.to!string;
    }
    
    this(string blankId) {
        super(RDFNodeType.BlankNode);
        this._id = blankId;
    }
    
    override string toNTriples() {
        return "_:" ~ _id;
    }
    
    override string toTurtle() {
        return "_:" ~ _id;
    }
    
    override string toString() {
        return "_:" ~ _id;
    }
}
