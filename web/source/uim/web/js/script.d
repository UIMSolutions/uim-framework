/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.js.script;

import uim.web;

mixin(ShowModule!());

@safe:

/// Inline script element, e.g. scriptTag("alert('hi');") -> "<script>alert('hi');</script>"
string scriptTag(string code, string nonce = null) {
  auto element = new HtmlElement("script").raw(escapeRawText(code, "script"));
  if (nonce.length > 0) {
    element.attr("nonce", nonce);
  }
  return element.toString;
}

/// External script element, e.g. scriptSrc("app.js") -> `<script src="app.js"></script>`
string scriptSrc(string src, bool defer = false, bool async = false) {
  auto element = new HtmlElement("script").attr("src", src);
  if (defer) {
    element.boolAttr("defer");
  }
  if (async) {
    element.boolAttr("async");
  }
  return element.toString;
}

/// Module script element, e.g. scriptModule("app.js") -> `<script type="module" src="app.js"></script>`
string scriptModule(string src) {
  return new HtmlElement("script").attr("type", "module").attr("src", src).toString;
}

/// Noscript fallback element
string noscript(string content) {
  return htmlTag("noscript", content);
}

/// Event handler attribute, e.g. onEvent("click", "save()") -> `onclick="save()"`
string onEvent(string event, string code) {
  return htmlAttr("on" ~ event, code);
}

/// onclick attribute
string onClick(string code) {
  return onEvent("click", code);
}

/// onchange attribute
string onChange(string code) {
  return onEvent("change", code);
}

/// onsubmit attribute
string onSubmit(string code) {
  return onEvent("submit", code);
}

/// onload attribute
string onLoad(string code) {
  return onEvent("load", code);
}

/// oninput attribute
string onInput(string code) {
  return onEvent("input", code);
}

/// onkeydown attribute
string onKeyDown(string code) {
  return onEvent("keydown", code);
}

/// onmouseover attribute
string onMouseOver(string code) {
  return onEvent("mouseover", code);
}

/// onmouseout attribute
string onMouseOut(string code) {
  return onEvent("mouseout", code);
}

/// DOMContentLoaded wrapper, e.g. onDomReady("init();")
string onDomReady(string code) {
  return "document.addEventListener('DOMContentLoaded', %s);".format(jsArrowBlock([], code));
}

/// window.onload wrapper
string onWindowLoad(string code) {
  return "window.onload = %s;".format(jsArrowBlock([], code));
}

///
unittest {
  // script elements
  assert(scriptTag("alert('hi');") == "<script>alert('hi');</script>");
  assert(scriptSrc("app.js") == `<script src="app.js"></script>`);
  assert(scriptSrc("app.js", true) == `<script src="app.js" defer></script>`);
  assert(scriptSrc("app.js", false, true) == `<script src="app.js" async></script>`);
  assert(scriptModule("app.js") == `<script type="module" src="app.js"></script>`);
  assert(noscript("No JS") == "<noscript>No JS</noscript>");

  // inline code cannot close its element
  assert(scriptTag("a = '</script><b>';") == `<script>a = '<\/script><b>';</script>`);
  assert(scriptTag("a();", "abc") == `<script nonce="abc">a();</script>`);

  // event handler attributes
  assert(onEvent("click", "save()") == `onclick="save()"`);
  assert(onClick("save()") == `onclick="save()"`);
  assert(onChange("update()") == `onchange="update()"`);
  assert(onSubmit("return check()") == `onsubmit="return check()"`);
  assert(onLoad("init()") == `onload="init()"`);
  assert(onInput("validate()") == `oninput="validate()"`);
  assert(onKeyDown("keys(event)") == `onkeydown="keys(event)"`);
  assert(onMouseOver("over()") == `onmouseover="over()"`);
  assert(onMouseOut("out()") == `onmouseout="out()"`);

  // single quotes stay as-is inside double-quoted attributes
  assert(onClick("alert('hi')") == `onclick="alert('hi')"`);

  // lifecycle wrappers
  assert(onDomReady("init();") == "document.addEventListener('DOMContentLoaded', () => { init(); });");
  assert(onWindowLoad("init();") == "window.onload = () => { init(); };");
}
