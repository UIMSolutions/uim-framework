/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.tests;

import uim.html;

mixin(ShowModule!());

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
    auto div = H5Div("Content");
    assert(div.toString() == "<div>Content</div>");

    // Test with attributes
    div.id("main").addClass("container");

    // Test span
    auto span = H5Span("Text");
    assert(span.toString() == "<span>Text</span>");

    // Test paragraph
    auto p = H5P("Paragraph");
    assert(p.toString() == "<p>Paragraph</p>");

    // Test headings
    auto h1 = H5H1("Title");
    assert(h1.toString() == "<h1>Title</h1>");
}

void testFormElements() {
    // Test form
    auto form = H5Form();
    form.action("/submit");
    form.post();

    // Test inputs
    auto input = H5TextInput("username").placeholder("Enter username");
    auto password = H5PasswordInput("password");
    auto submit = H5SubmitInput("Login");

    // Test button
    auto btn = H5Button("Click me");
    assert(btn.toString() == "<button>Click me</button>");

    // Test textarea
    auto ta = H5Textarea("comment");
    ta.rows("5");
    ta.cols("30");

    // Test select
    auto select = H5Select("country");
    select.addOption("us", "USA");
    select.addOption("uk", "UK");
}

void testTableElements() {
    auto table = H5Table();
    auto thead = H5Thead();
    auto tbody = H5Tbody();
    auto tr = H5Tr();
    auto th = H5Th("Header");
    auto td = H5Td("Cell");

    assert(th == "<th>Header</th>");
    assert(td == "<td>Cell</td>");
}

void testListElements() {
    // Test unordered list
    auto ul = H5Ul();
        // ul.addChild(Li("Item 1"));
        ul.addContent(H5Li("Item 1"));
        // ul.addChild(Li("Item 2"));
        ul.addContent(H5Li("Item 2"));

    // Test ordered list
    auto ol = H5Ol();
    // ol.addChild(Li("First"));
    // ol.addChild(Li("Second"));
    ol.addContent(H5Li("First"));
    ol.addContent(H5Li("Second"));

    // Test definition list
    auto dl = H5Dl();
    // dl.addChild(Dt("Term"));
    dl.addContent(H5Dt("Term"));
    // dl.addChild(Dd("Definition"));
    dl.addContent(H5Dd("Definition"));
}

void testDocument() {
    auto doc = H5HtmlDocument();
    doc.title("Test Page");
    doc.addStylesheet("style.css");
    doc.addScript("script.js");

    doc.body().addContent(H5H1("Welcome"));
    doc.body().addContent(H5P("This is a test page"));

    string html = doc.toString();
    assert(html.indexOf("<!DOCTYPE html>") == 0);
    assert(html.indexOf("<title>Test Page</title>") > 0);
}
