module uim.html.classes.forms.element;

import uim.html;

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
