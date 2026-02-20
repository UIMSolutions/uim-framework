/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.link;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML base element
class H5Link : HtmlElement {
  mixin H5This!("link", true);

  H5Link as(string value) {
    attribute("as", value);
    return this;
  }

  string as() {
    return attribute("as").value;
  }

  H5Link blocking(string value) {
    attribute("blocking", value);
    return this;
  }

  string blocking() {
    return attribute("blocking").value;
  }

  // Valid values for crossorigin attribute
  // anonymous, use-credentials
  H5Link crossorigin(string value) {
    attribute("crossorigin", value);
    return this;
  }

  string crossorigin() {
    return attribute("crossorigin").value;
  }

  H5Link disabled() {
    attribute("disabled", "");
    return this;
  }

  // Valid values for fetchpriority attribute
  // high, low, auto
  H5Link fetchpriority(string value) {
    attribute("fetchpriority", value);
    return this;
  }

  string fetchpriority() {
    return attribute("fetchpriority").value;
  }

  H5Link href(string value) {
    attribute("href", value);
    return this;
  }

  string href() {
    return attribute("href").value;
  }

  H5Link hreflang(string value) {
    attribute("hreflang", value);
    return this;
  }

  string hreflang() {
    return attribute("hreflang").value;
  }

  H5Link imagesizes(string value) {
    attribute("imagesizes", value);
    return this;
  }

  string imagesizes() {
    return attribute("imagesizes").value;
  }

  H5Link imagesrcset(string value) {
    attribute("imagesrcset", value);
    return this;
  }

  string imagesrcset() {
    return attribute("imagesrcset").value;
  }

  H5Link integrity(string value) {
    attribute("integrity", value);
    return this;
  }

  string integrity() {
    return attribute("integrity").value;
  }

  H5Link media(string value) {
    attribute("media", value);
    return this;
  }

  string media() {
    return attribute("media").value;
  }

  // Valid values for rel attribute
  // alternate, author, bookmark, external, help, icon, license, next, nofollow, noreferrer,
  // preconnect, prefetch, preload, prerender, prev, search
  H5Link referrerpolicy(string value) {
    attribute("referrerpolicy", value);
    return this;
  }

  string rel() {
    return attribute("rel").value;
  }

  H5Link rel(string value) {
    attribute("rel", value);
    return this;
  }

  H5Link sizes(string value) {
    attribute("sizes", value);
    return this;
  }

  string sizes() {
    return attribute("sizes").value;
  }

  H5Link title(string value) {
    attribute("title", value);
    return this;
  }

  string title() {
    return attribute("title").value;
  }

  // #region type
  H5Link type(string value) {
    attribute("type", value);
    return this;
  }

  string type() {
    return attribute("type").value;
  }
  // #endregion type

  // Create a new Base element
  mixin(H5Calls!("link"));
}
///
unittest {
  assert(H5Link() == "<link>");
  assert(H5Link().href("https://example.com") == "<link href=\"https://example.com\">");
  assert(H5Link().rel("stylesheet") == "<link rel=\"stylesheet\">");
  assert(H5Link().as("style") == "<link as=\"style\">");
  assert(H5Link().crossorigin("anonymous") == "<link crossorigin=\"anonymous\">");
  assert(H5Link().fetchpriority("high") == "<link fetchpriority=\"high\">");
  assert(H5Link().hreflang("en") == "<link hreflang=\"en\">");
  assert(H5Link().imagesizes("(max-width: 600px) 100vw, 50vw") == "<link imagesizes=\"(max-width: 600px) 100vw, 50vw\">");
  assert(H5Link().imagesrcset("image-small.jpg 500w, image-large.jpg 1000w") == "<link imagesrcset=\"image-small.jpg 500w, image-large.jpg 1000w\">");
  assert(H5Link().integrity("sha384-abc123") == "<link integrity=\"sha384-abc123\">");
  assert(H5Link().media("screen") == "<link media=\"screen\">");
  assert(H5Link().referrerpolicy("no-referrer") == "<link referrerpolicy=\"no-referrer\">");
  assert(H5Link().sizes("(max-width: 600px) 100vw, 50vw") == "<link sizes=\"(max-width: 600px) 100vw, 50vw\">");
  assert(H5Link().title("Example Link") == "<link title=\"Example Link\">");
  assert(H5Link().type("text/css") == "<link type=\"text/css\">");
}
