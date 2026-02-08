module uim.html.classes.forms.element;

import uim.html;

mixin(ShowModule!());

@safe:

class FormElement : HtmlElement, IFormElement {
  this(string tagName) {
    super(tagName);
  }

  IHtmlAttribute form() {
    return attribute("form");
  }

  IFormElement form(string formId) {
    attribute("form", formId);
    return this;
  }

  static FormElement opCall(string tagName) {
    return new FormElement(tagName);
  } 
}
///
unittest {
  assert(FormElement("input") == "<input></input>");
}