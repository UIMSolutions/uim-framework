/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.selectors;

import uim.web;

mixin(ShowModule!());

@safe:

/// Class selector, e.g. cssClass("button") -> ".button"
string cssClass(string name) {
  return "." ~ name;
}

/// Id selector, e.g. cssId("main") -> "#main"
string cssId(string name) {
  return "#" ~ name;
}

/// Universal selector "*"
string universal() {
  return "*";
}

/// Combines a tag with a class, e.g. tagClass("div", "active") -> "div.active"
string tagClass(string tag, string className) {
  return tag ~ "." ~ className;
}

/// Combines a tag with an id, e.g. tagId("div", "main") -> "div#main"
string tagId(string tag, string id) {
  return tag ~ "#" ~ id;
}

/// Descendant combinator, e.g. descendant("div", "p") -> "div p"
string descendant(string parent, string child) {
  return parent ~ " " ~ child;
}

/// Child combinator, e.g. child("ul", "li") -> "ul > li"
string child(string parent, string childSelector) {
  return parent ~ " > " ~ childSelector;
}

/// Adjacent sibling combinator, e.g. adjacent("h1", "p") -> "h1 + p"
string adjacent(string first, string second) {
  return first ~ " + " ~ second;
}

/// General sibling combinator, e.g. siblings("h1", "p") -> "h1 ~ p"
string siblings(string first, string second) {
  return first ~ " ~ " ~ second;
}

/// Groups selectors with a comma, e.g. group("h1", "h2") -> "h1, h2"
string group(string[] selectors...) {
  return selectors.join(", ");
}

/// Pseudo class selector, e.g. pseudo("a", "hover") -> "a:hover"
string pseudo(string base, string pseudoClass) {
  return base ~ ":" ~ pseudoClass;
}

/// Pseudo element selector, e.g. pseudoElement("p", "first-line") -> "p::first-line"
string pseudoElement(string base, string element) {
  return base ~ "::" ~ element;
}

/// :hover pseudo class
string hover(string base) {
  return pseudo(base, "hover");
}

/// :focus pseudo class
string focus(string base) {
  return pseudo(base, "focus");
}

/// :active pseudo class
string active(string base) {
  return pseudo(base, "active");
}

/// :visited pseudo class
string visited(string base) {
  return pseudo(base, "visited");
}

/// :first-child pseudo class
string firstChild(string base) {
  return pseudo(base, "first-child");
}

/// :last-child pseudo class
string lastChild(string base) {
  return pseudo(base, "last-child");
}

/// :nth-child() pseudo class, e.g. nthChild("li", 2) -> "li:nth-child(2)"
string nthChild(string base, int n) {
  return "%s:nth-child(%s)".format(base, n);
}

/// :nth-child() with a formula, e.g. nthChild("li", "2n+1") -> "li:nth-child(2n+1)"
string nthChild(string base, string formula) {
  return "%s:nth-child(%s)".format(base, formula);
}

/// :nth-of-type() pseudo class
string nthOfType(string base, int n) {
  return "%s:nth-of-type(%s)".format(base, n);
}

/// :not() pseudo class, e.g. not("p", ".intro") -> "p:not(.intro)"
string not(string base, string selector) {
  return "%s:not(%s)".format(base, selector);
}

/// Attribute presence selector, e.g. attr("input", "type") -> "input[type]"
string attr(string base, string attribute) {
  return "%s[%s]".format(base, attribute);
}

/// Attribute value selector, e.g. attr("input", "type", "text") -> "input[type=\"text\"]"
string attr(string base, string attribute, string value) {
  return "%s[%s=%s]".format(base, attribute, cssString(value));
}

/// Attribute "begins with" selector, e.g. attrStartsWith("a", "href", "https") -> "a[href^=\"https\"]"
string attrStartsWith(string base, string attribute, string value) {
  return "%s[%s^=%s]".format(base, attribute, cssString(value));
}

/// Attribute "ends with" selector, e.g. attrEndsWith("a", "href", ".pdf") -> "a[href$=\".pdf\"]"
string attrEndsWith(string base, string attribute, string value) {
  return "%s[%s$=%s]".format(base, attribute, cssString(value));
}

/// Attribute "contains" selector, e.g. attrContains("a", "href", "example") -> "a[href*=\"example\"]"
string attrContains(string base, string attribute, string value) {
  return "%s[%s*=%s]".format(base, attribute, cssString(value));
}

///
unittest {
  assert(cssClass("button") == ".button");
  assert(cssId("main") == "#main");
  assert(universal == "*");
  assert(tagClass("div", "active") == "div.active");
  assert(tagId("div", "main") == "div#main");

  assert(descendant("div", "p") == "div p");
  assert(child("ul", "li") == "ul > li");
  assert(adjacent("h1", "p") == "h1 + p");
  assert(siblings("h1", "p") == "h1 ~ p");
  assert(group("h1", "h2", "h3") == "h1, h2, h3");

  assert(pseudo("a", "hover") == "a:hover");
  assert(pseudoElement("p", "first-line") == "p::first-line");
  assert(hover("a") == "a:hover");
  assert(focus("input") == "input:focus");
  assert(active("button") == "button:active");
  assert(visited("a") == "a:visited");
  assert(firstChild("li") == "li:first-child");
  assert(lastChild("li") == "li:last-child");
  assert(nthChild("li", 2) == "li:nth-child(2)");
  assert(nthChild("li", "2n+1") == "li:nth-child(2n+1)");
  assert(nthOfType("p", 3) == "p:nth-of-type(3)");
  assert(not("p", ".intro") == "p:not(.intro)");

  assert(attr("input", "type") == "input[type]");
  assert(attr("input", "type", "text") == "input[type=\"text\"]");
  assert(attrStartsWith("a", "href", "https") == "a[href^=\"https\"]");
  assert(attrEndsWith("a", "href", ".pdf") == "a[href$=\".pdf\"]");
  assert(attrContains("a", "href", "example") == "a[href*=\"example\"]");

  // values are escaped
  assert(attr("a", "title", `x"]{}`) == `a[title="x\"]{}"]`);
}
