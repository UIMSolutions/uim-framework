/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.stylesheet;

import uim.web;

mixin(ShowModule!());

@safe:

/// A CSS stylesheet collecting rules, media blocks, keyframes and custom properties.
class CssStyleSheet {
  /// Adds a rule (fluent interface)
  auto add(CssRule rule) {
    _rules ~= rule;
    return this;
  }

  /// Creates and adds a rule for a selector
  CssRule rule(string selector) {
    auto newRule = new CssRule(selector);
    add(newRule);
    return newRule;
  }

  /// Adds a media block (fluent interface)
  auto add(CssMedia media) {
    _medias ~= media;
    return this;
  }

  /// Creates and adds a media block for a condition
  CssMedia media(string condition) {
    auto newMedia = new CssMedia(condition);
    add(newMedia);
    return newMedia;
  }

  /// Adds a keyframes rule (fluent interface)
  auto add(CssKeyframes keyframes) {
    _keyframes ~= keyframes;
    return this;
  }

  /// Creates and adds a keyframes rule
  CssKeyframes keyframes(string name) {
    auto newKeyframes = new CssKeyframes(name);
    add(newKeyframes);
    return newKeyframes;
  }

  /// Sets the custom properties (rendered as :root rule, fluent interface)
  auto variables(CssVariables variables) {
    _variables = variables;
    return this;
  }

  /// All rules of the stylesheet
  CssRule[] rules() {
    return _rules.dup;
  }

  /// All media blocks of the stylesheet
  CssMedia[] medias() {
    return _medias.dup;
  }

  /// All keyframes of the stylesheet
  CssKeyframes[] animations() {
    return _keyframes.dup;
  }

  /// Number of top-level entries (rules, media blocks, keyframes)
  size_t length() const {
    return _rules.length + _medias.length + _keyframes.length;
  }

  /// Renders the complete stylesheet
  override string toString() const {
    string[] parts;
    if (_variables !is null && _variables.length > 0) {
      parts ~= _variables.toRule;
    }
    parts ~= _rules.map!(rule => rule.toString).array;
    parts ~= _keyframes.map!(keyframes => keyframes.toString).array;
    parts ~= _medias.map!(media => media.toString).array;
    return parts.join("\n");
  }

  /// Renders the stylesheet minified (single line, no unnecessary whitespace)
  string minify() const {
    return toString
      .replace("\n", " ")
      .replace(" { ", "{")
      .replace("; }", "}")
      .replace("; ", ";");
  }

  private CssRule[] _rules;
  private CssMedia[] _medias;
  private CssKeyframes[] _keyframes;
  private CssVariables _variables;
}

/// Creates an empty stylesheet
CssStyleSheet cssStyleSheet() {
  return new CssStyleSheet;
}

///
unittest {
  auto sheet = new CssStyleSheet;
  assert(sheet.length == 0);

  sheet.rule("body").set("margin", "0").set("color", "#333");
  sheet.rule(".button").set("padding", "1rem");
  assert(sheet.rules.length == 2);
  assert(sheet.length == 2);

  sheet.keyframes("fadeIn").step("from", ["opacity": "0"]).step("to", ["opacity": "1"]);
  assert(sheet.animations.length == 1);

  sheet.media("(max-width: 600px)").rule(".button").set("width", "100%");
  assert(sheet.medias.length == 1);
  assert(sheet.length == 4);

  sheet.variables(cssVariables(["primary": "#3498db"]));

  string rendered = sheet.toString;
  assert(rendered.canFind(":root { --primary: #3498db; }"));
  assert(rendered.canFind("body { margin: 0; color: #333; }"));
  assert(rendered.canFind(".button { padding: 1rem; }"));
  assert(rendered.canFind("@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }"));
  assert(rendered.canFind("@media (max-width: 600px) { .button { width: 100%; } }"));

  string minified = sheet.minify;
  assert(!minified.canFind("\n"));
  assert(minified.canFind("body{margin: 0;color: #333}"));

  auto empty = cssStyleSheet();
  assert(empty.toString == "");
  assert(empty.minify == "");
}
