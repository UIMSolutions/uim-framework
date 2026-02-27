/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.element;

import uim.html;

mixin(ShowModule!());

@safe:

/// Base class for all HTML elements
class HtmlElement : IHtmlElement {
  this() {
    // super();
    _selfClosing = false;
    initialize();
  }

  this(string tag, string content = "") {
    this();
    this.tagName(tag);
    if (content.length > 0) {
      addContent(content);
    }
    initialize();
  }

  this(string tag, string[] classes, string content = "") {
    this();
    this.tagName(tag);
    foreach (className; classes) {
      addClass(className);
    }
    if (content.length > 0) {
      addContent(content);
    }
    initialize();
  }

  this(string tag, string[] classes, IHtmlElement[] elements) {
    this();
    this.tagName(tag);
    foreach (className; classes) {
      addClass(className);
    }
    elements.each!(element => addContent(element));

    initialize();
  }

  this(string tag, string[string] attributes, string content = "") {
    this();
    this.tagName(tag);

    attributes.byKeyValue.each!(kv => attribute(kv.key, kv.value));

    if (content.length > 0) {
      addContent(content);
    }

    initialize();
  }

  this(string tag, string[string] attributes, IHtmlElement[] elements) {
    this();
    this.tagName(tag);

    attributes.byKeyValue.each!(kv => attribute(kv.key, kv.value));

    elements.each!(element => addContent(element));

    initialize();
  }

  this(string tag, string[] classes, string[string] attributes, string content = "") {
    this();
    this.tagName(tag);
    foreach (className; classes) {
      addClass(className);
    }
    
    this.attributes(attributes);

    if (content.length > 0) {
      addContent(content);
    }

    initialize();
  }

  this(string tag, string[] classes, string[string] attributes, IHtmlElement[] elements) {
    this();
    this.tagName(tag);
    foreach (className; classes) {
      addClass(className);
    }
    attributes.byKeyValue.each!(kv => attribute(kv.key, kv.value));

    elements.each!(element => addContent(element));

    initialize();
  }

  bool initialize(Json[string] initData = null) {
    return true;
  }

  protected string _tagName;
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

  // #region content
  // Getter for content
  string content() {
    return _content;
  }

  // Setter for content
  protected string _content;
  IHtmlElement content(string[] values...) {
    return content(values.dup);
  }

  IHtmlElement content(string[] values) {
    _content = values.join("");
    return this;
  }

  IHtmlElement content(IHtmlElement[] elements...) {
    return content(elements.dup);
  }

  IHtmlElement content(IHtmlElement[] elements) {
    _content = elements.map!(element => element.toString()).join("");
    return this;
  }

  IHtmlElement addContent(string[] values...) {
    return addContent(values.dup);
  }

  IHtmlElement addContent(string[] values) {
    _content ~= values.join("");
    return this;
  }

  IHtmlElement addContent(IHtmlElement[] elements...) {
    return addContent(elements.dup);
  }

  IHtmlElement addContent(IHtmlElement[] elements) {
    _content ~= elements.map!(element => element.toString()).join("");
    return this;
  }
  // #endregion content

  // Getter for selfClosing
  bool selfClosing() {
    return _selfClosing;
  }

  // Setter for selfClosing
  IHtmlElement selfClosing(bool value) {
    _selfClosing = value;
    return this;
  }

  protected IHtmlElement[] _children;

  bool opEquals(const string html) {
    return toString() == html;
  }

  // #region attributes
  protected IHtmlAttribute[string] _attributes;
  /// Add an attribute to the element
  IHtmlElement attributes(string[string] map) {
    map.byKeyValue.each!((kv) => attribute(kv.key, kv.value));
    return this;
  }

  IHtmlElement attribute(string name, string value) {
    _attributes[name] = new HtmlAttribute(name, value);
    return this;
  }

  bool hasAttribute(string name) {
    return (name in _attributes) && _attributes[name] !is null;
  }
  ///
  unittest {
    auto div = HtmlElement("div").attribute("data-test", "value");
    assert(div.hasAttribute("data-test"));
    assert(!div.hasAttribute("nonexistent"));
  }

  /// Get an attribute by name
  IHtmlAttribute attribute(string name) {
    return _attributes.get(name, null);
  }

  /// Remove an attribute by name
  IHtmlElement removeAttribute(string name) {
    _attributes.remove(name);
    return this;
  }
  // #endregion attributes

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

