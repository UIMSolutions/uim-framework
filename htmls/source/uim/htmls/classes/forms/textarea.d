module uim.htmls.classes.forms.textarea;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import uim.htmls;

mixin(ShowModule!());

@safe:

/// HTML textarea element
class DTextarea : DHtmlFormElement {
  this() {
    super("textarea");
  }

  IHtmlAttribute name() {
    return attribute("name");
  }

  IHtmlElement name(string nameValue) {
    attribute("name", nameValue);
    return this;
  }

  IHtmlElement rows(string rowCount) {
    attribute("rows", rowCount);
    return this;
  }

  IHtmlElement cols(string colCount) {
    attribute("cols", colCount);
    return this;
  }

  IHtmlElement placeholder(string text) {
    attribute("placeholder", text);
    return this;
  }

  IHtmlElement required() {
    attribute("required", "");
    return this;
  }

  IHtmlElement disabled() {
    attribute("disabled", "");
    return this;
  }

  IHtmlElement readonly() {
    attribute("readonly", "");
    return this;
  }

  protected string _content;
  override string content() {
    return _content;
  }

  override IHtmlElement content(string value) {
    _content = value;
    return this;
  }
}

auto Textarea() {
  return new DTextarea();
}

auto Textarea(string name) {
  auto ta = new DTextarea();
  ta.name(name);
  return ta;
}

unittest {
  auto ta = Textarea("comment");
  assert(ta.toString().indexOf("textarea") > 0);
}
