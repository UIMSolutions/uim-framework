module uim.htmls.tests;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

@safe:

/// Run all tests for the HTML library
void runTests() {
    testBasicElements();
    testFormElements();
    testTableElements();
    testListElements();
    testDocument();
}

void testBasicElements() {
    // Test div
    auto div = Div("Content");
    assert(div.toString() == "<div>Content</div>");
    
    // Test with attributes
    div.id("main").addClass("container");
    
    // Test span
    auto span = Span("Text");
    assert(span.toString() == "<span>Text</span>");
    
    // Test paragraph
    auto p = P("Paragraph");
    assert(p.toString() == "<p>Paragraph</p>");
    
    // Test headings
    auto h1 = H1("Title");
    assert(h1.toString() == "<h1>Title</h1>");
}

void testFormElements() {
    // Test form
    auto form = Form();
    form.action("/submit");
    form.post();
    
    // Test inputs
    auto input = InputText("username").placeholder("Enter username");
    auto password = InputPassword("password");
    auto submit = InputSubmit("Login");
    
    // Test button
    auto btn = HtmlButton("Click me");
    assert(btn.toString() == "<button>Click me</button>");
    
    // Test textarea
    auto ta = Textarea("comment").rows("5");
    
    // Test select
    auto select = Select("country");
    select.addOption("us", "USA");
    select.addOption("uk", "UK");
}

void testTableElements() {
    auto table = Table();
    auto thead = Thead();
    auto tbody = Tbody();
    auto tr = Tr();
    auto th = Th("Header");
    auto td = Td("Cell");
    
    assert(th.toString() == "<th>Header</th>");
    assert(td.toString() == "<td>Cell</td>");
}

void testListElements() {
    // Test unordered list
    auto ul = Ul();
    ul.addChild(Li("Item 1"));
    ul.addChild(Li("Item 2"));
    
    // Test ordered list
    auto ol = Ol();
    ol.addChild(Li("First"));
    ol.addChild(Li("Second"));
    
    // Test definition list
    auto dl = Dl();
    dl.addChild(Dt("Term"));
    dl.addChild(Dd("Definition"));
}

void testDocument() {
    auto doc = HtmlDocument();
    doc.title("Test Page");
    doc.addStylesheet("style.css");
    doc.addScript("script.js");
    
    doc.body().addChild(H1("Welcome"));
    doc.body().addChild(P("This is a test page"));
    
    string html = doc.toString();
    assert(html.indexOf("<!DOCTYPE html>") == 0);
    assert(html.indexOf("<title>Test Page</title>") > 0);
}