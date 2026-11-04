/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.rule;

import uim.web;

mixin(ShowModule!());

@safe:

/// Base class for everything a stylesheet can contain.
abstract class CssNode {
  /// Writes the node to a sink, minified or in the readable form
  abstract void render(ref Appender!string sink, bool minified) const;

  /// Renders the readable form
  override string toString() const {
    auto sink = appender!string;
    render(sink, false);
    return sink.data;
  }

  /// Renders the node without unnecessary whitespace
  string minify() const {
    auto sink = appender!string;
    render(sink, true);
    return sink.data;
  }
}

/// A CSS rule: a selector with a block of declarations.
class CssRule : CssNode {
  this(string selector) {
    _selector = selector;
  }

  /// Declarations of an associative array are sorted by property for stable output
  this(string selector, string[string] declarations) {
    this(selector);
    foreach (property; declarations.keys.sort) {
      set(property, declarations[property]);
    }
  }

  /// The selector of the rule, e.g. ".button"
  string selector() const {
    return _selector;
  }

  /// Sets or replaces a declaration, which is not !important afterwards (fluent interface)
  auto set(string property, string value) {
    return store(property, value, false);
  }

  /// Sets an !important declaration (fluent interface)
  auto setImportant(string property, string value) {
    return store(property, value, true);
  }

  /// Applies declaration strings, e.g. rule.apply(flexCenter, margin(px(8))) (fluent interface)
  auto apply(string[] declarations...) {
    foreach (declaration; declarations.map!(text => parseCssDeclarations(text)).joiner) {
      store(declaration.property, declaration.value, declaration.important);
    }
    return this;
  }

  /// Removes a declaration (fluent interface)
  auto remove(string property) {
    _declarations = _declarations.filter!(declaration => declaration.property != property).array;
    return this;
  }

  /// Checks whether the rule declares a property
  bool has(string property) const {
    return declarationIndex(property) >= 0;
  }

  /// Returns the value of a declared property
  string get(string property) const {
    auto index = declarationIndex(property);
    return index < 0 ? null : _declarations[index].value;
  }

  /// All declared property names in insertion order
  string[] properties() const {
    string[] names;
    foreach (declaration; _declarations) {
      names ~= declaration.property;
    }
    return names;
  }

  /// Number of declarations
  size_t length() const {
    return _declarations.length;
  }

  /// Writes the rule to a sink, e.g. ".button { color: red; }"
  override void render(ref Appender!string sink, bool minified) const {
    sink.put(_selector);
    sink.put(minified ? "{" : " {");
    foreach (i, declaration; _declarations) {
      if (minified) {
        if (i > 0) {
          sink.put(';');
        }
      } else {
        sink.put(' ');
      }
      sink.put(declaration.property);
      sink.put(minified ? ":" : ": ");
      sink.put(declaration.value);
      if (declaration.important) {
        sink.put(minified ? "!important" : " !important");
      }
      if (!minified) {
        sink.put(';');
      }
    }
    sink.put(minified ? "}" : " }");
  }

  private auto store(string property, string value, bool important) {
    auto index = declarationIndex(property);
    if (index < 0) {
      _declarations ~= Declaration(property, value, important);
    } else {
      _declarations[index].value = value;
      _declarations[index].important = important;
    }
    return this;
  }

  private ptrdiff_t declarationIndex(string property) const {
    foreach (i, declaration; _declarations) {
      if (declaration.property == property) {
        return i;
      }
    }
    return -1;
  }

  private static struct Declaration {
    string property;
    string value;
    bool important;
  }

  private string _selector;
  private Declaration[] _declarations;
}

/// Creates a CSS rule, e.g. cssRule(".button")
CssRule cssRule(string selector) {
  return new CssRule(selector);
}

/// Creates a CSS rule from an associative array of declarations
CssRule cssRule(string selector, string[string] declarations) {
  return new CssRule(selector, declarations);
}

///
unittest {
  auto rule = new CssRule(".button");
  assert(rule.selector == ".button");
  assert(rule.length == 0);
  assert(rule.toString == ".button { }");

  rule.set("color", "red").set("display", "block");
  assert(rule.length == 2);
  assert(rule.has("color"));
  assert(!rule.has("margin"));
  assert(rule.get("color") == "red");
  assert(rule.get("unknown") is null);
  assert(rule.properties == ["color", "display"]);
  assert(rule.toString == ".button { color: red; display: block; }");

  rule.setImportant("display", "none");
  assert(rule.toString == ".button { color: red; display: none !important; }");

  rule.remove("color");
  assert(!rule.has("color"));
  assert(rule.toString == ".button { display: none !important; }");

  auto fromMap = cssRule("p", ["margin": "0", "padding": "1rem"]);
  assert(fromMap.length == 2);
  assert(fromMap.has("margin"));
  assert(fromMap.has("padding"));

  assert(cssRule("a").set("color", "blue").toString == "a { color: blue; }");

  // output does not depend on hash order
  assert(cssRule("a", ["z": "1", "b": "2", "m": "3"]).properties == ["b", "m", "z"]);

  // set() replaces the !important flag together with the value
  assert(cssRule("a").setImportant("c", "1").set("c", "2").toString == "a { c: 2; }");

  // the property helpers feed into rules
  auto applied = cssRule(".box").apply(flexCenter, margin(px(8)), cssPropertyImportant("color", "red"));
  assert(applied.properties == ["display", "justify-content", "align-items", "margin", "color"]);
  assert(applied.get("margin") == "8px");
  assert(applied.toString.canFind("color: red !important;"));

  // minified
  assert(cssRule("a").minify == "a{}");
  assert(cssRule("a").set("b", "1").setImportant("c", "2").minify == "a{b:1;c:2!important}");
  assert(cssRule("a").set("content", `"x; y { z }"`).minify == `a{content:"x; y { z }"}`);
}
