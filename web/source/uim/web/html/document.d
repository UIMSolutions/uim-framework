/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.document;

import uim.web;

mixin(ShowModule!());

@safe:

/// HTML5 doctype declaration
string doctype() {
  return "<!DOCTYPE html>";
}

/// A complete HTML5 document with head and body.
class HtmlDocument {
  this(string title = null) {
    _title = title;
  }

  /// Sets the document title (fluent interface)
  auto title(string content) {
    _title = content;
    return this;
  }

  /// Sets the language of the html element (fluent interface)
  auto lang(string language) {
    _lang = language;
    return this;
  }

  /// Sets the charset (fluent interface, default "utf-8")
  auto charset(string charsetName) {
    _charset = charsetName;
    return this;
  }

  /// Adds a raw string to the head (fluent interface)
  auto addHead(string content) {
    _headEntries ~= content;
    return this;
  }

  /// Adds a meta tag with name/content to the head (fluent interface)
  auto meta(string name, string content) {
    return addHead(metaName(name, content));
  }

  /// Adds a stylesheet link to the head (fluent interface)
  auto stylesheet(string href) {
    return addHead(stylesheetLink(href));
  }

  /// Adds an external script to the head (fluent interface)
  auto scriptSrc(string src, bool defer = false) {
    auto element = new HtmlElement("script").attr("src", src);
    if (defer) {
      element.boolAttr("defer");
    }
    return addHead(element.toString);
  }

  /// Adds an inline script to the head (fluent interface)
  auto script(string code) {
    return addHead(rawScript(code));
  }

  /// Adds a favicon to the head (fluent interface)
  auto favicon(string href, string type = null) {
    return addHead(uim.web.html.meta.favicon(href, type));
  }

  /// Disables the default viewport meta tag (fluent interface)
  auto noViewport() {
    _withViewport = false;
    return this;
  }

  /// Adds an element to the body (fluent interface)
  auto add(HtmlElement element) {
    _bodyEntries ~= element.toString;
    return this;
  }

  /// Adds raw HTML to the body (fluent interface)
  auto raw(string html) {
    _bodyEntries ~= html;
    return this;
  }

  /// Adds escaped text to the body (fluent interface)
  auto text(string content) {
    _bodyEntries ~= escapeHtml(content);
    return this;
  }

  /// The document title
  string titleText() const {
    return _title;
  }

  /// Renders the head section
  string renderHead() const {
    string[] entries = [metaCharset(_charset)];
    if (_withViewport) {
      entries ~= metaViewport;
    }
    if (_title.length > 0) {
      entries ~= uim.web.html.meta.title(_title);
    }
    entries ~= _headEntries;
    return "<head>\n  %s\n</head>".format(entries.join("\n  "));
  }

  /// Renders the body section
  string renderBody() const {
    return "<body>\n  %s\n</body>".format(_bodyEntries.join("\n  "));
  }

  /// Renders the complete document
  override string toString() const {
    string htmlAttrs = _lang.length > 0 ? ` lang="%s"`.format(_lang) : "";
    return "%s\n<html%s>\n%s\n%s\n</html>".format(doctype, htmlAttrs, renderHead, renderBody);
  }

  private string _title;
  private string _lang = "en";
  private string _charset = "utf-8";
  private bool _withViewport = true;
  private string[] _headEntries;
  private string[] _bodyEntries;
}

/// Creates an HTML document builder
HtmlDocument htmlDocument(string title = null) {
  return new HtmlDocument(title);
}

/// Renders a minimal HTML5 page in one call
string htmlPage(string title, string bodyContent, string lang = "en") {
  return new HtmlDocument(title).lang(lang).raw(bodyContent).toString;
}

private string rawScript(string code) {
  return "<script>%s</script>".format(code);
}

///
unittest {
  assert(doctype == "<!DOCTYPE html>");

  auto doc = new HtmlDocument("My page");
  assert(doc.titleText == "My page");

  string rendered = doc.toString;
  assert(rendered.canFind("<!DOCTYPE html>"));
  assert(rendered.canFind(`<html lang="en">`));
  assert(rendered.canFind(`<meta charset="utf-8">`));
  assert(rendered.canFind(`<meta name="viewport" content="width=device-width, initial-scale=1.0">`));
  assert(rendered.canFind("<title>My page</title>"));

  // head entries
  doc.meta("description", "A test page")
    .stylesheet("style.css")
    .scriptSrc("app.js", true)
    .script("console.log('hi');")
    .favicon("favicon.ico");
  string head = doc.renderHead;
  assert(head.canFind(`<meta name="description" content="A test page">`));
  assert(head.canFind(`<link rel="stylesheet" href="style.css">`));
  assert(head.canFind(`<script src="app.js" defer></script>`));
  assert(head.canFind(`<script>console.log('hi');</script>`));
  assert(head.canFind(`<link rel="icon" href="favicon.ico">`));

  // body entries
  doc.raw("<h1>Hello</h1>").text("a < b").add(new HtmlElement("p", "para"));
  string body = doc.renderBody;
  assert(body.canFind("<h1>Hello</h1>"));
  assert(body.canFind("a &lt; b"));
  assert(body.canFind("<p>para</p>"));

  // options
  auto minimal = new HtmlDocument().lang("de").charset("iso-8859-1").noViewport;
  string minimalRendered = minimal.toString;
  assert(minimalRendered.canFind(`<html lang="de">`));
  assert(minimalRendered.canFind(`<meta charset="iso-8859-1">`));
  assert(!minimalRendered.canFind("viewport"));
  assert(!minimalRendered.canFind("<title>"));

  // one-call page
  string page = htmlPage("T", "<p>Hi</p>", "de");
  assert(page.canFind(`<html lang="de">`));
  assert(page.canFind("<title>T</title>"));
  assert(page.canFind("<p>Hi</p>"));

  assert(htmlDocument.toString.canFind("<!DOCTYPE html>"));
}
