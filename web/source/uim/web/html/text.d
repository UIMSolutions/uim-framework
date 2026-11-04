/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.text;

import uim.web;

mixin(ShowModule!());

@safe:

/// Heading element, e.g. heading(1, "Title") -> "<h1>Title</h1>"
string heading(int level, string content, string[string] attributes = null) {
  assert(level >= 1 && level <= 6, "Heading level must be between 1 and 6");
  return htmlTag("h%s".format(level), attributes, content);
}

/// Paragraph element, e.g. p("Hello") -> "<p>Hello</p>"
string p(string content, string[string] attributes = null) {
  return htmlTag("p", attributes, content);
}

/// Span element
string span(string content, string[string] attributes = null) {
  return htmlTag("span", attributes, content);
}

/// Div element
string div(string content, string[string] attributes = null) {
  return htmlTag("div", attributes, content);
}

/// Strong (bold) element
string strong(string content) {
  return htmlTag("strong", content);
}

/// Emphasized (italic) element
string em(string content) {
  return htmlTag("em", content);
}

/// Small element
string small(string content) {
  return htmlTag("small", content);
}

/// Mark (highlighted) element
string mark(string content) {
  return htmlTag("mark", content);
}

/// Code element (inline code)
string code(string content) {
  return htmlTag("code", content);
}

/// Preformatted text element
string pre(string content) {
  return htmlTag("pre", content);
}

/// Blockquote element with optional cite attribute
string blockquote(string content, string cite = null) {
  return cite.length > 0
    ? htmlTag("blockquote", ["cite": cite], content)
    : htmlTag("blockquote", content);
}

/// Inline quote element
string q(string content, string cite = null) {
  return cite.length > 0
    ? htmlTag("q", ["cite": cite], content)
    : htmlTag("q", content);
}

/// Abbreviation element, e.g. abbr("HTML", "HyperText Markup Language")
string abbr(string content, string title) {
  return htmlTag("abbr", ["title": title], content);
}

/// Line break element -> "<br>"
string br() {
  return "<br>";
}

/// Thematic break element -> "<hr>"
string hr(string[string] attributes = null) {
  return new HtmlElement("hr").attrs(attributes).toString;
}

/// Kbd element (keyboard input)
string kbd(string content) {
  return htmlTag("kbd", content);
}

/// Samp element (sample output)
string samp(string content) {
  return htmlTag("samp", content);
}

/// Subscript element
string sub(string content) {
  return htmlTag("sub", content);
}

/// Superscript element
string sup(string content) {
  return htmlTag("sup", content);
}

/// Time element with optional datetime attribute
string time(string content, string datetime = null) {
  return datetime.length > 0
    ? htmlTag("time", ["datetime": datetime], content)
    : htmlTag("time", content);
}

///
unittest {
  assert(heading(1, "Title") == "<h1>Title</h1>");
  assert(heading(6, "Deep") == "<h6>Deep</h6>");
  assert(heading(2, "Sub", ["class": "sub"]) == `<h2 class="sub">Sub</h2>`);

  assert(p("Hello") == "<p>Hello</p>");
  assert(p("a < b") == "<p>a &lt; b</p>");
  assert(span("x") == "<span>x</span>");
  assert(div("x", ["id": "d"]) == `<div id="d">x</div>`);

  assert(strong("bold") == "<strong>bold</strong>");
  assert(em("italic") == "<em>italic</em>");
  assert(small("fine") == "<small>fine</small>");
  assert(mark("hl") == "<mark>hl</mark>");
  assert(code("x = 1;") == "<code>x = 1;</code>");
  assert(pre("line1\nline2") == "<pre>line1\nline2</pre>");

  assert(blockquote("Quote") == "<blockquote>Quote</blockquote>");
  assert(blockquote("Quote", "https://src") == `<blockquote cite="https://src">Quote</blockquote>`);
  assert(q("Quote") == "<q>Quote</q>");
  assert(q("Quote", "https://src") == `<q cite="https://src">Quote</q>`);

  assert(abbr("HTML", "HyperText Markup Language") == `<abbr title="HyperText Markup Language">HTML</abbr>`);
  assert(br == "<br>");
  assert(hr == "<hr>");
  assert(hr(["class": "sep"]) == `<hr class="sep">`);
  assert(kbd("Ctrl+C") == "<kbd>Ctrl+C</kbd>");
  assert(samp("output") == "<samp>output</samp>");
  assert(sub("2") == "<sub>2</sub>");
  assert(sup("2") == "<sup>2</sup>");
  assert(time("today") == "<time>today</time>");
  assert(time("Jan 1", "2026-01-01") == `<time datetime="2026-01-01">Jan 1</time>`);
}
