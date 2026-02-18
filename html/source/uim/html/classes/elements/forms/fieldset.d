module uim.html.classes.elements.forms.fieldset;

import uim.html;

mixin(ShowModule!());

@safe:

/**
 * The <fieldset> HTML element is used to group several controls as well as labels (<label>) within a web form.
 * It draws a box around the related elements, and can also include a <legend> element to provide a caption for the group.
 * 
 * Example:
 * <fieldset>
 *   <legend>Personal Information</legend>
 *   <label for="name">Name:</label>
 *   <input type="text" id="name" name="name">
 *   <label for="email">Email:</label>
 *   <input type="email" id="email" name="email">
 * </fieldset>
 */
class H5Fieldset : HtmlElement {
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

  static H5Fieldset opCall() {
    return new H5Fieldset();
  }
}
///
unittest {
  mixin(ShowTest!"Testing Fieldset Class");

  assert(H5Fieldset() == "<fieldset></fieldset>");
}