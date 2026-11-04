/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.attributes;

import std.exception : assertThrown, enforce;
import std.uni : sicmp;

import uim.web;

mixin(ShowModule!());

@safe:

/// Checks whether a string is usable as an HTML tag or attribute name
bool isHtmlName(string name) {
  if (name.length == 0) {
    return false;
  }
  foreach (char c; name) {
    if (c <= ' ' || c == 0x7F || c == '"' || c == '\'' || c == '<' || c == '>' || c == '/' || c == '=') {
      return false;
    }
  }
  return true;
}

/// Returns a tag or attribute name, throws if it would break out of the markup
string checkHtmlName(string name) {
  enforce(isHtmlName(name), "Invalid HTML name: " ~ name);
  return name;
}

/// Writes text content to a sink, escaped for use between HTML tags
void putHtmlText(ref Appender!string sink, string value) {
  putEscaped!true(sink, value);
}

/// Writes an attribute to a sink, e.g. `id="main"`. The name is not validated here.
void putHtmlAttr(ref Appender!string sink, string name, string value) {
  sink.put(name);
  sink.put(`="`);
  putEscaped!false(sink, value);
  sink.put('"');
}

/// The entity for a character, null if the character needs no escaping
private string htmlEntity(bool withApostrophe)(char c) {
  switch (c) {
    case '&': return "&amp;";
    case '<': return "&lt;";
    case '>': return "&gt;";
    case '"': return "&quot;";
    case '\'': return withApostrophe ? "&#39;" : null;
    default: return null;
  }
}

// Single pass over the bytes: every special character is ASCII, so UTF-8 sequences pass through untouched
private void putEscaped(bool withApostrophe)(ref Appender!string sink, string value) {
  size_t start;
  foreach (i, char c; value) {
    if (auto entity = htmlEntity!withApostrophe(c)) {
      sink.put(value[start .. i]);
      sink.put(entity);
      start = i + 1;
    }
  }
  sink.put(value[start .. $]);
}

/// Renders an attribute, e.g. htmlAttr("id", "main") -> `id="main"`
string htmlAttr(string name, string value) {
  auto sink = appender!string;
  putHtmlAttr(sink, checkHtmlName(name), value);
  return sink.data;
}

/// Renders a boolean attribute without value, e.g. htmlBoolAttr("disabled") -> "disabled"
string htmlBoolAttr(string name) {
  return name;
}

/// Renders all attributes of an associative array, e.g. htmlAttrs(["id": "a", "class": "b"])
string htmlAttrs(string[string] attributes) {
  return attributes.keys.sort.map!(name => htmlAttr(name, attributes[name])).join(" ");
}

/// Escapes a value for use inside a double-quoted HTML attribute
string escapeHtmlAttribute(string value) {
  if (!value.any!(c => c == '&' || c == '<' || c == '>' || c == '"')) {
    return value;
  }
  auto sink = appender!string;
  putEscaped!false(sink, value);
  return sink.data;
}

/**
 * Neutralizes sequences that would end a raw text element (script, style) early.
 *
 * Raw text cannot be entity-escaped. Inside JavaScript and CSS strings `\/` and `\!`
 * mean the same as `/` and `!`, so the content keeps its meaning.
 */
string escapeRawText(string content, string tag) {
  if (!content.canFind('<')) {
    return content;
  }
  auto sink = appender!string;
  size_t start;
  foreach (i, char c; content) {
    if (c != '<') {
      continue;
    }
    string rest = content[i + 1 .. $];
    bool closesElement = rest.length > tag.length && rest[0] == '/'
      && sicmp(rest[1 .. 1 + tag.length], tag) == 0;
    if (closesElement || rest.startsWith("!--")) {
      sink.put(content[start .. i + 1]);
      sink.put('\\');
      start = i + 1;
    }
  }
  sink.put(content[start .. $]);
  return sink.data;
}

/// Renders a class attribute from multiple class names, e.g. classAttr("btn", "active") -> `class="btn active"`
string classAttr(string[] classNames...) {
  return htmlAttr("class", mergeClasses(classNames));
}

/// Merges class names into a single space-separated string, skipping empty entries
string mergeClasses(string[] classNames...) {
  return classNames.filter!(name => name.length > 0).join(" ");
}

/// Renders a data-* attribute, e.g. dataAttr("toggle", "modal") -> `data-toggle="modal"`
string dataAttr(string name, string value) {
  return htmlAttr("data-" ~ name, value);
}

/// Renders an aria-* attribute, e.g. ariaAttr("label", "Close") -> `aria-label="Close"`
string ariaAttr(string name, string value) {
  return htmlAttr("aria-" ~ name, value);
}

/// Renders a style attribute from declarations, e.g. styleAttr(["color": "red"]) -> `style="color: red;"`
string styleAttr(string[string] declarations) {
  return htmlAttr("style", styleValue(declarations));
}

/// Renders declarations as a style attribute value, sorted by property for stable output
string styleValue(string[string] declarations) {
  return declarations.keys.sort
    .map!(property => "%s: %s;".format(property, declarations[property]))
    .join(" ");
}

/// Renders an id attribute, e.g. idAttr("main") -> `id="main"`
string idAttr(string id) {
  return htmlAttr("id", id);
}

///
unittest {
  assert(htmlAttr("id", "main") == `id="main"`);
  assert(htmlAttr("title", `a "b"`) == `title="a &quot;b&quot;"`);
  assert(htmlBoolAttr("disabled") == "disabled");
  assert(htmlAttrs(["id": "a", "class": "b"]) == `class="b" id="a"`);

  assert(escapeHtmlAttribute(`<a href="x">&`) == "&lt;a href=&quot;x&quot;&gt;&amp;");

  assert(classAttr("btn", "active") == `class="btn active"`);
  assert(mergeClasses("a", "", "b") == "a b");
  assert(dataAttr("toggle", "modal") == `data-toggle="modal"`);
  assert(ariaAttr("label", "Close") == `aria-label="Close"`);
  assert(styleAttr(["color": "red", "margin": "0"]) == `style="color: red; margin: 0;"`);
  assert(idAttr("main") == `id="main"`);
  assert(classAttr("a", "") == `class="a"`);

  // clean values are returned without copying
  string clean = "nothing to escape";
  assert(escapeHtmlAttribute(clean) is clean);
  assert(escapeHtmlAttribute("ü & ö") == "ü &amp; ö");

  // names cannot break out of the markup
  assert(isHtmlName("data-x"));
  assert(isHtmlName("xlink:href"));
  assert(!isHtmlName(""));
  assert(!isHtmlName("x onload=alert(1)"));
  assert(!isHtmlName(`a"b`));
  assert(!isHtmlName("a>b"));
  assertThrown(htmlAttr("a b", "c"));

  // raw text elements
  assert(escapeRawText("no markup", "script") == "no markup");
  assert(escapeRawText("a < b", "script") == "a < b");
  assert(escapeRawText("'</script>'", "script") == `'<\/script>'`);
  assert(escapeRawText("'</SCRIPT >'", "script") == `'<\/SCRIPT >'`);
  assert(escapeRawText("<!-- x", "script") == `<\!-- x`);
  assert(escapeRawText("</style>", "script") == "</style>");
  assert(escapeRawText("a</style>b</style>", "style") == `a<\/style>b<\/style>`);
}
