module uim.html.classes.forms.fieldset;

import uim.html;

mixin(ShowModule!());

@safe:

class Fieldset : HtmlElement {
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

  static Fieldset opCall() {
    return new Fieldset();
  }
}
///
unittest {
  mixin(ShowTest!"Testing Fieldset Class");

  auto fs = Fieldset();
  assert(fs == "<fieldset></fieldset>");
}