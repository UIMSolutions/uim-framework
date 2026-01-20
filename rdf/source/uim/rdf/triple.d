/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rdf.triple;

import uim.rdf;
import std.conv;

@safe:

/**
 * RDF Triple (subject-predicate-object statement)
 */
class DRDFTriple : UIMObject {
    protected DRDFNode _subject;
    protected DRDFUri _predicate;
    protected DRDFNode _object;
    
    @property DRDFNode subject() { return _subject; }
    @property void subject(DRDFNode value) { _subject = value; }
    
    @property DRDFUri predicate() { return _predicate; }
    @property void predicate(DRDFUri value) { _predicate = value; }
    
    @property DRDFNode object() { return _object; }
    @property void object(DRDFNode value) { _object = value; }
    
    this() {
        super();
    }
    
    this(DRDFNode subj, DRDFUri pred, DRDFNode obj) {
        this();
        this._subject = subj;
        this._predicate = pred;
        this._object = obj;
    }
    
    /**
     * Convenience constructor with URI strings
     */
    this(string subjUri, string predUri, string objUri) {
        this();
        this._subject = new DRDFUri(subjUri);
        this._predicate = new DRDFUri(predUri);
        this._object = new DRDFUri(objUri);
    }
    
    /**
     * Convert to N-Triples format
     */
    string toNTriples() {
        return _subject.toNTriples() ~ " " ~ 
               _predicate.toNTriples() ~ " " ~ 
               _object.toNTriples() ~ " .";
    }
    
    /**
     * Convert to Turtle format
     */
    string toTurtle() {
        return _subject.toTurtle() ~ " " ~ 
               _predicate.toTurtle() ~ " " ~ 
               _object.toTurtle() ~ " .";
    }
    
    /**
     * Check if this triple matches a pattern (null matches anything)
     */
    bool matches(DRDFNode subj, DRDFUri pred, DRDFNode obj) {
        if (subj !is null && _subject.toString() != subj.toString()) return false;
        if (pred !is null && _predicate.toString() != pred.toString()) return false;
        if (obj !is null && _object.toString() != obj.toString()) return false;
        return true;
    }
}
