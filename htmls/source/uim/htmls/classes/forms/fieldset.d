module uim.htmls.classes.forms.fieldset;

import uim.htmls;

@safe:

class DFieldset : DHtmlElement {
  this() {
    super("fieldset");
  }

  IHtmlElement disabled() {
    attribute("disabled", "");
    return this;
  }

  IHtmlElement form(string formId) {
    attribute("form", formId);
    return this;
  }

  IHtmlElement name(string nameValue) {
    attribute("name", nameValue);
    return this;
  }
}