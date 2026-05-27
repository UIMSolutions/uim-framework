/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
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
 @UDAStringAttribute("form") // The form attribute specifies one or more forms the fieldset belongs to.
 @UDAStringAttribute("name") // The name attribute specifies the name of the fieldset, which can be used to reference it in scripts or styles.
 @UDABoolAttribute("disabled") // The disabled attribute indicates that the fieldset is disabled, meaning that the user cannot interact with it or its child elements.
class H5Fieldset : HtmlElement {
  mixin(HtmlTemplate!(H5Fieldset, "Fieldset", "fieldset", false));
}
///
unittest {
  mixin(ShowTest!"Testing Fieldset Class");

  assert(H5Fieldset() == "<fieldset></fieldset>");
  assert(H5Fieldset("Personal Information") == "<fieldset>Personal Information</fieldset>");
  assert(H5Fieldset(["testclass"]) == "<fieldset class=\"testclass\"></fieldset>");
  assert(H5Fieldset(["a":"b"]) == "<fieldset a=\"b\"></fieldset>");

  assert(H5Fieldset().form("myForm") == "<fieldset form=\"myForm\"></fieldset>");
  assert(H5Fieldset().name("myFieldset") == "<fieldset name=\"myFieldset\"></fieldset>");
  assert(H5Fieldset().disabled() == "<fieldset disabled></fieldset>");
}