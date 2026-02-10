/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.forms.textarea;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML textarea element
class Textarea : FormElement {
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

  static Textarea opCall() {
  return new Textarea();
}

static Textarea opCall(string name) {
  auto ta = new Textarea();
  ta.name(name);
  return ta;
}

}
///
unittest {
  assert(Textarea() == "<textarea></textarea>");
  auto ta = Textarea("comment");
  assert(ta.toString().indexOf("textarea") > 0);
}
