/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.element;

import uim.html;

mixin(ShowModule!());

@safe:

/* class H5FormElement : HtmlElement, IFormElement {
  this(string tag) {
    super(tag);
  }

  this(string tag, string content) {
    super(tag, content);
  }

  this(string tag, string[] classes, string content = "") {
    super(tag, classes, content);
  }

  this(string tag, string[] classes, IHtmlElement[] elements) {
    super(tag, classes, elements);
  }

  this(string tag, string[string] attributes, string content = "") {
    super(tag, attributes, content);
  }

  this(string tag, string[string] attributes, IHtmlElement[] elements) {
    super(tag, attributes, elements);
  }

  this(string tag, string[] classes, string[string] attributes, string content = "") {
    super(tag, classes, attributes, content);
  }

  this(string tag, string[] classes, string[string] attributes, IHtmlElement[] elements) {
    super(tag, classes, attributes, elements);
  }

  IHtmlAttribute form() {
    return attribute("form");
  }

  IFormElement form(string formId) {
    attribute("form", formId);
    return this;
  }

  static H5FormElement opCall(string tagName) {
    return new H5FormElement(tagName);
  }
}*/ 
///
unittest {
  // assert(H5FormElement("input") == "<input></input>");
}
