/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.meta;

import uim.web;

mixin(ShowModule!());

@safe:

/// Meta charset declaration, e.g. metaCharset() -> `<meta charset="utf-8">`
string metaCharset(string charset = "utf-8") {
  return new HtmlElement("meta").attr("charset", charset).toString;
}

/// Standard responsive viewport meta tag
string metaViewport(string content = "width=device-width, initial-scale=1.0") {
  return new HtmlElement("meta").attr("name", "viewport").attr("content", content).toString;
}

/// Meta tag with name/content pair, e.g. metaName("description", "My page")
string metaName(string name, string content) {
  return new HtmlElement("meta").attr("name", name).attr("content", content).toString;
}

/// Page description meta tag
string metaDescription(string description) {
  return metaName("description", description);
}

/// Keywords meta tag
string metaKeywords(string[] keywords...) {
  return metaName("keywords", keywords.join(", "));
}

/// Author meta tag
string metaAuthor(string author) {
  return metaName("author", author);
}

/// Robots meta tag, e.g. metaRobots("noindex, nofollow")
string metaRobots(string directives = "index, follow") {
  return metaName("robots", directives);
}

/// Meta tag with http-equiv, e.g. metaHttpEquiv("refresh", "5")
string metaHttpEquiv(string equiv, string content) {
  return new HtmlElement("meta").attr("http-equiv", equiv).attr("content", content).toString;
}

/// Client-side redirect after a number of seconds
string metaRefresh(int seconds, string url = null) {
  string content = url.length > 0
    ? "%s; url=%s".format(seconds, url)
    : seconds.to!string;
  return metaHttpEquiv("refresh", content);
}

/// Open Graph meta tag, e.g. openGraph("title", "My page") -> `<meta property="og:title" content="My page">`
string openGraph(string property, string content) {
  return new HtmlElement("meta").attr("property", "og:" ~ property).attr("content", content).toString;
}

/// Standard set of Open Graph tags
string[] openGraphTags(string title, string type, string url, string image = null) {
  string[] tags = [
    openGraph("title", title),
    openGraph("type", type),
    openGraph("url", url)
  ];
  if (image.length > 0) {
    tags ~= openGraph("image", image);
  }
  return tags;
}

/// Twitter Card meta tag, e.g. twitterCard("title", "My page") -> `<meta name="twitter:title" content="My page">`
string twitterCard(string name, string content) {
  return metaName("twitter:" ~ name, content);
}

/// Standard set of Twitter Card tags
string[] twitterCardTags(string card, string title, string description = null) {
  string[] tags = [
    twitterCard("card", card),
    twitterCard("title", title)
  ];
  if (description.length > 0) {
    tags ~= twitterCard("description", description);
  }
  return tags;
}

/// Title element, e.g. title("My page") -> "<title>My page</title>"
string title(string content) {
  return htmlTag("title", content);
}

/// Stylesheet link, e.g. stylesheetLink("style.css") -> `<link rel="stylesheet" href="style.css">`
string stylesheetLink(string href) {
  return new HtmlElement("link").attr("rel", "stylesheet").attr("href", href).toString;
}

/// Favicon link, e.g. favicon("favicon.ico")
string favicon(string href, string type = null) {
  auto element = new HtmlElement("link").attr("rel", "icon").attr("href", href);
  if (type.length > 0) {
    element.attr("type", type);
  }
  return element.toString;
}

/// Canonical link, e.g. canonical("https://example.com/page")
string canonical(string href) {
  return new HtmlElement("link").attr("rel", "canonical").attr("href", href).toString;
}

/// Preconnect hint, e.g. preconnect("https://fonts.example.com")
string preconnect(string href) {
  return new HtmlElement("link").attr("rel", "preconnect").attr("href", href).toString;
}

/// Base element, e.g. baseTag("https://example.com/")
string baseTag(string href, string target = null) {
  auto element = new HtmlElement("base").attr("href", href);
  if (target.length > 0) {
    element.attr("target", target);
  }
  return element.toString;
}

///
unittest {
  assert(metaCharset == `<meta charset="utf-8">`);
  assert(metaCharset("iso-8859-1") == `<meta charset="iso-8859-1">`);
  assert(metaViewport == `<meta name="viewport" content="width=device-width, initial-scale=1.0">`);

  assert(metaName("generator", "uim") == `<meta name="generator" content="uim">`);
  assert(metaDescription("My page") == `<meta name="description" content="My page">`);
  assert(metaKeywords("d", "web") == `<meta name="keywords" content="d, web">`);
  assert(metaAuthor("ONS") == `<meta name="author" content="ONS">`);
  assert(metaRobots == `<meta name="robots" content="index, follow">`);
  assert(metaRobots("noindex") == `<meta name="robots" content="noindex">`);

  assert(metaHttpEquiv("refresh", "5") == `<meta http-equiv="refresh" content="5">`);
  assert(metaRefresh(5) == `<meta http-equiv="refresh" content="5">`);
  assert(metaRefresh(5, "https://example.com") == `<meta http-equiv="refresh" content="5; url=https://example.com">`);

  assert(openGraph("title", "My page") == `<meta property="og:title" content="My page">`);
  auto og = openGraphTags("My page", "website", "https://example.com", "https://example.com/og.png");
  assert(og.length == 4);
  assert(og[0] == `<meta property="og:title" content="My page">`);
  assert(og[3] == `<meta property="og:image" content="https://example.com/og.png">`);
  assert(openGraphTags("T", "website", "https://u").length == 3);

  assert(twitterCard("card", "summary") == `<meta name="twitter:card" content="summary">`);
  auto tw = twitterCardTags("summary", "My page", "Desc");
  assert(tw.length == 3);
  assert(tw[2] == `<meta name="twitter:description" content="Desc">`);
  assert(twitterCardTags("summary", "T").length == 2);

  assert(title("My page") == "<title>My page</title>");
  assert(stylesheetLink("style.css") == `<link rel="stylesheet" href="style.css">`);
  assert(favicon("favicon.ico") == `<link rel="icon" href="favicon.ico">`);
  assert(favicon("icon.svg", "image/svg+xml") == `<link rel="icon" href="icon.svg" type="image/svg+xml">`);
  assert(canonical("https://example.com/page") == `<link rel="canonical" href="https://example.com/page">`);
  assert(preconnect("https://fonts.example.com") == `<link rel="preconnect" href="https://fonts.example.com">`);
  assert(baseTag("https://example.com/") == `<base href="https://example.com/">`);
  assert(baseTag("https://example.com/", "_blank") == `<base href="https://example.com/" target="_blank">`);

  // content is escaped
  assert(metaDescription(`a "b"`) == `<meta name="description" content="a &quot;b&quot;">`);
}
