/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rss.category;

import uim.rss;
import std.datetime;
import std.conv;

@safe:

/**
 * RSS Category
 */
class DRSSCategory : UIMObject {
    protected string _name;
    protected string _domain;
    
    @property string name() { return _name; }
    @property void name(string value) { _name = value; }
    
    @property string domain() { return _domain; }
    @property void domain(string value) { _domain = value; }
    
    this() {
        super();
    }
    
    this(string categoryName) {
        this();
        this._name = categoryName;
    }
    
    this(string categoryName, string categoryDomain) {
        this(categoryName);
        this._domain = categoryDomain;
    }
    
    /**
     * Convert to XML string
     */
    string toXML(int indent = 0) {
        string indentStr = "";
        for (int i = 0; i < indent; i++) indentStr ~= "  ";
        
        string result = indentStr ~ "<category";
        if (_domain.length > 0) {
            result ~= ` domain="` ~ _domain ~ `"`;
        }
        result ~= ">" ~ _name ~ "</category>\n";
        return result;
    }
}
