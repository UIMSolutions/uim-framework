module uim.htmls.classes.document;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// Represents a complete HTML document
class DHtmlDocument : UIMObject {
    protected string _title;
    protected string _lang;
    protected string _charset;

    // Getter for title
    string title() { return _title; }
    
    // Setter for title
    auto title(string value) { _title = value; return this; }
    
    // Getter for lang
    string lang() { return _lang; }
    
    // Setter for lang
    auto lang(string value) { _lang = value; return this; }
    
    // Getter for charset
    string charset() { return _charset; }
    
    // Setter for charset
    auto charset(string value) { _charset = value; return this; }

    protected IHtmlElement _head;
    protected IHtmlElement _body;
    protected string[] _metaTags;
    protected string[] _stylesheets;
    protected string[] _scripts;

    this() {
        super();
        _lang = "en";
        _charset = "UTF-8";
        _head = HtmlElement("head");
        _body = HtmlElement("body");
    }

    /// Add a meta tag
    DHtmlDocument addMeta(string name, string content) {
        _metaTags ~= `<meta name="` ~ name ~ `" content="` ~ content ~ `">`;
        return this;
    }

    /// Add a stylesheet link
    DHtmlDocument addStylesheet(string href) {
        _stylesheets ~= `<link rel="stylesheet" href="` ~ href ~ `">`;
        return this;
    }

    /// Add a script tag
    DHtmlDocument addScript(string src) {
        _scripts ~= `<script src="` ~ src ~ `"></script>`;
        return this;
    }

    /// Add inline style
    DHtmlDocument addInlineStyle(string css) {
        _stylesheets ~= `<style>` ~ css ~ `</style>`;
        return this;
    }

    /// Add inline script
    DHtmlDocument addInlineScript(string js) {
        _scripts ~= `<script>` ~ js ~ `</script>`;
        return this;
    }

    /// Get body element for adding content
    IHtmlElement body() {
        return _body;
    }

    /// Get head element
    IHtmlElement head() {
        return _head;
    }

    /// Generate complete HTML document
    override string toString() {
        import std.array : join;

        string html = "<!DOCTYPE html>\n";
        html ~= `<html lang="` ~ _lang ~ `">` ~ "\n";
        html ~= "<head>\n";
        html ~= `<meta charset="` ~ _charset ~ `">` ~ "\n";
        
        if (_title.length > 0) {
            html ~= "<title>" ~ _title ~ "</title>\n";
        }

        foreach (meta; _metaTags) {
            html ~= meta ~ "\n";
        }

        foreach (stylesheet; _stylesheets) {
            html ~= stylesheet ~ "\n";
        }

        // Add additional head elements
        foreach (child; _head.children()) {
            html ~= child.toString() ~ "\n";
        }

        html ~= "</head>\n";
        html ~= "<body>\n";
        
        // Add body content
        if (_body.content().length > 0) {
            html ~= _body.content() ~ "\n";
        }

        foreach (child; _body.children()) {
            html ~= child.toString() ~ "\n";
        }

        foreach (script; _scripts) {
            html ~= script ~ "\n";
        }

        html ~= "</body>\n";
        html ~= "</html>";
        
        return html;
    }
}

auto HtmlDocument() { return new DHtmlDocument(); }

unittest {
    auto doc = HtmlDocument();
    doc.title("Test Page").lang("en");
    assert(doc.title == "Test Page");
}
