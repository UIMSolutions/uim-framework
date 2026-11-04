/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.selectors;

import uim.web;

mixin(ShowModule!());

@safe:

/**
 * Returns a CSS class selector for the given class name.
 *
 * Params:
 *   name = The class name.
 *
 * Returns:
 *   A string representing the CSS class selector.
 *
 * Example:
 *   cssClass("button") -> ".button"
 */
string cssClass(string name) {
  return "." ~ name;
}

/** 
 * Returns a CSS id selector for the given id.
 *
 * Params:
 *   name = The id name.
 *
 * Returns:
 *   A string representing the CSS id selector.
 *
 * Example:
 *   cssId("main") -> "#main"
 */
string cssId(string name) {
  return "#" ~ name;
}

/** 
 * Returns the universal CSS selector "*".
 *
 * Returns:
 *   A string representing the universal CSS selector.
 *
 * Example:
 *   universal() -> "*"
 */
string universal() {
  return "*";
}

/**
 * Returns a CSS selector combining the tag and class.
 *
 * Params:
 *   tag = The HTML tag name.
 *   className = The class name.
 *
 * Returns:
 *   A string representing the combined tag and class selector.
 *
 * Example:
 *   tagClass("div", "active") -> "div.active"
 */
string tagClass(string tag, string className) {
  return tag ~ "." ~ className;
}

/**
 * Returns a CSS selector combining the tag and id.
 *
 * Params:
 *   tag = The HTML tag name.
 *   id = The id name.
 *
 * Returns:
 *   A string representing the combined tag and id selector.
 *
 * Example:
 *   tagId("div", "main") -> "div#main"
 */
  
string tagId(string tag, string id) {
  return tag ~ "#" ~ id;
}

/**
 * Returns a CSS selector for the descendant combinator.
 *
 * Params:
 *   parent = The parent element selector.
 *   child = The child element selector.
 *
 * Returns:
 *   A string representing the descendant combinator selector.
 *
 * Example:
 *   descendant("div", "p") -> "div p"
 */
string descendant(string parent, string child) {
  return parent ~ " " ~ child;
}

/**
 * Returns a CSS selector for the child combinator.
 *
 * Params:
 *   parent = The parent element selector.
 *   childSelector = The child element selector.
 *
 * Returns:
 *   A string representing the child combinator selector.
 *
 * Example:
 *   child("ul", "li") -> "ul > li"
 */
string child(string parent, string childSelector) {
  return parent ~ " > " ~ childSelector;
}

/**
 * Returns a CSS selector for the adjacent sibling combinator.
 *
 * Params:
 *   first = The first element selector.
 *   second = The adjacent sibling element selector.
 *
 * Returns:
 *   A string representing the adjacent sibling combinator selector.
 *
 * Example:
 *   adjacent("h1", "p") -> "h1 + p"
 */
string adjacent(string first, string second) {
  return first ~ " + " ~ second;
}

/**
 * Returns a CSS selector for the general sibling combinator.
 *
 * Params:
 *   first = The first element selector.
 *   second = The general sibling element selector.
 *
 * Returns:
 *   A string representing the general sibling combinator selector.
 *
 * Example:
 *   siblings("h1", "p") -> "h1 ~ p"
 */
string siblings(string first, string second) {
  return first ~ " ~ " ~ second;
}

/**
 * Groups multiple CSS selectors with a comma.
 *
 * Params:
 *   selectors = The list of selectors to group.
 *
 * Returns:
 *   A string representing the grouped selectors.
 *
 * Example:
 *   group("h1", "h2") -> "h1, h2"
 */
string group(string[] selectors...) {
  return selectors.join(", ");
}

/**
 * Returns a CSS selector for a pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *   pseudoClass = The pseudo class name.
 *
 * Returns:
 *   A string representing the pseudo class selector.
 *
 * Example:
 *   pseudo("a", "hover") -> "a:hover"
 */
string pseudo(string base, string pseudoClass) {
  return base ~ ":" ~ pseudoClass;
}

/**
 * Returns a CSS selector for a pseudo element.
 *
 * Params:
 *   base = The base element selector.
 *   element = The pseudo element name.
 *
 * Returns:
 *   A string representing the pseudo element selector.
 *
 * Example:
 *   pseudoElement("p", "first-line") -> "p::first-line"
 */
string pseudoElement(string base, string element) {
  return base ~ "::" ~ element;
}

/**
 * Returns a CSS selector for the :hover pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *
 * Returns:
 *   A string representing the :hover pseudo class selector.
 *
 * Example:
 *   hover("a") -> "a:hover"
 */
string hover(string base) {
  return pseudo(base, "hover");
}

/**
 * Returns a CSS selector for the :focus pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *
 * Returns:
 *   A string representing the :focus pseudo class selector.
 *
 * Example:
 *   focus("input") -> "input:focus"
 */
string focus(string base) {
  return pseudo(base, "focus");
}

