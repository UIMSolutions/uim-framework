/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.lists;

import uim.web;

mixin(ShowModule!());

@safe:

/// List item element, e.g. li("one") -> "<li>one</li>"
string li(string content, string[string] attributes = null) {
  return htmlTag("li", attributes, content);
}

/// Unordered list from string items, e.g. ul(["a", "b"]) -> "<ul><li>a</li><li>b</li></ul>"
string ul(string[] items, string[string] attributes = null) {
  auto element = new HtmlElement("ul").attrs(attributes);
  foreach (item; items) {
    element.add("li", item);
  }
  return element.toString;
}

/// Ordered list from string items, e.g. ol(["a", "b"]) -> "<ol><li>a</li><li>b</li></ol>"
string ol(string[] items, string[string] attributes = null) {
  auto element = new HtmlElement("ol").attrs(attributes);
  foreach (item; items) {
    element.add("li", item);
  }
  return element.toString;
}

/// Ordered list with a start offset, e.g. ol(3, ["c", "d"]) -> `<ol start="3">...`
string ol(int start, string[] items, string[string] attributes = null) {
  auto element = new HtmlElement("ol").attrs(attributes).attr("start", start.to!string);
  foreach (item; items) {
    element.add("li", item);
  }
  return element.toString;
}

/// Description term element
string dt(string content) {
  return htmlTag("dt", content);
}

/// Description details element
string dd(string content) {
  return htmlTag("dd", content);
}

/// Description list from term/description pairs
string dl(string[string] items, string[string] attributes = null) {
  auto element = new HtmlElement("dl").attrs(attributes);
  foreach (term, description; items) {
    element.add("dt", term);
    element.add("dd", description);
  }
  return element.toString;
}

/// Navigation list: unordered list of links, e.g. navList(["Home": "/"])
string navList(string[string] links, string[string] attributes = null) {
  auto element = new HtmlElement("ul").attrs(attributes);
  foreach (label, href; links) {
    auto item = new HtmlElement("li");
    item.raw(htmlTag("a", ["href": href], label));
    element.add(item);
  }
  return element.toString;
}

///
unittest {
  assert(li("one") == "<li>one</li>");
  assert(li("one", ["class": "first"]) == `<li class="first">one</li>`);

  assert(ul(["a", "b"]) == "<ul><li>a</li><li>b</li></ul>");
  assert(ul(["a"], ["class": "list"]) == `<ul class="list"><li>a</li></ul>`);
  assert(ul([]) == "<ul></ul>");

  assert(ol(["a", "b"]) == "<ol><li>a</li><li>b</li></ol>");
  assert(ol(3, ["c", "d"]) == `<ol start="3"><li>c</li><li>d</li></ol>`);

  assert(dt("Term") == "<dt>Term</dt>");
  assert(dd("Description") == "<dd>Description</dd>");

  auto descriptionList = dl(["Name": "UIM", "Type": "Framework"]);
  assert(descriptionList.canFind("<dt>Name</dt><dd>UIM</dd>"));
  assert(descriptionList.canFind("<dt>Type</dt><dd>Framework</dd>"));
  assert(descriptionList.startsWith("<dl>"));
  assert(descriptionList.endsWith("</dl>"));

  auto nav = navList(["Home": "/", "About": "/about"]);
  assert(nav.canFind(`<li><a href="/">Home</a></li>`));
  assert(nav.canFind(`<li><a href="/about">About</a></li>`));

  // items are escaped
  assert(ul(["a < b"]) == "<ul><li>a &lt; b</li></ul>");
}
