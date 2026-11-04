/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.variables;

import uim.web;

mixin(ShowModule!());

@safe:

/// Name of a CSS custom property, e.g. cssVarName("primary") -> "--primary"
string cssVarName(string name) {
  return name.startsWith("--") ? name : "--" ~ name;
}

/// CSS var() function, e.g. cssVar("primary") -> "var(--primary)"
string cssVar(string name) {
  return "var(%s)".format(cssVarName(name));
}

/// CSS var() function with fallback, e.g. cssVar("primary", "blue") -> "var(--primary, blue)"
string cssVar(string name, string fallback) {
  return "var(%s, %s)".format(cssVarName(name), fallback);
}

/// A collection of CSS custom properties, renderable as declarations or a :root rule.
class CssVariables : CssNode {
  /// Defines a custom property (fluent interface), e.g. set("primary", "#3498db")
  auto set(string name, string value) {
    auto varName = cssVarName(name);
    if (varName !in _variables) {
      _order ~= varName;
    }
    _variables[varName] = value;
    return this;
  }

  /// Removes a custom property (fluent interface)
  auto remove(string name) {
    auto varName = cssVarName(name);
    _variables.remove(varName);
    _order = _order.filter!(n => n != varName).array;
    return this;
  }

  /// Checks whether a custom property is defined
  bool has(string name) const {
    return (cssVarName(name) in _variables) !is null;
  }

  /// Returns the value of a custom property
  string get(string name) const {
    auto found = cssVarName(name) in _variables;
    return found is null ? null : *found;
  }

  /// All custom property names in insertion order
  string[] names() const {
    return _order.dup;
  }

  /// Number of defined custom properties
  size_t length() const {
    return _variables.length;
  }

  /// Renders the custom properties as declarations, e.g. "--primary: #3498db;"
  string toDeclarations() const {
    return _order
      .filter!(name => name in _variables)
      .map!(name => "%s: %s;".format(name, _variables[name]))
      .join(" ");
  }

  /// Renders the custom properties as a rule for a selector (default ":root")
  string toRule(string selector = ":root") const {
    return "%s { %s }".format(selector, toDeclarations);
  }

  /// Writes the custom properties as a :root rule to a sink
  override void render(ref Appender!string sink, bool minified) const {
    auto rule = new CssRule(":root");
    foreach (name; _order) {
      rule.set(name, _variables[name]);
    }
    rule.render(sink, minified);
  }

  private string[string] _variables;
  private string[] _order;
}

/// Creates a collection of CSS custom properties
CssVariables cssVariables() {
  return new CssVariables;
}

/// Creates a collection of CSS custom properties from an associative array, sorted by name
CssVariables cssVariables(string[string] values) {
  auto variables = new CssVariables;
  foreach (name; values.keys.sort) {
    variables.set(name, values[name]);
  }
  return variables;
}

///
unittest {
  assert(cssVarName("primary") == "--primary");
  assert(cssVarName("--primary") == "--primary");
  assert(cssVar("primary") == "var(--primary)");
  assert(cssVar("primary", "blue") == "var(--primary, blue)");

  auto vars = new CssVariables;
  assert(vars.length == 0);

  vars.set("primary", "#3498db").set("gap", "1rem");
  assert(vars.length == 2);
  assert(vars.has("primary"));
  assert(vars.has("--gap"));
  assert(!vars.has("unknown"));
  assert(vars.get("primary") == "#3498db");
  assert(vars.get("unknown") is null);
  assert(vars.names == ["--primary", "--gap"]);
  assert(vars.toDeclarations == "--primary: #3498db; --gap: 1rem;");
  assert(vars.toRule == ":root { --primary: #3498db; --gap: 1rem; }");
  assert(vars.toRule("html") == "html { --primary: #3498db; --gap: 1rem; }");
  assert(vars.toString == vars.toRule);

  vars.remove("gap");
  assert(!vars.has("gap"));
  assert(vars.toDeclarations == "--primary: #3498db;");

  auto fromMap = cssVariables(["dark": "#111", "light": "#eee"]);
  assert(fromMap.length == 2);
  assert(fromMap.has("dark"));
  assert(fromMap.has("light"));
  assert(fromMap.names == ["--dark", "--light"]);
  assert(fromMap.minify == ":root{--dark:#111;--light:#eee}");
}