/**
 * Returns a CSS selector for the :active pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *
 * Returns:
 *   A string representing the :active pseudo class selector.
 *
 * Example:
 *   active("button") -> "button:active"
 */
string active(string base) {
  return pseudo(base, "active");
}

/**
 * Returns a CSS selector for the :visited pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *
 * Returns:
 *   A string representing the :visited pseudo class selector.
 *
 * Example:
 *   visited("a") -> "a:visited"
 */
string visited(string base) {
  return pseudo(base, "visited");
}

/**
 * Returns a CSS selector for the :first-child pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *
 * Returns:
 *   A string representing the :first-child pseudo class selector.
 *
 * Example:
 *   firstChild("li") -> "li:first-child"
 */
string firstChild(string base) {
  return pseudo(base, "first-child");
}

/**
 * Returns a CSS selector for the :last-child pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *
 * Returns:
 *   A string representing the :last-child pseudo class selector.
 *
 * Example:
 *   lastChild("li") -> "li:last-child"
 */
string lastChild(string base) {
  return pseudo(base, "last-child");
}

/**
 * Returns a CSS selector for the :nth-child() pseudo class with an integer.
 *
 * Params:
 *   base = The base element selector.
 *   n = The child index.
 *
 * Returns:
 *   A string representing the :nth-child() pseudo class selector.
 *
 * Example:
 *   nthChild("li", 2) -> "li:nth-child(2)"
 */
string nthChild(string base, int n) {
  return "%s:nth-child(%s)".format(base, n);
}

/**
 * Returns a CSS selector for the :nth-child() pseudo class with a formula.
 *
 * Params:
 *   base = The base element selector.
 *   formula = The formula for the nth child.
 *
 * Returns:
 *   A string representing the :nth-child() pseudo class selector.
 *
 * Example:
 *   nthChild("li", "2n+1") -> "li:nth-child(2n+1)"
 */
string nthChild(string base, string formula) {
  return "%s:nth-child(%s)".format(base, formula);
}

/**
 * Returns a CSS selector for the :nth-of-type() pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *   n = The child index.
 *
 * Returns:
 *   A string representing the :nth-of-type() pseudo class selector.
 *
 * Example:
 *   nthOfType("li", 2) -> "li:nth-of-type(2)"
 */
string nthOfType(string base, int n) {
  return "%s:nth-of-type(%s)".format(base, n);
}

/**
 * Returns a CSS selector for the :not() pseudo class.
 *
 * Params:
 *   base = The base element selector.
 *   selector = The selector to negate.
 *
 * Returns:
 *   A string representing the :not() pseudo class selector.
 *
 * Example:
 *   not("p", ".intro") -> "p:not(.intro)"
 */
string not(string base, string selector) {
  return "%s:not(%s)".format(base, selector);
}

/**
 * Returns a CSS selector for an attribute presence.
 *
 * Params:
 *   base = The base element selector.
 *   attribute = The attribute name.
 *
 * Returns:
 *   A string representing the attribute presence selector.
 *
 * Example:
 *   attr("input", "type") -> "input[type]"
 */
string attr(string base, string attribute) {
  return "%s[%s]".format(base, attribute);
}

/**
 * Returns a CSS selector for an attribute with a specific value.
 *
 * Params:
 *   base = The base element selector.
 *   attribute = The attribute name.
 *   value = The attribute value.
 *
 * Returns:
 *   A string representing the attribute value selector.
 *
 * Example:
 *   attr("input", "type", "text") -> "input[type=\"text\"]"
 */
string attr(string base, string attribute, string value) {
  return "%s[%s=%s]".format(base, attribute, cssString(value));
}

/**
 * Returns a CSS selector for an attribute that begins with a specific value.
 *
 * Params:
 *   base = The base element selector.
 *   attribute = The attribute name.
 *   value = The attribute value.
 *
 * Returns:
 *   A string representing the attribute "begins with" selector.
 *
 * Example:
 *   attrStartsWith("a", "href", "https") -> "a[href^=\"https\"]"
 */
string attrStartsWith(string base, string attribute, string value) {
  return "%s[%s^=%s]".format(base, attribute, cssString(value));
}

/**
 * Returns a CSS selector for an attribute that ends with a specific value.
 *
 * Params:
 *   base = The base element selector.
 *   attribute = The attribute name.
 *   value = The attribute value.
 *
 * Returns:
 *   A string representing the attribute "ends with" selector.
 *
 * Example:
 *   attrEndsWith("a", "href", ".pdf") -> "a[href$=\".pdf\"]"
 */
string attrEndsWith(string base, string attribute, string value) {
  return "%s[%s$=%s]".format(base, attribute, cssString(value));
}

/**
 * Returns a CSS selector for an attribute that contains a specific value.
 *
 * Params:
 *   base = The base element selector.
 *   attribute = The attribute name.
 *   value = The attribute value.
 *
 * Returns:
 *   A string representing the attribute "contains" selector.
 *
 * Example:
 *   attrContains("a", "href", "example") -> "a[href*=\"example\"]"
 */
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
