module uim.html.classes.forms.fieldset;

import uim.html;

mixin(ShowModule!());

@safe:

class Fieldset : HtmlElement {
  this() {
    super("fieldset");
  }

  /// Sets the disabled attribute of the fieldset element.
  IHtmlElement disabled() {
    attribute("disabled", "");
    return this;
  }

  /// Sets the form attribute of the fieldset element.
  IHtmlElement form(string formId) {
    attribute("form", formId);
    return this;
  }

  /// Sets the name attribute of the fieldset element.
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

  assert(Fieldset() == "<fieldset></fieldset>");
}