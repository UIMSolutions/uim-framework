/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.media;

import uim.web;

mixin(ShowModule!());

@safe:

/// A CSS @media block containing rules for a media condition.
class CssMedia {
  this(string condition) {
    _condition = condition;
  }

  /// The media condition, e.g. "(max-width: 600px)"
  string condition() const {
    return _condition;
  }

  /// Adds a rule to the media block (fluent interface)
  auto add(CssRule rule) {
    _rules ~= rule;
    return this;
  }

  /// Creates and adds a rule for a selector (fluent interface)
  auto rule(string selector) {
    auto newRule = new CssRule(selector);
    add(newRule);
    return newRule;
  }

  /// All rules of the media block
  CssRule[] rules() {
    return _rules.dup;
  }

  /// Renders the media block
  override string toString() const {
    string body = _rules.map!(rule => rule.toString).join(" ");
    return "@media %s { %s }".format(_condition, body);
  }

  private string _condition;
  private CssRule[] _rules;
}

/// Creates a @media block, e.g. cssMedia("(max-width: 600px)")
CssMedia cssMedia(string condition) {
  return new CssMedia(condition);
}

/// Media condition for viewports up to a maximum width, e.g. maxWidth(px(600)) -> "(max-width: 600px)"
string maxWidth(string width) {
  return "(max-width: %s)".format(width);
}

/// Media condition for viewports from a minimum width
string minWidth(string width) {
  return "(min-width: %s)".format(width);
}

/// Media condition for viewports up to a maximum height
string maxHeight(string height) {
  return "(max-height: %s)".format(height);
}

/// Media condition for viewports from a minimum height
string minHeight(string height) {
  return "(min-height: %s)".format(height);
}

/// Combines media conditions with "and"
string mediaAnd(string[] conditions...) {
  return conditions.join(" and ");
}

/// Combines media conditions with "or" (comma)
string mediaOr(string[] conditions...) {
  return conditions.join(", ");
}

/// Media condition for a specific orientation ("portrait" or "landscape")
string orientation(string value) {
  return "(orientation: %s)".format(value);
}

/// Media condition for dark color scheme preference
string prefersDark() {
  return "(prefers-color-scheme: dark)";
}

/// Media condition for light color scheme preference
string prefersLight() {
  return "(prefers-color-scheme: light)";
}

/// Media condition for reduced motion preference
string prefersReducedMotion() {
  return "(prefers-reduced-motion: reduce)";
}

/// Media condition for print output
string printMedia() {
  return "print";
}

/// Media condition for screen output
string screenMedia() {
  return "screen";
}

///
unittest {
  auto media = new CssMedia("(max-width: 600px)");
  assert(media.condition == "(max-width: 600px)");
  assert(media.rules.length == 0);

  media.rule(".sidebar").set("display", "none");
  assert(media.rules.length == 1);
  assert(media.toString == "@media (max-width: 600px) { .sidebar { display: none; } }");

  media.add(cssRule(".content").set("width", "100%"));
  assert(media.rules.length == 2);
  assert(media.toString.canFind(".content { width: 100%; }"));

  assert(maxWidth(px(600)) == "(max-width: 600px)");
  assert(minWidth(px(1024)) == "(min-width: 1024px)");
  assert(maxHeight(vh(80)) == "(max-height: 80vh)");
  assert(minHeight(vh(50)) == "(min-height: 50vh)");
  assert(mediaAnd("screen", minWidth(px(768))) == "screen and (min-width: 768px)");
  assert(mediaOr(maxWidth(px(600)), orientation("landscape")) == "(max-width: 600px), (orientation: landscape)");
  assert(orientation("portrait") == "(orientation: portrait)");
  assert(prefersDark == "(prefers-color-scheme: dark)");
  assert(prefersLight == "(prefers-color-scheme: light)");
  assert(prefersReducedMotion == "(prefers-reduced-motion: reduce)");
  assert(printMedia == "print");
  assert(screenMedia == "screen");
}
