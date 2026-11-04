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

/**
 * Parses declarations, e.g. the output of the helpers in uim.web.css.properties.
 *
 * Semicolons inside strings and parentheses, as in url("a;b"), do not end a declaration.
 */
CssDeclaration[] parseCssDeclarations(string declarations) {
  enum important = "!important";

  CssDeclaration[] result;
  foreach (part; splitDeclarations(declarations)) {
    auto colonIndex = part.indexOf(':');
    if (colonIndex <= 0) {
      continue;
    }
    string value = part[colonIndex + 1 .. $].strip;
    bool isImportant = value.endsWith(important);
    if (isImportant) {
      value = value[0 .. $ - important.length].stripRight;
    }
    result ~= new CssDeclaration(part[0 .. colonIndex].strip, value, isImportant);
  }
  return result;
}

private string[] splitDeclarations(string text) {
  string[] parts;
  size_t start;
  int depth;
  char quote = 0;
  for (size_t i; i < text.length; i++) {
    char c = text[i];
    if (quote != 0) {
      if (c == '\\') {
        i++;
      } else if (c == quote) {
        quote = 0;
      }
    } else if (c == '"' || c == '\'') {
      quote = c;
    } else if (c == '(') {
      depth++;
    } else if (c == ')') {
      depth--;
    } else if (c == ';' && depth <= 0) {
      parts ~= text[start .. i];
      start = i + 1;
    }
  }
  if (start < text.length) {
    parts ~= text[start .. $];
  }
  return parts;
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

  // parsing
  auto parsed = parseCssDeclarations("color: red; margin: 0 !important;");
  assert(parsed.length == 2);
  assert(parsed[0].toString == "color: red;");
  assert(parsed[1].important);
  assert(parsed[1].value == "0");

  assert(parseCssDeclarations(`background: url("a;b.png"); content: "x;y"`).length == 2);
  assert(parseCssDeclarations("background: url(data:image/png;base64,AA==); color: red").length == 2);
  assert(parseCssDeclarations(`content: "a\\"; b"; color: red`).length == 2);
  assert(parseCssDeclarations("").length == 0);
  assert(parseCssDeclarations("no colon here").length == 0);
}
