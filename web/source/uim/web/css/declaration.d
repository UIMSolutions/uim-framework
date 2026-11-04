/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.declaration;

import uim.web;

mixin(ShowModule!());

@safe:

/// A single CSS declaration (property: value) with optional !important flag.
class CssDeclaration {
  this(string property, string value, bool important = false) {
    _property = property;
    _value = value;
    _important = important;
  }

  /// The CSS property name, e.g. "color"
  string property() const {
    return _property;
  }

  /// The declared value, e.g. "red"
  string value() const {
    return _value;
  }

  /// Whether the declaration is flagged !important
  bool important() const {
    return _important;
  }

  /// Renders the declaration, e.g. "color: red !important;"
  override string toString() const {
    return _important
      ? "%s: %s !important;".format(_property, _value)
      : "%s: %s;".format(_property, _value);
  }

  private string _property;
  private string _value;
  private bool _important;
}

/// Creates a CSS declaration, e.g. cssDecl("color", "red")
CssDeclaration cssDecl(string property, string value) {
  return new CssDeclaration(property, value);
}

/// Creates an !important CSS declaration
CssDeclaration cssDeclImportant(string property, string value) {
  return new CssDeclaration(property, value, true);
}

/// Renders a property/value pair directly, e.g. cssProperty("color", "red") -> "color: red;"
string cssProperty(string property, string value) {
  return "%s: %s;".format(property, value);
}

/// Renders a property/value pair with !important
string cssPropertyImportant(string property, string value) {
  return "%s: %s !important;".format(property, value);
}

///
unittest {
  auto decl = new CssDeclaration("color", "red");
  assert(decl.property == "color");
  assert(decl.value == "red");
  assert(!decl.important);
  assert(decl.toString == "color: red;");

  auto important = new CssDeclaration("display", "none", true);
  assert(important.important);
  assert(important.toString == "display: none !important;");

  assert(cssDecl("margin", "0").toString == "margin: 0;");
  assert(cssDeclImportant("margin", "0").toString == "margin: 0 !important;");
  assert(cssProperty("padding", "1rem") == "padding: 1rem;");
  assert(cssPropertyImportant("padding", "1rem") == "padding: 1rem !important;");
}
