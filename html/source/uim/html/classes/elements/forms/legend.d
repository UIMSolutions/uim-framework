module uim.html.classes.forms.legend;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <legend> element, which is used to provide a caption for a <fieldset>.
  * Inherits from H5FormElement, allowing it to be associated with a form.
  *
  * Example usage:
  *
  * <fieldset>
  *   <legend>Personal Information</legend>
  *   <!-- form fields here -->
  * </fieldset>
  */
class H5Legend : H5FormElement {
  mixin H5This!("legend");

  mixin(H5Calls!("legend"));
}
/// 
unittest {
  assert(H5Legend() == "<legend></legend>");
  assert(H5Legend("Hello") == "<legend>Hello</legend>");

}