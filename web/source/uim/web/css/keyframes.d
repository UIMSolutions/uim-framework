/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.keyframes;

import uim.web;

mixin(ShowModule!());

@safe:

/// A CSS @keyframes rule describing an animation.
class CssKeyframes {
  this(string name) {
    _name = name;
  }

  /// The animation name
  string name() const {
    return _name;
  }

  /// Adds a step (e.g. "from", "to", "50%") with declarations (fluent interface)
  auto step(string offset, string[string] declarations) {
    auto rule = new CssRule(offset);
    foreach (property, value; declarations) {
      rule.set(property, value);
    }
    _steps ~= rule;
    return this;
  }

  /// Adds a step rule (fluent interface)
  auto step(CssRule rule) {
    _steps ~= rule;
    return this;
  }

  /// All steps of the animation
  CssRule[] steps() {
    return _steps.dup;
  }

  /// Renders the keyframes rule
  override string toString() const {
    string body = _steps.map!(step => step.toString).join(" ");
    return "@keyframes %s { %s }".format(_name, body);
  }

  private string _name;
  private CssRule[] _steps;
}

/// Creates a @keyframes rule, e.g. cssKeyframes("fadeIn")
CssKeyframes cssKeyframes(string name) {
  return new CssKeyframes(name);
}

/// Creates a simple from/to animation
CssKeyframes cssKeyframes(string name, string[string] from, string[string] to) {
  return new CssKeyframes(name)
    .step("from", from)
    .step("to", to);
}

///
unittest {
  auto fadeIn = new CssKeyframes("fadeIn");
  assert(fadeIn.name == "fadeIn");
  assert(fadeIn.steps.length == 0);

  fadeIn.step("from", ["opacity": "0"]).step("to", ["opacity": "1"]);
  assert(fadeIn.steps.length == 2);
  assert(fadeIn.toString == "@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }");

  auto pulse = cssKeyframes("pulse", ["transform": "scale(1)"], ["transform": "scale(1.1)"]);
  assert(pulse.toString == "@keyframes pulse { from { transform: scale(1); } to { transform: scale(1.1); } }");

  auto bounce = cssKeyframes("bounce")
    .step(cssRule("0%").set("top", "0"))
    .step(cssRule("50%").set("top", "100px"))
    .step(cssRule("100%").set("top", "0"));
  assert(bounce.steps.length == 3);
  assert(bounce.toString.canFind("50% { top: 100px; }"));
}
