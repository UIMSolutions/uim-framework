/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rdf.namespace;

import uim.rdf;
import std.algorithm;
import std.array;

@safe:

/**
 * RDF Namespace
 */
class DRDFNamespace : UIMObject {
    protected string _prefix;
    protected string _uri;
    
    @property string prefix() { return _prefix; }
    @property void prefix(string value) { _prefix = value; }
    
    @property string uri() { return _uri; }
    @property void uri(string value) { _uri = value; }
    
    this() {
        super();
    }
    
    this(string nsPrefix, string nsUri) {
        this();
        this._prefix = nsPrefix;
        this._uri = nsUri;
    }
    
    /**
     * Expand a prefixed name to full URI
     */
    string expand(string localName) {
        return _uri ~ localName;
    }
    
    /**
     * Check if a URI belongs to this namespace
     */
    bool contains(string fullUri) {
        return fullUri.startsWith(_uri);
    }
    
    /**
     * Get the local name from a full URI
     */
    string getLocalName(string fullUri) {
        if (contains(fullUri)) {
            return fullUri[_uri.length .. $];
        }
        return "";
    }
}

// Common RDF namespaces
class CommonNamespaces {
    static DRDFNamespace RDF() {
        return new DRDFNamespace("rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
    }
    
    static DRDFNamespace RDFS() {
        return new DRDFNamespace("rdfs", "http://www.w3.org/2000/01/rdf-schema#");
    }
    
    static DRDFNamespace OWL() {
        return new DRDFNamespace("owl", "http://www.w3.org/2002/07/owl#");
    }
    
    static DRDFNamespace XSD() {
        return new DRDFNamespace("xsd", "http://www.w3.org/2001/XMLSchema#");
    }
    
    static DRDFNamespace DC() {
        return new DRDFNamespace("dc", "http://purl.org/dc/elements/1.1/");
    }
    
    static DRDFNamespace DCTERMS() {
        return new DRDFNamespace("dcterms", "http://purl.org/dc/terms/");
    }
    
    static DRDFNamespace FOAF() {
        return new DRDFNamespace("foaf", "http://xmlns.com/foaf/0.1/");
    }
    
    static DRDFNamespace SKOS() {
        return new DRDFNamespace("skos", "http://www.w3.org/2004/02/skos/core#");
    }
}
