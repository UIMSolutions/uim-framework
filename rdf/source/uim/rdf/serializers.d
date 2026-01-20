/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rdf.serializers;

import uim.rdf;
import std.algorithm;
import std.array;

@safe:

/**
 * N-Triples serializer
 */
class DNTriplesSerializer {
    /**
     * Serialize graph to N-Triples format
     */
    static string serialize(DRDFGraph graph) {
        string result = "";
        foreach (triple; graph.triples) {
            result ~= triple.toNTriples() ~ "\n";
        }
        return result;
    }
}

/**
 * Turtle serializer
 */
class DTurtleSerializer {
    /**
     * Serialize graph to Turtle format
     */
    static string serialize(DRDFGraph graph) @trusted {
        string result = "";
        
        // Add base URI if present
        if (graph.baseUri.length > 0) {
            result ~= "@base <" ~ graph.baseUri ~ "> .\n";
        }
        
        // Add namespace prefixes
        foreach (prefix, ns; graph.namespaces) {
            result ~= "@prefix " ~ prefix ~ ": <" ~ ns.uri ~ "> .\n";
        }
        
        if (graph.namespaces.length > 0 || graph.baseUri.length > 0) {
            result ~= "\n";
        }
        
        // Group triples by subject
        DRDFTriple[][string] bySubject;
        foreach (triple; graph.triples) {
            string subjKey = triple.subject.toString();
            if (subjKey !in bySubject) {
                bySubject[subjKey] = [];
            }
            bySubject[subjKey] ~= triple;
        }
        
        // Serialize grouped triples
        foreach (subjKey, triples; bySubject) {
            if (triples.length == 0) continue;
            
            // Write subject once
            result ~= triples[0].subject.toTurtle() ~ "\n";
            
            // Group by predicate
            DRDFTriple[][string] byPredicate;
            foreach (triple; triples) {
                string predKey = triple.predicate.toString();
                if (predKey !in byPredicate) {
                    byPredicate[predKey] = [];
                }
                byPredicate[predKey] ~= triple;
            }
            
            size_t predCount = 0;
            foreach (predKey, predTriples; byPredicate) {
                predCount++;
                result ~= "    " ~ predTriples[0].predicate.toTurtle();
                
                foreach (i, triple; predTriples) {
                    if (i > 0) result ~= " ,";
                    result ~= " " ~ triple.object.toTurtle();
                }
                
                if (predCount < byPredicate.length) {
                    result ~= " ;\n";
                } else {
                    result ~= " .\n";
                }
            }
            
            result ~= "\n";
        }
        
        return result;
    }
}

/**
 * RDF/XML serializer (basic implementation)
 */
class DRDFXMLSerializer {
    /**
     * Serialize graph to RDF/XML format
     */
    static string serialize(DRDFGraph graph) @trusted {
        string result = `<?xml version="1.0" encoding="UTF-8"?>` ~ "\n";
        result ~= `<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"`;
        
        // Add namespace declarations
        foreach (prefix, ns; graph.namespaces) {
            if (prefix != "rdf") {
                result ~= `\n         xmlns:` ~ prefix ~ `="` ~ ns.uri ~ `"`;
            }
        }
        
        result ~= ">\n\n";
        
        // Group triples by subject
        DRDFTriple[][string] bySubject;
        foreach (triple; graph.triples) {
            string subjKey = triple.subject.toString();
            if (subjKey !in bySubject) {
                bySubject[subjKey] = [];
            }
            bySubject[subjKey] ~= triple;
        }
        
        // Serialize each subject as a resource
        foreach (subjKey, triples; bySubject) {
            if (triples.length == 0) continue;
            
            auto subject = triples[0].subject;
            if (subject.nodeType == RDFNodeType.URI) {
                result ~= `  <rdf:Description rdf:about="` ~ (cast(DRDFUri)subject).uri ~ `">` ~ "\n";
            } else if (subject.nodeType == RDFNodeType.BlankNode) {
                result ~= `  <rdf:Description rdf:nodeID="` ~ (cast(DRDFBlankNode)subject).id ~ `">` ~ "\n";
            }
            
            foreach (triple; triples) {
                string predUri = (cast(DRDFUri)triple.predicate).uri;
                result ~= `    <` ~ predUri ~ `>`;
                
                if (triple.object.nodeType == RDFNodeType.URI) {
                    result ~= `<rdf:Description rdf:about="` ~ (cast(DRDFUri)triple.object).uri ~ `"/>`;
                } else if (triple.object.nodeType == RDFNodeType.Literal) {
                    auto lit = cast(DRDFLiteral)triple.object;
                    if (lit.language.length > 0) {
                        result ~= lit.value;
                    } else {
                        result ~= lit.value;
                    }
                } else if (triple.object.nodeType == RDFNodeType.BlankNode) {
                    result ~= `<rdf:Description rdf:nodeID="` ~ (cast(DRDFBlankNode)triple.object).id ~ `"/>`;
                }
                
                result ~= `</` ~ predUri ~ `>` ~ "\n";
            }
            
            result ~= "  </rdf:Description>\n\n";
        }
        
        result ~= "</rdf:RDF>\n";
        return result;
    }
}
