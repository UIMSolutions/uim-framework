/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.media;

import uim.web;

mixin(ShowModule!());

@safe:

/// Anchor element, e.g. a("https://example.com", "Example") -> `<a href="https://example.com">Example</a>`
string a(string href, string content, string[string] attributes = null) {
  auto element = new HtmlElement("a").attrs(attributes).attr("href", href).text(content);
  return element.toString;
}

/// Anchor element opening in a new tab (target="_blank" with rel="noopener")
string aBlank(string href, string content) {
  return a(href, content, ["target": "_blank", "rel": "noopener"]);
}

/// Mailto link, e.g. mailto("a@b.c") -> `<a href="mailto:a@b.c">a@b.c</a>`
string mailto(string address, string content = null) {
  return a("mailto:" ~ address, content.length > 0 ? content : address);
}

/// Tel link, e.g. tel("+49123") -> `<a href="tel:+49123">+49123</a>`
string tel(string number, string content = null) {
  return a("tel:" ~ number, content.length > 0 ? content : number);
}

/// Image element, e.g. img("logo.png", "Logo") -> `<img src="logo.png" alt="Logo">`
string img(string src, string alt = null, string[string] attributes = null) {
  auto element = new HtmlElement("img").attrs(attributes).attr("src", src);
  element.attr("alt", alt);
  return element.toString;
}

/// Image element with dimensions
string img(string src, string alt, int width, int height) {
  return new HtmlElement("img")
    .attr("src", src)
    .attr("alt", alt)
    .attr("width", width.to!string)
    .attr("height", height.to!string)
    .toString;
}

/// Figure with image and caption
string figureImg(string src, string alt, string caption) {
  auto element = new HtmlElement("figure");
  element.raw(img(src, alt));
  if (caption.length > 0) {
    element.add("figcaption", caption);
  }
  return element.toString;
}

/// Video element with sources, e.g. video(["movie.mp4"])
string video(string[] sources, int width = 0, int height = 0, bool controls = true) {
  auto element = new HtmlElement("video");
  if (controls) {
    element.boolAttr("controls");
  }
  if (width > 0) {
    element.attr("width", width.to!string);
  }
  if (height > 0) {
    element.attr("height", height.to!string);
  }
  foreach (src; sources) {
    element.raw(new HtmlElement("source").attr("src", src).toString);
  }
  return element.toString;
}

/// Audio element with sources
string audio(string[] sources, bool controls = true) {
  auto element = new HtmlElement("audio");
  if (controls) {
    element.boolAttr("controls");
  }
  foreach (src; sources) {
    element.raw(new HtmlElement("source").attr("src", src).toString);
  }
  return element.toString;
}

/// Iframe element, e.g. iframe("https://example.com", 600, 400)
string iframe(string src, int width = 0, int height = 0, string[string] attributes = null) {
  auto element = new HtmlElement("iframe").attrs(attributes).attr("src", src);
  if (width > 0) {
    element.attr("width", width.to!string);
  }
  if (height > 0) {
    element.attr("height", height.to!string);
  }
  return element.toString;
}

/// Embed element
string embed(string src, string type = null) {
  auto element = new HtmlElement("embed").attr("src", src);
  if (type.length > 0) {
    element.attr("type", type);
  }
  return element.toString;
}

/// Picture element with responsive sources and a fallback image
string picture(string[] sources, string fallbackSrc, string alt = null) {
  auto element = new HtmlElement("picture");
  foreach (src; sources) {
    element.raw(new HtmlElement("source").attr("srcset", src).toString);
  }
  element.raw(img(fallbackSrc, alt));
  return element.toString;
}

///
unittest {
  // links
  assert(a("https://example.com", "Example") == `<a href="https://example.com">Example</a>`);
  assert(a("/x", "X", ["class": "link"]) == `<a class="link" href="/x">X</a>`);
  assert(aBlank("https://example.com", "Ex") == `<a target="_blank" rel="noopener" href="https://example.com">Ex</a>`);
  assert(mailto("a@b.c") == `<a href="mailto:a@b.c">a@b.c</a>`);
  assert(mailto("a@b.c", "Mail") == `<a href="mailto:a@b.c">Mail</a>`);
  assert(tel("+49123") == `<a href="tel:+49123">+49123</a>`);

  // images
  assert(img("logo.png") == `<img src="logo.png" alt="">`);
  assert(img("logo.png", "Logo") == `<img src="logo.png" alt="Logo">`);
  assert(img("logo.png", "Logo", 100, 50) == `<img src="logo.png" alt="Logo" width="100" height="50">`);
  assert(img("a.png", "A", ["loading": "lazy"]) == `<img loading="lazy" src="a.png" alt="A">`);

  // figure with image
  assert(figureImg("a.png", "A", "Cap") == `<figure><img src="a.png" alt="A"><figcaption>Cap</figcaption></figure>`);
  assert(figureImg("a.png", "A", null) == `<figure><img src="a.png" alt="A"></figure>`);

  // video and audio
  assert(video(["movie.mp4"]) == `<video controls><source src="movie.mp4"></video>`);
  assert(video(["a.mp4", "a.webm"], 640, 360) == `<video controls width="640" height="360"><source src="a.mp4"><source src="a.webm"></video>`);
  assert(video(["a.mp4"], 0, 0, false) == `<video><source src="a.mp4"></video>`);
  assert(audio(["song.mp3"]) == `<audio controls><source src="song.mp3"></audio>`);
  assert(audio(["a.ogg", "a.mp3"], false) == `<audio><source src="a.ogg"><source src="a.mp3"></audio>`);

  // iframe and embed
  assert(iframe("https://example.com") == `<iframe src="https://example.com"></iframe>`);
  assert(iframe("https://example.com", 600, 400) == `<iframe src="https://example.com" width="600" height="400"></iframe>`);
  assert(embed("file.pdf", "application/pdf") == `<embed src="file.pdf" type="application/pdf">`);

  // picture
  assert(picture(["a.avif", "a.webp"], "a.png", "A")
    == `<picture><source srcset="a.avif"><source srcset="a.webp"><img src="a.png" alt="A"></picture>`);
}
