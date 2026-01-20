/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rss.enclosure;

import uim.rss;
import std.datetime;
import std.conv;

@safe:

/**
 * RSS Enclosure (for podcasts, media files)
 */
class DRSSEnclosure : UIMObject {
    protected string _url;
    protected long _length;
    protected string _type;
    
    @property string url() { return _url; }
    @property void url(string value) { _url = value; }
    
    @property long length() { return _length; }
    @property void length(long value) { _length = value; }
    
    @property string type() { return _type; }
    @property void type(string value) { _type = value; }
    
    this() {
        super();
    }
    
    this(string enclosureUrl, long enclosureLength, string enclosureType) {
        this();
        this._url = enclosureUrl;
        this._length = enclosureLength;
        this._type = enclosureType;
    }
    
    /**
     * Convert to XML string
     */
    string toXML(int indent = 0) {
        string indentStr = "";
        for (int i = 0; i < indent; i++) indentStr ~= "  ";
        
        return indentStr ~ `<enclosure url="` ~ _url ~ `" length="` ~ _length.to!string ~ `" type="` ~ _type ~ `"/>` ~ "\n";
    }
}
