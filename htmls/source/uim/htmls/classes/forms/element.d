module uim.htmls.classes.forms.element;

import uim.htmls;

mixin(ShowModule!());

@safe:

class DHtmlFormElement : DHtmlElement, IHtmlFormElement {
  this(string tagName) {
    super(tagName);
  }

  IHtmlAttribute form() {
    return attribute("form");
  }

  IHtmlFormElement form(string formId) {
    attribute("form", formId);
    return this;
  }
}
