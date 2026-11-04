/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.rule;

import uim.web;

mixin(ShowModule!());

@safe:

/// A CSS rule: a selector with a block of declarations.
class CssRule {
  this(string selector) {
    _selector = selector;
  }

  this(string selector, string[string] declarations) {
    this(selector);
    foreach (property, value; declarations) {
      set(property, value);
    }
  }

  /// The selector of the rule, e.g. ".button"
  string selector() const {
    return _selector;
  }

  /// Sets or replaces a declaration (fluent interface)
  auto set(string property, string value) {
    if (property !in _declarations) {
      _order ~= property;
    }
    _declarations[property] = value;
    return this;
  }

  /// Sets an !important declaration (fluent interface)
  auto setImportant(string property, string value) {
    _importants[property] = true;
    return set(property, value);
  }

  /// Removes a declaration (fluent interface)
  auto remove(string property) {
    _declarations.remove(property);
    _importants.remove(property);
    _order = _order.filter!(p => p != property).array;
    return this;
  }

  /// Checks whether the rule declares a property
  bool has(string property) const {
    return (property in _declarations) !is null;
  }

  /// Returns the value of a declared property
  string get(string property) const {
    auto found = property in _declarations;
    return found is null ? null : *found;
  }

  /// All declared property names in insertion order
  string[] properties() const {
    return _order.dup;
  }

  /// Number of declarations
  size_t length() const {
    return _declarations.length;
  }

  /// Renders the rule, e.g. ".button { color: red; }"
  override string toString() const {
    if (_declarations.length == 0) {
      return "%s { }".format(_selector);
    }
    string body = _order
      .filter!(property => property in _declarations)
      .map!((property) {
        auto value = _declarations[property];
        return (property in _importants)
          ? "%s: %s !important;".format(property, value)
          : "%s: %s;".format(property, value);
      })
      .join(" ");
    return "%s { %s }".format(_selector, body);
  }

  private string _selector;
  private string[string] _declarations;
  private bool[string] _importants;
  private string[] _order;
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
}
