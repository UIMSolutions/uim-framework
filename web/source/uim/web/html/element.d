/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.element;

import uim.web;

mixin(ShowModule!());

@safe:

/// HTML elements without a closing tag (void elements)
immutable string[] voidElements = [
  "area", "base", "br", "col", "embed", "hr", "img", "input",
  "link", "meta", "param", "source", "track", "wbr"
];

/// Checks whether a tag name denotes a void element
bool isVoidElement(string tag) {
  return voidElements.canFind(tag.toLower);
}

/// An HTML element with tag name, attributes and nested content.
class HtmlElement : HtmlNode {
  this(string tag) {
    _tag = tag;
  }

  this(string tag, string content) {
    this(tag);
    text(content);
  }

  this(string tag, string[string] attributes, string content = null) {
    this(tag);
    attrs(attributes);
    if (content.length > 0) {
      text(content);
    }
  }

  /// The tag name, e.g. "div"
  string tag() const {
    return _tag;
  }

  /// Sets an attribute (fluent interface)
  auto attr(string name, string value) {
    _attributes[name] = value;
    if (!_order.canFind(name)) {
      _order ~= name;
    }
    return this;
  }

  /// Sets a boolean attribute without value (fluent interface)
  auto boolAttr(string name) {
    _booleans[name] = true;
    if (!_order.canFind(name)) {
      _order ~= name;
    }
    return this;
  }

  /// Sets all attributes of an associative array (fluent interface)
  auto attrs(string[string] attributes) {
    foreach (name, value; attributes) {
      attr(name, value);
    }
    return this;
  }

  /// Removes an attribute (fluent interface)
  auto removeAttr(string name) {
    _attributes.remove(name);
    _booleans.remove(name);
    _order = _order.filter!(n => n != name).array;
    return this;
  }

  /// Checks whether an attribute is set
  bool hasAttr(string name) const {
    return (name in _attributes) !is null || (name in _booleans) !is null;
  }

  /// Returns the value of an attribute
  string getAttr(string name) const {
    auto found = name in _attributes;
    return found is null ? null : *found;
  }

  /// All attribute names in insertion order
  string[] attrNames() const {
    return _order.dup;
  }

  /// Sets the id attribute (fluent interface)
  auto id(string value) {
    return attr("id", value);
  }

  /// Adds one or more classes to the class attribute (fluent interface)
  auto addClass(string[] classNames...) {
    auto existing = getAttr("class");
    auto merged = existing is null
      ? mergeClasses(classNames.array)
      : mergeClasses([existing] ~ classNames.array);
    return attr("class", merged);
  }

  /// Sets the style attribute from declarations (fluent interface)
  auto style(string[string] declarations) {
    string styleValue = declarations.keys.sort
      .map!(property => "%s: %s;".format(property, declarations[property]))
      .join(" ");
    return attr("style", styleValue);
  }

  /// Sets a data-* attribute (fluent interface)
  auto data(string name, string value) {
    return attr("data-" ~ name, value);
  }

  /// Sets an aria-* attribute (fluent interface)
  auto aria(string name, string value) {
    return attr("aria-" ~ name, value);
  }

  /// Appends escaped text content (fluent interface)
  auto text(string content) {
    _children ~= new HtmlText(content);
    return this;
  }

  /// Appends raw, unescaped HTML content (fluent interface)
  auto raw(string html) {
    _children ~= new HtmlRaw(html);
    return this;
  }

  /// Appends a child element (fluent interface)
  auto add(HtmlElement childElement) {
    _children ~= childElement;
    return this;
  }

  /// Creates and appends a child element
  HtmlElement add(string childTag, string content = null) {
    auto childElement = new HtmlElement(childTag);
    if (content.length > 0) {
      childElement.text(content);
    }
    add(childElement);
    return childElement;
  }

  /// All child nodes
  HtmlNode[] children() {
    return _children.dup;
  }

  /// Renders the element including its children
  override string toString() const {
    string attrs = _order
      .map!((name) {
        if (name in _booleans) {
          return name;
        }
        return htmlAttr(name, _attributes[name]);
      })
      .join(" ");

    string openTag = attrs.length > 0
      ? "<%s %s>".format(_tag, attrs)
      : "<%s>".format(_tag);

    if (isVoidElement(_tag)) {
      return openTag;
    }

    string inner = _children.map!(childNode => childNode.toString).join;
    return "%s%s</%s>".format(openTag, inner, _tag);
  }

