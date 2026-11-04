/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.semantic;

import uim.web;

mixin(ShowModule!());

@safe:

/// Header element (page or section header)
HtmlElement header(string content = null) {
  auto element = new HtmlElement("header");
  if (content.length > 0) {
    element.text(content);
  }
  return element;
}

/// Nav element (navigation links)
HtmlElement nav(string content = null) {
  auto element = new HtmlElement("nav");
  if (content.length > 0) {
    element.text(content);
  }
  return element;
}

/// Main element (dominant content of the document)
HtmlElement mainElement(string content = null) {
  auto element = new HtmlElement("main");
  if (content.length > 0) {
    element.text(content);
  }
  return element;
}

/// Section element (generic standalone section)
HtmlElement section(string content = null) {
  auto element = new HtmlElement("section");
  if (content.length > 0) {
    element.text(content);
  }
  return element;
}

/// Article element (self-contained composition)
HtmlElement article(string content = null) {
  auto element = new HtmlElement("article");
  if (content.length > 0) {
    element.text(content);
  }
  return element;
}

/// Aside element (content indirectly related to the main content)
HtmlElement aside(string content = null) {
  auto element = new HtmlElement("aside");
  if (content.length > 0) {
    element.text(content);
  }
  return element;
}

/// Footer element
HtmlElement footer(string content = null) {
  auto element = new HtmlElement("footer");
  if (content.length > 0) {
    element.text(content);
  }
  return element;
}

/// Figure element with optional figcaption
HtmlElement figure(string caption = null) {
  auto element = new HtmlElement("figure");
  if (caption.length > 0) {
    element.add("figcaption", caption);
  }
  return element;
}

/// Figcaption element
string figcaption(string content) {
  return htmlTag("figcaption", content);
}

/// Address element (contact information)
string address(string content) {
  return htmlTag("address", content);
}

/// Details element with a summary
HtmlElement details(string summary) {
  auto element = new HtmlElement("details");
  if (summary.length > 0) {
    element.add("summary", summary);
  }
  return element;
}

/// Summary element (visible heading of a details element)
string summary(string content) {
  return htmlTag("summary", content);
}

/// Dialog element (e.g. modal)
HtmlElement dialog(bool open = false) {
  auto element = new HtmlElement("dialog");
  if (open) {
    element.boolAttr("open");
  }
  return element;
}

/// Template element (inert content for scripting)
HtmlElement htmlTemplate(string id = null) {
  auto element = new HtmlElement("template");
  if (id.length > 0) {
    element.id(id);
  }
  return element;
}

///
unittest {
  assert(header("H").toString == "<header>H</header>");
  assert(header.toString == "<header></header>");
  assert(nav("N").toString == "<nav>N</nav>");
  assert(mainElement("M").toString == "<main>M</main>");
  assert(section("S").toString == "<section>S</section>");
  assert(article("A").toString == "<article>A</article>");
  assert(aside("A").toString == "<aside>A</aside>");
  assert(footer("F").toString == "<footer>F</footer>");

  auto fig = figure("Caption");
  assert(fig.toString == "<figure><figcaption>Caption</figcaption></figure>");
  assert(figure.toString == "<figure></figure>");
  assert(figcaption("Cap") == "<figcaption>Cap</figcaption>");

  assert(address("Street 1") == "<address>Street 1</address>");

  auto det = details("More");
  assert(det.toString == "<details><summary>More</summary></details>");
  assert(summary("Sum") == "<summary>Sum</summary>");

  assert(dialog(true).toString == "<dialog open></dialog>");
  assert(dialog.toString == "<dialog></dialog>");

  assert(htmlTemplate("tpl").toString == `<template id="tpl"></template>`);
  assert(htmlTemplate.toString == "<template></template>");

  // semantic elements compose with the generic API
  auto page = header().add(nav().raw(htmlTag("a", ["href": "/"], "Home")));
  assert(page.toString == `<header><nav><a href="/">Home</a></nav></header>`);
}
