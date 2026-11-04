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
  return listElement("ul", items, attributes).toString;
}

/// Ordered list from string items, e.g. ol(["a", "b"]) -> "<ol><li>a</li><li>b</li></ol>"
string ol(string[] items, string[string] attributes = null) {
  return listElement("ol", items, attributes).toString;
}

/// Ordered list with a start offset, e.g. ol(3, ["c", "d"]) -> `<ol start="3">...`
string ol(int start, string[] items, string[string] attributes = null) {
  return listElement("ol", items, attributes).attr("start", start.to!string).toString;
}

private HtmlElement listElement(string tag, string[] items, string[string] attributes) {
  auto element = new HtmlElement(tag).attrs(attributes);
  foreach (item; items) {
    element.add("li", item);
  }
  return element;
}

/// Description term element
string dt(string content) {
  return htmlTag("dt", content);
}

/// Description details element
string dd(string content) {
  return htmlTag("dd", content);
}

/// Description list from term/description pairs, in the given order, e.g. dl([["Name", "UIM"]])
string dl(string[2][] items, string[string] attributes = null) {
  auto element = new HtmlElement("dl").attrs(attributes);
  foreach (item; items) {
    element.add("dt", item[0]);
    element.add("dd", item[1]);
  }
  return element.toString;
}

/// Description list from an associative array, sorted by term
string dl(string[string] items, string[string] attributes = null) {
  return dl(sortedPairs(items), attributes);
}

/// Navigation list of label/href pairs, in the given order, e.g. navList([["Home", "/"], ["About", "/about"]])
string navList(string[2][] links, string[string] attributes = null) {
  auto element = new HtmlElement("ul").attrs(attributes);
  foreach (link; links) {
    element.add("li").add(new HtmlElement("a", ["href": link[1]], link[0]));
  }
  return element.toString;
}

/// Navigation list from an associative array, sorted by label
string navList(string[string] links, string[string] attributes = null) {
  return navList(sortedPairs(links), attributes);
}

/// Key/value pairs of an associative array, sorted by key
string[2][] sortedPairs(string[string] values) {
  string[2][] pairs;
  foreach (key; values.keys.sort) {
    pairs ~= [key, values[key]];
  }
  return pairs;
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

  // order: pairs keep theirs, associative arrays are sorted
  assert(navList([["Z", "/z"], ["A", "/a"]]) == `<ul><li><a href="/z">Z</a></li><li><a href="/a">A</a></li></ul>`);
  assert(navList(["Z": "/z", "A": "/a"]) == `<ul><li><a href="/a">A</a></li><li><a href="/z">Z</a></li></ul>`);
  assert(dl([["Z", "1"], ["A", "2"]]) == "<dl><dt>Z</dt><dd>1</dd><dt>A</dt><dd>2</dd></dl>");
  assert(dl(["Z": "1", "A": "2"]) == "<dl><dt>A</dt><dd>2</dd><dt>Z</dt><dd>1</dd></dl>");

  // items are escaped
  assert(ul(["a < b"]) == "<ul><li>a &lt; b</li></ul>");
}
