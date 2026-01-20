/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rdf.graph;

import uim.rdf;
import std.algorithm;
import std.array;
import std.conv;

@safe:

/**
 * RDF Graph - a collection of RDF triples
 */
class DRDFGraph : UIMObject {
    protected DRDFTriple[] _triples;
    protected DRDFNamespace[string] _namespaces;
    protected string _baseUri;
    
    @property DRDFTriple[] triples() { return _triples; }
    @property void triples(DRDFTriple[] value) { _triples = value; }
    
    @property DRDFNamespace[string] namespaces() { return _namespaces; }
    
    @property string baseUri() { return _baseUri; }
    @property void baseUri(string value) { _baseUri = value; }
    
    this() {
        super();
        _triples = [];
        _namespaces = null;
    }
    
    this(string base) {
        this();
        this._baseUri = base;
    }
    
    /**
     * Add a namespace
     */
    void addNamespace(DRDFNamespace ns) {
        _namespaces[ns.prefix] = ns;
    }
    
    /**
     * Add a namespace by prefix and URI
     */
    void addNamespace(string prefix, string uri) {
        _namespaces[prefix] = new DRDFNamespace(prefix, uri);
    }
    
    /**
     * Get namespace by prefix
     */
    DRDFNamespace getNamespace(string prefix) {
        if (prefix in _namespaces) {
            return _namespaces[prefix];
        }
        return null;
    }
    
    /**
     * Add a triple to the graph
     */
    void add(DRDFTriple triple) {
        _triples ~= triple;
    }
    
    /**
     * Add a triple from components
     */
    void add(DRDFNode subject, DRDFUri predicate, DRDFNode object) {
        _triples ~= new DRDFTriple(subject, predicate, object);
    }
    
    /**
     * Add a triple from URI strings
     */
    void add(string subjUri, string predUri, string objUri) {
        add(new DRDFUri(subjUri), new DRDFUri(predUri), new DRDFUri(objUri));
    }
    
    /**
     * Add a triple with literal object
     */
    void addLiteral(string subjUri, string predUri, string literal) {
        add(new DRDFUri(subjUri), new DRDFUri(predUri), new DRDFLiteral(literal));
    }
    
    /**
     * Add a triple with typed literal
     */
    void addTypedLiteral(T)(string subjUri, string predUri, T value) {
        add(new DRDFUri(subjUri), new DRDFUri(predUri), DRDFLiteral.typed(value));
    }
    
    /**
     * Find triples matching a pattern (null matches anything)
     */
    DRDFTriple[] find(DRDFNode subject = null, DRDFUri predicate = null, DRDFNode object = null) {
        DRDFTriple[] results;
        foreach (triple; _triples) {
            if (triple.matches(subject, predicate, object)) {
                results ~= triple;
            }
        }
        return results;
    }
    
    /**
     * Get all subjects
     */
    DRDFNode[] subjects() {
        DRDFNode[] results;
        bool[string] seen;
        
        foreach (triple; _triples) {
            string key = triple.subject.toString();
            if (key !in seen) {
                seen[key] = true;
                results ~= triple.subject;
            }
        }
        return results;
    }
    
    /**
     * Get all predicates
     */
    DRDFUri[] predicates() {
        DRDFUri[] results;
        bool[string] seen;
        
        foreach (triple; _triples) {
            string key = triple.predicate.toString();
            if (key !in seen) {
                seen[key] = true;
                results ~= triple.predicate;
            }
        }
        return results;
    }
    
    /**
     * Get all objects
     */
    DRDFNode[] objects() {
        DRDFNode[] results;
        bool[string] seen;
        
        foreach (triple; _triples) {
            string key = triple.object.toString();
            if (key !in seen) {
                seen[key] = true;
                results ~= triple.object;
            }
        }
        return results;
    }
    
    /**
     * Number of triples in the graph
     */
    size_t size() {
        return _triples.length;
    }
    
    /**
     * Clear all triples
     */
    void clear() {
        _triples = [];
    }
    
    /**
     * Remove triples matching a pattern
     */
    void remove(DRDFNode subject = null, DRDFUri predicate = null, DRDFNode object = null) {
        _triples = _triples.filter!(t => !t.matches(subject, predicate, object)).array;
    }
}
