/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.rss.feed;

import uim.rss;
import std.datetime;
import std.conv;
import std.algorithm;
import std.array;

@safe:

/**
 * RSS Feed (Channel)
 */
class DRSSFeed : UIMObject {
    protected string _title;
    protected string _link;
    protected string _description;
    protected string _language;
    protected string _copyright;
    protected string _managingEditor;
    protected string _webMaster;
    protected SysTime _pubDate;
    protected SysTime _lastBuildDate;
    protected DRSSCategory[] _categories;
    protected string _generator;
    protected string _docs;
    protected int _ttl;
    protected DRSSImage _image;
    protected DRSSItem[] _items;
    
    @property string title() { return _title; }
    @property void title(string value) { _title = value; }
    
    @property string link() { return _link; }
    @property void link(string value) { _link = value; }
    
    @property string description() { return _description; }
    @property void description(string value) { _description = value; }
    
    @property string language() { return _language; }
    @property void language(string value) { _language = value; }
    
    @property string copyright() { return _copyright; }
    @property void copyright(string value) { _copyright = value; }
    
    @property string managingEditor() { return _managingEditor; }
    @property void managingEditor(string value) { _managingEditor = value; }
    
    @property string webMaster() { return _webMaster; }
    @property void webMaster(string value) { _webMaster = value; }
    
    @property SysTime pubDate() { return _pubDate; }
    @property void pubDate(SysTime value) { _pubDate = value; }
    
    @property SysTime lastBuildDate() { return _lastBuildDate; }
    @property void lastBuildDate(SysTime value) { _lastBuildDate = value; }
    
    @property DRSSCategory[] categories() { return _categories; }
    @property void categories(DRSSCategory[] value) { _categories = value; }
    
    @property string generator() { return _generator; }
    @property void generator(string value) { _generator = value; }
    
    @property string docs() { return _docs; }
    @property void docs(string value) { _docs = value; }
    
    @property int ttl() { return _ttl; }
    @property void ttl(int value) { _ttl = value; }
    
    @property DRSSImage image() { return _image; }
    @property void image(DRSSImage value) { _image = value; }
    
    @property DRSSItem[] items() { return _items; }
    @property void items(DRSSItem[] value) { _items = value; }
    
    this() {
        super();
        _categories = [];
        _items = [];
        _generator = "UIM RSS Library";
        _docs = "https://www.rssboard.org/rss-specification";
    }
    
    this(string feedTitle, string feedLink, string feedDescription) {
        this();
        this._title = feedTitle;
        this._link = feedLink;
        this._description = feedDescription;
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
     * Add an item
     */
    void addItem(DRSSItem item) {
        _items ~= item;
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
     * Convert to XML string (RSS 2.0)
     */
    string toXML() @trusted {
        string result = `<?xml version="1.0" encoding="UTF-8"?>` ~ "\n";
        result ~= `<rss version="2.0">` ~ "\n";
        result ~= "  <channel>\n";
        
        result ~= "    <title>" ~ escapeXML(_title) ~ "</title>\n";
        result ~= "    <link>" ~ _link ~ "</link>\n";
        result ~= "    <description>" ~ escapeXML(_description) ~ "</description>\n";
        
        if (_language.length > 0) {
            result ~= "    <language>" ~ _language ~ "</language>\n";
        }
        if (_copyright.length > 0) {
            result ~= "    <copyright>" ~ escapeXML(_copyright) ~ "</copyright>\n";
        }
        if (_managingEditor.length > 0) {
            result ~= "    <managingEditor>" ~ _managingEditor ~ "</managingEditor>\n";
        }
        if (_webMaster.length > 0) {
            result ~= "    <webMaster>" ~ _webMaster ~ "</webMaster>\n";
        }
        if (_pubDate != SysTime.init) {
            result ~= "    <pubDate>" ~ formatRFC822(_pubDate) ~ "</pubDate>\n";
        }
        if (_lastBuildDate != SysTime.init) {
            result ~= "    <lastBuildDate>" ~ formatRFC822(_lastBuildDate) ~ "</lastBuildDate>\n";
        }
        
        foreach (category; _categories) {
            result ~= category.toXML(2);
        }
        
        if (_generator.length > 0) {
            result ~= "    <generator>" ~ _generator ~ "</generator>\n";
        }
        if (_docs.length > 0) {
            result ~= "    <docs>" ~ _docs ~ "</docs>\n";
        }
        if (_ttl > 0) {
            result ~= "    <ttl>" ~ _ttl.to!string ~ "</ttl>\n";
        }
        
        if (_image !is null) {
            result ~= _image.toXML(2);
        }
        
        foreach (item; _items) {
            result ~= item.toXML(2);
        }
        
        result ~= "  </channel>\n";
        result ~= "</rss>\n";
        
        return result;
    }
}