  private string _tag;
  private string[string] _attributes;
  private bool[string] _booleans;
  private string[] _order;
  private HtmlNode[] _children;
}

/// Base class for renderable HTML nodes
abstract class HtmlNode {
  abstract override string toString() const;
}

/// Escaped text node
class HtmlText : HtmlNode {
  this(string content) {
    _content = content;
  }

  override string toString() const {
    return escapeHtml(_content);
  }

  private string _content;
}

/// Raw, unescaped HTML node
class HtmlRaw : HtmlNode {
  this(string html) {
    _html = html;
  }

  override string toString() const {
    return _html;
  }

  private string _html;
}

/// Creates an HTML element, e.g. htmlElement("div")
HtmlElement htmlElement(string tag) {
  return new HtmlElement(tag);
}

/// Creates an HTML element with text content, e.g. htmlElement("p", "Hello")
HtmlElement htmlElement(string tag, string content) {
  return new HtmlElement(tag, content);
}

/// Creates an HTML element with attributes and optional content
HtmlElement htmlElement(string tag, string[string] attributes, string content = null) {
  return new HtmlElement(tag, attributes, content);
}

/// Renders a complete element in one call, e.g. htmlTag("p", "Hello") -> "<p>Hello</p>"
string htmlTag(string tag, string content = null) {
  return new HtmlElement(tag, content).toString;
}

/// Renders a complete element with attributes in one call
string htmlTag(string tag, string[string] attributes, string content = null) {
  return new HtmlElement(tag, attributes, content).toString;
}

///
unittest {
  assert(isVoidElement("br"));
  assert(isVoidElement("IMG"));
  assert(!isVoidElement("div"));

  // simple element
  auto div = new HtmlElement("div");
  assert(div.tag == "div");
  assert(div.toString == "<div></div>");

  // text content is escaped
  auto p = new HtmlElement("p", "a < b");
  assert(p.toString == "<p>a &lt; b</p>");

  // attributes
  auto link = new HtmlElement("a")
    .attr("href", "https://example.com")
    .attr("title", "Example")
    .text("Link");
  assert(link.toString == `<a href="https://example.com" title="Example">Link</a>`);
  assert(link.hasAttr("href"));
  assert(!link.hasAttr("target"));
  assert(link.getAttr("href") == "https://example.com");
  assert(link.getAttr("target") is null);
  assert(link.attrNames == ["href", "title"]);

  link.removeAttr("title");
  assert(!link.hasAttr("title"));
  assert(link.toString == `<a href="https://example.com">Link</a>`);

  // boolean attributes
  auto input = new HtmlElement("input").attr("type", "checkbox").boolAttr("checked");
  assert(input.toString == `<input type="checkbox" checked>`);
  assert(input.hasAttr("checked"));

  // void elements have no closing tag
  assert(new HtmlElement("br").toString == "<br>");
  assert(new HtmlElement("img").attr("src", "a.png").toString == `<img src="a.png">`);

  // fluent helpers
  auto box = new HtmlElement("div")
    .id("box")
    .addClass("container", "active")
    .addClass("visible")
    .data("role", "panel")
    .aria("hidden", "false")
    .style(["color": "red"]);
  assert(box.getAttr("id") == "box");
  assert(box.getAttr("class") == "container active visible");
  assert(box.getAttr("data-role") == "panel");
  assert(box.getAttr("aria-hidden") == "false");
  assert(box.getAttr("style") == "color: red;");

  // nested elements
  auto list = new HtmlElement("ul");
  list.add("li", "one");
  list.add("li", "two");
  assert(list.children.length == 2);
  assert(list.toString == "<ul><li>one</li><li>two</li></ul>");

  // raw content is not escaped
  auto rawDiv = new HtmlElement("div").raw("<span>raw</span>");
  assert(rawDiv.toString == "<div><span>raw</span></div>");

  // attrs from map
  auto mapped = new HtmlElement("div").attrs(["id": "x", "class": "y"]);
  assert(mapped.hasAttr("id"));
  assert(mapped.hasAttr("class"));

  // factory functions
  assert(htmlElement("span", "hi").toString == "<span>hi</span>");
  assert(htmlElement("span", ["class": "c"], "hi").toString == `<span class="c">hi</span>`);
  assert(htmlTag("p", "Hello") == "<p>Hello</p>");
  assert(htmlTag("p", ["class": "intro"], "Hello") == `<p class="intro">Hello</p>`);
  assert(htmlTag("hr") == "<hr>");
}
