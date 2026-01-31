module uim.html.classes.elements.element;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// Base class for all HTML elements
class HtmlElement : IHtmlElement {
  this() {
    // super();
    _selfClosing = false;
  }

  this(string tag) {
    this();
    this.tagName(tag);
  }

  protected string _tagName;
  protected string _content;
  protected bool _selfClosing;

  // Getter for tagName
  string tagName() {
    return _tagName;
  }

  // Setter for tagName
  IHtmlElement tagName(string value) {
    _tagName = value;
    return this;
  }

  // Getter for content
  string content() {
    return _content;
  }

  // Setter for content
  IHtmlElement content(string value) {
    _content = value;
    return this;
  }

  // Getter for selfClosing
  bool selfClosing() {
    return _selfClosing;
  }

  // Setter for selfClosing
  IHtmlElement selfClosing(bool value) {
    _selfClosing = value;
    return this;
  }

  protected IHtmlAttribute[string] _attributes;
  protected IHtmlElement[] _children;

  bool opEquals(R)(string html) const {
    return this.toString() == html;
  }
  /// Add an attribute to the element
  IHtmlElement attribute(string name, string value) {
    _attributes[name] = new HtmlAttribute(name, value);
    return this;
  }

  /// Get an attribute by name
  IHtmlAttribute attribute(string name) {
    return _attributes.get(name, null);
  }

  // #region ID
  /// Set or get ID attribute
  IHtmlElement id(string value) {
    attribute("id", value);
    return this;
  }

  string id() {
    auto attr = attribute("id");
    return attr ? attr.value : null;
  }
  // #endregion ID

  /// Add CSS class
  IHtmlElement addClass(string className) {
    auto classAttr = attribute("class");
    if (classAttr) {
      classAttr.value(classAttr.value ~ " " ~ className);
    } else {
      attribute("class", className);
    }
    return this;
  }

  /// Set style attribute
  IHtmlElement style(string styleValue) {
    attribute("style", styleValue);
    return this;
  }

  /// Add a child element
  IHtmlElement addChild(HtmlElement child) {
    _children ~= child;
    return this;
  }

  /// Add multiple children
  IHtmlElement addChildren(HtmlElement[] children...) {
    foreach (child; children) {
      addChild(child);
    }
    return this;
  }

  /// Get children array
  IHtmlElement[] children() {
    return _children;
  }

  /// Remove all children
  IHtmlElement clearChildren() {
    _children = [];
    return this;
  }

  /// Set text content
  IHtmlElement text(string textContent) {
    _content = textContent;
    return this;
  }

  /// Get attributes as string
  protected string attributesString() {
    import std.array : join;
    import std.algorithm : map;

    if (_attributes.length == 0)
      return "";

    string[] attrStrings;
    foreach (attribute; _attributes) {
      attrStrings ~= attribute.toString();
    }
    return " " ~ attrStrings.join(" ");
  }

  /// Convert element to HTML string
  override string toString() {
    string html = "<" ~ _tagName ~ attributesString();

    if (_selfClosing) {
      return html ~ " />";
    }

    html ~= ">";

    // Add content
    if (_content.length > 0) {
      html ~= _content;
    }

    // Add children
    foreach (child; _children) {
      html ~= child.toString();
    }

    html ~= "</" ~ _tagName ~ ">";
    return html;
  }

  /// Create a new element
  static HtmlElement opCall(string tag) {
    return new HtmlElement(tag);
  }
}
///
unittest {
  auto div = HtmlElement("div");
  div.id("test").addClass("container");
  assert(div.id == "test");
}
