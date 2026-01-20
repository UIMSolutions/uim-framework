/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.meta.link;

import uim.html;

@safe:

/// HTML base element
class DBase : DHtmlElement {
  this() {
    super("base");
    this.selfClosing(true);
  }

  IHtmlElement as(string value) {
    attribute("as", value);
    return this;
  }

  IHtmlAttribute as() {
    return attribute("as");
  }

  IHtmlElement blocking(string value) {
    attribute("blocking", value);
    return this;
  }

  IHtmlAttribute blocking() {
    return attribute("blocking");
  }

  // Valid values for crossorigin attribute
  // anonymous, use-credentials
  IHtmlElement crossorigin(string value) {
    attribute("crossorigin", value);
    return this;
  }

  IHtmlAttribute crossorigin() {
    return attribute("crossorigin");
  }

  IHtmlElement disabled() {
    attribute("disabled", "");
    return this;
  }

  // Valid values for fetchpriority attribute
  // high, low, auto
  IHtmlElement fetchpriority(string value) {
    attribute("fetchpriority", value);
    return this;
  }

  IHtmlAttribute fetchpriority() {
    return attribute("fetchpriority");
  }

  IHtmlElement href(string value) {
    attribute("href", value);
    return this;
  }

  IHtmlAttribute href() {
    return attribute("href");
  }

  IHtmlElement hreflang(string value) {
    attribute("hreflang", value);
    return this;
  }

  IHtmlAttribute hreflang() {
    return attribute("href");
  }

  IHtmlElement imagesizes(string value) {
    attribute("imagesizes", value);
    return this;
  }

  IHtmlAttribute imagesizes() {
    return attribute("imagesizes");
  }

  IHtmlElement imagesrcset(string value) {
    attribute("imagesrcset", value);
    return this;
  }

  IHtmlAttribute imagesrcset() {
    return attribute("imagesrcset");
  }

  IHtmlElement integrity(string value) {
    attribute("integrity", value);
    return this;
  }

  IHtmlAttribute integrity() {
    return attribute("integrity");
  }

  IHtmlElement media(string value) {
    attribute("media", value);
    return this;
  }

  IHtmlAttribute media() {
    return attribute("media");
  }

  // Valid values for rel attribute
  // alternate, author, bookmark, external, help, icon, license, next, nofollow, noreferrer,
  // preconnect, prefetch, preload, prerender, prev, search
  IHtmlElement referrerpolicy(string value) {
    attribute("referrerpolicy", value);
    return this;
  }

  IHtmlAttribute rel() {
    return attribute("rel");
  }

  IHtmlElement rel(string value) {
    attribute("rel", value);
    return this;
  }

  IHtmlElement sizes(string value) {
    attribute("sizes", value);
    return this;
  }

  IHtmlAttribute sizes() {
    return attribute("sizes");
  }

  IHtmlElement title(string value) {
    attribute("title", value);
    return this;
  }

  IHtmlAttribute title() {
    return attribute("title");
  }

  IHtmlElement type(string value) {
    attribute("type", value);
    return this;
  }

  IHtmlAttribute type() {
    return attribute("type");
  }
}
/// 
unittest {
  auto link = new DBase();
  link.href("https://example.com");
  link.rel("stylesheet");
  assert(link.toString() == `<base href="https://example.com" rel="stylesheet">`);
}

auto Base() {
  return new DBase();
}
