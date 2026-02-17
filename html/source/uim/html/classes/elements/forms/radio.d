module uim.html.classes.forms.radio;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Radio : Input  {
  this() {
    super("input");
    attribute("type", "radio");
  }

  mixin(H5Calls!("Radio"));
}
///
unittest {
  assert(Radio() == `<input type="radio" />`);
  //TODO: assert(Radio("Option 1") == `<input type="radio" />Option 1`);}