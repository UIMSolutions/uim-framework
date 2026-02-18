module uim.html.classes.forms.radio;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <input type="radio"> element, which is used to create radio buttons in forms.
  * Inherits from H5Input, allowing it to utilize common input attributes and methods while setting the type to "radio".
  *
  * Example usage:
  *
  * <form>
  *   <input type="radio" name="option" value="1"> Option 1<br>
  *   <input type="radio" name="option" value="2"> Option 2<br>
  *   <input type="radio" name="option" value="3"> Option 3<br>
  * </form>
  */
class H5Radio : H5Input {
  this() {
    super("input");
    attribute("type", "radio");
  }

  mixin(H5Calls!("Radio"));
}
///
unittest {
  assert(Radio() == `<input type="radio" />`);
  //TODO: assert(Radio("Option 1") == `<input type="radio" />Option 1`);
  }