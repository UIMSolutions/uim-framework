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
class HtmlDocument : HtmlNode {
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

  /// Adds several raw strings to the head, e.g. the result of openGraphTags (fluent interface)
  auto addHead(string[] contents) {
    _headEntries ~= contents;
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
    return addHead(scriptTag(code));
  }

  /// Adds an inline stylesheet to the head (fluent interface)
  auto inlineStyle(string css) {
    return addHead(styleTag(css));
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

  /// Adds a node to the body (fluent interface). It is rendered with the document, so it can still change.
  auto add(HtmlNode node) {
    _bodyEntries ~= node;
    return this;
  }

  /// Adds raw HTML to the body (fluent interface)
  auto raw(string html) {
    return add(new HtmlRaw(html));
  }

  /// Adds escaped text to the body (fluent interface)
  auto text(string content) {
    return add(new HtmlText(content));
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
    auto sink = appender!string;
    putBody(sink);
    return sink.data;
  }

  /// Writes the complete document to a sink
  override void render(ref Appender!string sink) const {
    sink.put(doctype);
    sink.put("\n<html");
    if (_lang.length > 0) {
      sink.put(' ');
      putHtmlAttr(sink, "lang", _lang);
    }
    sink.put(">\n");
    sink.put(renderHead);
    sink.put('\n');
    putBody(sink);
    sink.put("\n</html>");
  }

  private void putBody(ref Appender!string sink) const {
    sink.put("<body>\n  ");
    foreach (i, node; _bodyEntries) {
      if (i > 0) {
        sink.put("\n  ");
      }
      node.render(sink);
    }
    sink.put("\n</body>");
  }

  private string _title;
  private string _lang = "en";
  private string _charset = "utf-8";
  private bool _withViewport = true;
  private string[] _headEntries;
  private HtmlNode[] _bodyEntries;
}

/// Creates an HTML document builder
HtmlDocument htmlDocument(string title = null) {
  return new HtmlDocument(title);
}

/// Renders a minimal HTML5 page in one call
string htmlPage(string title, string bodyContent, string lang = "en") {
  return new HtmlDocument(title).lang(lang).raw(bodyContent).toString;
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

  // added elements stay live until the document is rendered
  auto content = mainElement();
  auto live = htmlDocument("T").add(content);
  content.text("added later");
  assert(live.renderBody.canFind("<main>added later</main>"));

  // any node can be added
  assert(htmlDocument("T").add(htmlTable()).toString.canFind("<table>"));

  // attribute values are escaped
  assert(htmlDocument.lang(`"><script>`).toString.canFind(`<html lang="&quot;&gt;&lt;script&gt;">`));

  // inline content cannot close its element
  auto inlined = htmlDocument.script("x = '</script>';").inlineStyle("a{content:'</style>'}").renderHead;
  assert(inlined.canFind(`<script>x = '<\/script>';</script>`));
  assert(inlined.canFind(`<style>a{content:'<\/style>'}</style>`));

  // tag lists
  assert(htmlDocument.addHead(openGraphTags("T", "website", "https://u")).renderHead.canFind("og:url"));
}
