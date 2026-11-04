/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.element;

import std.exception : assertThrown;

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

/// Base class for renderable HTML nodes
abstract class HtmlNode {
  /// Writes the node to a sink. A whole tree renders into one buffer this way.
  abstract void render(ref Appender!string sink) const;

  /// Renders the node to a string
  override string toString() const {
    auto sink = appender!string;
    render(sink);
    return sink.data;
  }
}

/// An HTML element with tag name, attributes and nested content.
class HtmlElement : HtmlNode {
  this(string tag) {
    _tag = checkHtmlName(tag);
    _isVoid = isVoidElement(tag);
  }

  this(string tag, string content) {
    this(tag);
    if (content.length > 0) {
      text(content);
    }
  }

  this(string tag, string[string] attributes, string content = null) {
    this(tag, content);
    attrs(attributes);
  }

  /// The tag name, e.g. "div"
  string tag() const {
    return _tag;
  }

  /// Sets an attribute (fluent interface). Throws if the name is not a valid HTML name.
  auto attr(string name, string value) {
    return store(name, value, false);
  }

  /// Sets a boolean attribute without value (fluent interface)
  auto boolAttr(string name) {
    return store(name, null, true);
  }

  /// Sets all attributes of an associative array, sorted by name for stable output (fluent interface)
  auto attrs(string[string] attributes) {
    foreach (name; attributes.keys.sort) {
      attr(name, attributes[name]);
    }
    return this;
  }

  /// Removes an attribute (fluent interface)
  auto removeAttr(string name) {
    _attributes = _attributes.filter!(attribute => attribute.name != name).array;
    return this;
  }

  /// Checks whether an attribute is set
  bool hasAttr(string name) const {
    return attrIndex(name) >= 0;
  }

  /// Returns the value of an attribute
  string getAttr(string name) const {
    auto index = attrIndex(name);
    return index < 0 ? null : _attributes[index].value;
  }

  /// All attribute names in insertion order
  string[] attrNames() const {
    string[] names;
    foreach (attribute; _attributes) {
      names ~= attribute.name;
    }
    return names;
  }

  /// Sets the id attribute (fluent interface)
  auto id(string value) {
    return attr("id", value);
  }

  /// All classes of the class attribute
  string[] classes() const {
    return getAttr("class").split;
  }

  /// Checks whether the element has a class
  bool hasClass(string className) const {
    return classes.canFind(className);
  }

  /// Adds classes to the class attribute, skipping those already present (fluent interface)
  auto addClass(string[] classNames...) {
    auto merged = classes;
    foreach (className; classNames.map!(names => names.split).joiner) {
      if (!merged.canFind(className)) {
        merged ~= className;
      }
    }
    return merged.length > 0 ? attr("class", merged.join(" ")) : this;
  }

  /// Removes classes from the class attribute (fluent interface)
  auto removeClass(string[] classNames...) {
    auto remaining = classes.filter!(className => !classNames.canFind(className)).array;
    return remaining.length > 0 ? attr("class", remaining.join(" ")) : removeAttr("class");
  }

  /// Adds a class if it is missing, removes it otherwise (fluent interface)
  auto toggleClass(string className) {
    return hasClass(className) ? removeClass(className) : addClass(className);
  }

  /// Sets the style attribute from declarations (fluent interface)
  auto style(string[string] declarations) {
    return attr("style", styleValue(declarations));
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
    return add(new HtmlText(content));
  }

  /// Appends raw, unescaped HTML content (fluent interface)
  auto raw(string html) {
    return add(new HtmlRaw(html));
  }

  /// Appends a child node (fluent interface)
  auto add(HtmlNode child) {
    _children ~= child;
    return this;
  }

  /// Creates and appends a child element
  HtmlElement add(string childTag, string content = null) {
    auto childElement = new HtmlElement(childTag, content);
    add(childElement);
    return childElement;
  }

  /// All child nodes
  HtmlNode[] children() {
    return _children.dup;
  }

  /// Writes the element including its children to a sink
  override void render(ref Appender!string sink) const {
    sink.put('<');
    sink.put(_tag);
    foreach (attribute; _attributes) {
      sink.put(' ');
      if (attribute.isBoolean) {
        sink.put(attribute.name);
      } else {
        putHtmlAttr(sink, attribute.name, attribute.value);
      }
    }
    sink.put('>');

    if (_isVoid) {
      return;
    }

    foreach (childNode; _children) {
      childNode.render(sink);
    }
    sink.put("</");
    sink.put(_tag);
    sink.put('>');
  }

  private auto store(string name, string value, bool isBoolean) {
    auto index = attrIndex(name);
    if (index < 0) {
      _attributes ~= Attribute(checkHtmlName(name), value, isBoolean);
    } else {
      _attributes[index].value = value;
      _attributes[index].isBoolean = isBoolean;
    }
    return this;
  }

  // Elements carry few attributes: a linear scan beats a hash table and keeps insertion order for free
  private ptrdiff_t attrIndex(string name) const {
    foreach (i, attribute; _attributes) {
      if (attribute.name == name) {
        return i;
      }
    }
    return -1;
  }

  private static struct Attribute {
    string name;
    string value;
    bool isBoolean;
  }

  private string _tag;
  private bool _isVoid;
  private Attribute[] _attributes;
  private HtmlNode[] _children;
}

/// Escaped text node
class HtmlText : HtmlNode {
  this(string content) {
    _content = content;
  }

  override void render(ref Appender!string sink) const {
    putHtmlText(sink, _content);
  }

  private string _content;
}

/// Raw, unescaped HTML node
class HtmlRaw : HtmlNode {
  this(string html) {
    _html = html;
  }

  override void render(ref Appender!string sink) const {
    sink.put(_html);
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

  // text is escaped like uim.core's escapeHtml
  assert(htmlTag("p", `a'b"c`) == escapeHtml(`a'b"c`).format!"<p>%s</p>");

  // output does not depend on hash order
  assert(htmlElement("a").attrs(["z": "1", "b": "2", "m": "3"]).attrNames == ["b", "m", "z"]);

  // an attribute is either boolean or valued, the latest call wins
  assert(htmlElement("a").boolAttr("x").attr("x", "1").toString == `<a x="1"></a>`);
  assert(htmlElement("a").attr("x", "1").boolAttr("x").toString == `<a x></a>`);
  assert(htmlElement("a").attr("x", "1").attr("x", "2").attrNames == ["x"]);

  // classes
  auto classy = htmlElement("div").addClass("a b", "c").addClass("a");
  assert(classy.getAttr("class") == "a b c");
  assert(classy.classes == ["a", "b", "c"]);
  assert(classy.hasClass("b"));
  assert(!classy.hasClass("ab"));
  assert(classy.removeClass("b").getAttr("class") == "a c");
  assert(classy.toggleClass("a").getAttr("class") == "c");
  assert(classy.toggleClass("a").getAttr("class") == "c a");
  assert(classy.removeClass("a", "c").toString == "<div></div>");
  assert(htmlElement("div").addClass("").toString == "<div></div>");

  // no empty text node for missing content
  assert(new HtmlElement("p", cast(string)null).children.length == 0);

  // invalid names are rejected instead of injected
  assertThrown(htmlElement("a").attr("x onload=alert(1)", "1"));
  assertThrown(htmlElement("a").boolAttr("x y"));
  assertThrown(htmlElement("a").data("x y", "1"));
  assertThrown(htmlElement("a><script"));

  // any node can be a child
  auto wrapped = htmlElement("div").add(htmlTable());
  assert(wrapped.toString == "<div><table><tbody></tbody></table></div>");
}
