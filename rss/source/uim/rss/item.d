/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rss.item;

import uim.rss;
import std.datetime;
import std.conv;
import std.algorithm;
import std.array;

@safe:

/**
 * RSS Item (entry)
 */
class DRSSItem : UIMObject {
    protected string _title;
    protected string _link;
    protected string _description;
    protected string _author;
    protected DRSSCategory[] _categories;
    protected string _comments;
    protected DRSSEnclosure _enclosure;
    protected string _guid;
    protected bool _guidIsPermaLink;
    protected SysTime _pubDate;
    protected string _source;
    
    @property string title() { return _title; }
    @property void title(string value) { _title = value; }
    
    @property string link() { return _link; }
    @property void link(string value) { _link = value; }
    
    @property string description() { return _description; }
    @property void description(string value) { _description = value; }
    
    @property string author() { return _author; }
    @property void author(string value) { _author = value; }
    
    @property DRSSCategory[] categories() { return _categories; }
    @property void categories(DRSSCategory[] value) { _categories = value; }
    
    @property string comments() { return _comments; }
    @property void comments(string value) { _comments = value; }
    
    @property DRSSEnclosure enclosure() { return _enclosure; }
    @property void enclosure(DRSSEnclosure value) { _enclosure = value; }
    
    @property string guid() { return _guid; }
    @property void guid(string value) { _guid = value; }
    
    @property bool guidIsPermaLink() { return _guidIsPermaLink; }
    @property void guidIsPermaLink(bool value) { _guidIsPermaLink = value; }
    
    @property SysTime pubDate() { return _pubDate; }
    @property void pubDate(SysTime value) { _pubDate = value; }
    
    @property string source() { return _source; }
    @property void source(string value) { _source = value; }
    
    this() {
        super();
        _categories = [];
        _guidIsPermaLink = true;
    }
    
    /**
     * Add a category
     */
    void addCategory(DRSSCategory category) {
        _categories ~= category;
    }
    
    /**
     * Add a category by name
     */
    void addCategory(string name, string domain = "") {
        _categories ~= new DRSSCategory(name, domain);
    }
    
    /**
     * Escape XML special characters
     */
    private string escapeXML(string text) @trusted {
        return text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&apos;");
    }
    
    /**
     * Format date to RFC 822
     */
    private string formatRFC822(SysTime dt) @trusted {
        import std.format;
        const char[7][12] months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        const char[3][7] days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        
        auto month = months[dt.month - 1];
        auto day = days[dt.dayOfWeek];
        
        return format("%s, %02d %s %04d %02d:%02d:%02d +0000", 
            day, dt.day, month, dt.year, dt.hour, dt.minute, dt.second);
    }
    
    /**
     * Convert to XML string
     */
    string toXML(int indent = 0) @trusted {
        string indentStr = "";
        for (int i = 0; i < indent; i++) indentStr ~= "  ";
        
        string result = indentStr ~ "<item>\n";
        
        if (_title.length > 0) {
            result ~= indentStr ~ "  <title>" ~ escapeXML(_title) ~ "</title>\n";
        }
        if (_link.length > 0) {
            result ~= indentStr ~ "  <link>" ~ _link ~ "</link>\n";
        }
        if (_description.length > 0) {
            result ~= indentStr ~ "  <description>" ~ escapeXML(_description) ~ "</description>\n";
        }
        if (_author.length > 0) {
            result ~= indentStr ~ "  <author>" ~ _author ~ "</author>\n";
        }
        
        foreach (category; _categories) {
            result ~= category.toXML(indent + 1);
        }
        
        if (_comments.length > 0) {
            result ~= indentStr ~ "  <comments>" ~ _comments ~ "</comments>\n";
        }
        if (_enclosure !is null) {
            result ~= _enclosure.toXML(indent + 1);
        }
        if (_guid.length > 0) {
            result ~= indentStr ~ `  <guid isPermaLink="` ~ (_guidIsPermaLink ? "true" : "false") ~ `">` ~ _guid ~ "</guid>\n";
        }
        if (_pubDate != SysTime.init) {
            result ~= indentStr ~ "  <pubDate>" ~ formatRFC822(_pubDate) ~ "</pubDate>\n";
        }
        if (_source.length > 0) {
            result ~= indentStr ~ "  <source>" ~ _source ~ "</source>\n";
        }
        
        result ~= indentStr ~ "</item>\n";
        return result;
    }
}
