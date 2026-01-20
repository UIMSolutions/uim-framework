/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rss.image;

import uim.rss;
import std.datetime;
import std.conv;

@safe:

/**
 * RSS Channel Image
 */
class DRSSImage : UIMObject {
    protected string _url;
    protected string _title;
    protected string _link;
    protected int _width;
    protected int _height;
    protected string _description;
    
    @property string url() { return _url; }
    @property void url(string value) { _url = value; }
    
    @property string title() { return _title; }
    @property void title(string value) { _title = value; }
    
    @property string link() { return _link; }
    @property void link(string value) { _link = value; }
    
    @property int width() { return _width; }
    @property void width(int value) { _width = value; }
    
    @property int height() { return _height; }
    @property void height(int value) { _height = value; }
    
    @property string description() { return _description; }
    @property void description(string value) { _description = value; }
    
    this() {
        super();
        _width = 88;  // Default RSS width
        _height = 31; // Default RSS height
    }
    
    this(string imageUrl, string imageTitle, string imageLink) {
        this();
        this._url = imageUrl;
        this._title = imageTitle;
        this._link = imageLink;
    }
    
    /**
     * Convert to XML string
     */
    string toXML(int indent = 0) {
        string indentStr = "";
        for (int i = 0; i < indent; i++) indentStr ~= "  ";
        
        string result = indentStr ~ "<image>\n";
        result ~= indentStr ~ "  <url>" ~ _url ~ "</url>\n";
        result ~= indentStr ~ "  <title>" ~ _title ~ "</title>\n";
        result ~= indentStr ~ "  <link>" ~ _link ~ "</link>\n";
        
        if (_width != 88) {
            result ~= indentStr ~ "  <width>" ~ _width.to!string ~ "</width>\n";
        }
        if (_height != 31) {
            result ~= indentStr ~ "  <height>" ~ _height.to!string ~ "</height>\n";
        }
        if (_description.length > 0) {
            result ~= indentStr ~ "  <description>" ~ _description ~ "</description>\n";
        }
        
        result ~= indentStr ~ "</image>\n";
        return result;
    }
}
