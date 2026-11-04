/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.stylesheet;

import uim.web;

mixin(ShowModule!());

@safe:

/// A CSS stylesheet: imports, custom properties, then rules and blocks in the order they were added.
class CssStyleSheet : CssNode {
  /// Adds a rule, block or animation (fluent interface). The cascade follows this order.
  auto add(CssNode node) {
    _entries ~= node;
    return this;
  }

  /// Creates and adds a rule for a selector
  CssRule rule(string selector) {
    auto newRule = new CssRule(selector);
    add(newRule);
    return newRule;
  }

  /// Creates and adds a media block for a condition
  CssMedia media(string condition) {
    auto newMedia = new CssMedia(condition);
    add(newMedia);
    return newMedia;
  }

  /// Creates and adds a keyframes rule
  CssKeyframes keyframes(string name) {
    auto newKeyframes = new CssKeyframes(name);
    add(newKeyframes);
    return newKeyframes;
  }

  /// Adds an @import, which is always rendered first (fluent interface)
  auto importUrl(string url, string condition = null) {
    _imports ~= condition.length > 0
      ? "@import %s %s;".format(cssUrl(url), condition)
      : "@import %s;".format(cssUrl(url));
    return this;
  }

  /// Sets the custom properties (rendered as :root rule, fluent interface)
  auto variables(CssVariables variables) {
    _variables = variables;
    return this;
  }

  /// All rules of the stylesheet
  CssRule[] rules() {
    return entriesOf!CssRule;
  }

  /// All media blocks of the stylesheet
  CssMedia[] medias() {
    return entriesOf!CssMedia;
  }

  /// All keyframes of the stylesheet
  CssKeyframes[] animations() {
    return entriesOf!CssKeyframes;
  }

  /// Number of top-level entries (rules, blocks, keyframes)
  size_t length() const {
    return _entries.length;
  }

  /// Writes the stylesheet to a sink: one entry per line, or a single line when minified
  override void render(ref Appender!string sink, bool minified) const {
    bool isFirst = true;
    void separate() {
      if (!minified && !isFirst) {
        sink.put('\n');
      }
      isFirst = false;
    }

    foreach (importRule; _imports) {
      separate();
      sink.put(importRule);
    }
    if (_variables !is null && _variables.length > 0) {
      separate();
      _variables.render(sink, minified);
    }
    foreach (entry; _entries) {
      separate();
      entry.render(sink, minified);
    }
  }

  private T[] entriesOf(T)() {
    T[] result;
    foreach (entry; _entries) {
      if (auto found = cast(T)entry) {
        result ~= found;
      }
    }
    return result;
  }

  private string[] _imports;
  private CssVariables _variables;
  private CssNode[] _entries;
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
  assert(minified.canFind("body{margin:0;color:#333}.button{padding:1rem}"));
  assert(minified.canFind("@media (max-width:600px){.button{width:100%}}"));
  assert(minified.canFind(":root{--primary:#3498db}"));

  auto empty = cssStyleSheet();
  assert(empty.toString == "");
  assert(empty.minify == "");

  // minifying leaves strings alone
  auto strings = cssStyleSheet();
  strings.rule("a::before").set("content", `"x; y { z }"`);
  strings.rule(`a[title="b { c"]`).set("color", "red");
  assert(strings.minify == `a::before{content:"x; y { z }"}a[title="b { c"]{color:red}`);

  // the cascade follows insertion order
  auto cascade = cssStyleSheet();
  cascade.media("print").rule("a").set("color", "black");
  cascade.rule("a").set("color", "red");
  assert(cascade.toString == "@media print { a { color: black; } }\na { color: red; }");

  // imports come first, whenever they are added
  auto imports = cssStyleSheet();
  imports.rule("a").set("b", "1");
  imports.importUrl("reset.css").importUrl("print.css", "print");
  assert(imports.toString == `@import url("reset.css");` ~ "\n"
    ~ `@import url("print.css") print;` ~ "\na { b: 1; }");
  assert(imports.minify == `@import url("reset.css");@import url("print.css") print;a{b:1}`);

  // any node can be added
  assert(cssStyleSheet().add(cssSupports("(display: grid)")).length == 1);
  assert(cssStyleSheet().add(cssFontFace("Inter", cssUrl("inter.woff2"))).rules.length == 1);
}
