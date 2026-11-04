/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.attributes;

import uim.web;

mixin(ShowModule!());

@safe:

/// Renders an attribute, e.g. htmlAttr("id", "main") -> `id="main"`
string htmlAttr(string name, string value) {
  return `%s="%s"`.format(name, escapeHtmlAttribute(value));
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
  return value
    .replace("&", "&amp;")
    .replace("<", "&lt;")
    .replace(">", "&gt;")
    .replace(`"`, "&quot;");
}

/// Renders a class attribute from multiple class names, e.g. classAttr("btn", "active") -> `class="btn active"`
string classAttr(string[] classNames...) {
  return htmlAttr("class", classNames.join(" "));
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
  string style = declarations.keys.sort
    .map!(property => "%s: %s;".format(property, declarations[property]))
    .join(" ");
  return htmlAttr("style", style);
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
}