  // #region classes
  /**
    * Get CSS classes as array. Returns null if no class attribute is set.
    */
  string[] classes() {
    auto classAttr = attribute("class");
    if (classAttr) {
      return classAttr.value.split.uniq.array.sort.array;  
    }
    return null;
  }
  ///
  unittest {
    // auto div = HtmlElement("div").addClass("class1").addClass("class2").addClass("class1");
    // writeln(div.classes()); // Should print ["class1", "class2"]
    // auto classList = div.classes();
    // assert(classList.length == 2);
    // assert(classList[0] == "class1");
    // assert(classList[1] == "class2");
  }

  IHtmlElement classes(string[] classNames) {
    attribute("class", classNames.sort.join(" "));
    return this;
  }
  ///
  unittest {
    auto div = HtmlElement("div").classes(["class2", "class1"]);
    auto classList = div.classes();
    assert(classList.length == 2);
    assert(classList[0] == "class1");
    assert(classList[1] == "class2");
  }

  // #region hasClass
  bool hasAllClass(string[] classNames) {
    return classNames.all!(className => hasClass(className));
  }
  ///
  unittest {
    auto div = HtmlElement("div").addClass("class1").addClass("class2");  
    assert(div.hasAllClass(["class1", "class2"]));

    auto div2 = HtmlElement("div").addClass("class1");
    assert(!div2.hasAllClass(["class1", "class2"]));
  }

  bool hasAnyClass(string[] classNames) {
    return classNames.any!(className => hasClass(className));
  }
  ///
  unittest {
    auto div = HtmlElement("div").addClass("class1").addClass("class2");  
    assert(div.hasAnyClass(["class1", "class3"]));    

    auto div2 = HtmlElement("div").addClass("class1");  
    assert(div2.hasAnyClass(["class1", "class3"]));
  }

  bool hasClass(string className) {
    auto classList = classes();
    return classList && classList.canFind(className);
  }
  // #endregion hasClass

  /// Add CSS class
  IHtmlElement addClasses(string[] classNames) {
    classNames.each!(className => addClass(className));
    return this;
  }

  IHtmlElement addClass(string className) {
    auto classAttr = attribute("class");
    if (classAttr) {
      classAttr.value(classAttr.value ~ " " ~ className);
    } else {
      attribute("class", className);
    }
    return this;
  }
  ///
  unittest {
    auto div = HtmlElement("div").addClass("class1").addClass("class2");
    assert(div.hasClass("class1"));
    assert(div.hasClass("class2"));
    assert(!div.hasClass("class3"));
  }

  IHtmlElement removeClasses(string[] classNames) {
    classNames.each!(className => removeClass(className));
    return this;
  }

  IHtmlElement removeClass(string className) {
    auto classAttr = attribute("class");
    if (classAttr) {
      attribute("class", classAttr.value.replace(className, "").strip());
    }
    return this;
  }
  // #endregion classes

  /// Set style attribute
  IHtmlElement style(string styleValue) {
    attribute("style", styleValue);
    return this;
  }

  // /// Add a child element
  // IHtmlElement addChild(IHtmlElement child) {
  //   _children ~= child;
  //   return this;
  // }

  // /// Add multiple children
  // IHtmlElement addChildren(IHtmlElement[] children...) {
  //   foreach (child; children) {
  //     addChild(child);
  //   }
  //   return this;
  // }

  // /// Get children array
  // IHtmlElement[] children() {
  //   return _children;
  // }

  // /// Remove all children
  // IHtmlElement clearChildren() {
  //   _children = [];
  //   return this;
  // }

  /// Set text content
  IHtmlElement text(string textContent) {
    _content = textContent;
    return this;
  }

  /// Get attributes as string
  protected string attributesString() {
    import std.array : join;
    import std.algorithm : map;

    if (_attributes.length == 0) {
      return "";
    }

    string[] attrStrings;
    string id = "";
    string classes = "";
    foreach (attribute; _attributes) {
      if (attribute.name == "id") {
        id = attribute.toString();
      } else if (attribute.name == "class") {
        classes = "class=\"" ~ attribute.value.split.uniq.array.sort.join(" ") ~ "\"";
      } else {
        attrStrings ~= attribute.toString();
      }
    }
    return " " ~ [id, classes, attrStrings.sort.join(" ")].filter!(a => a.length > 0).join(" ");
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
