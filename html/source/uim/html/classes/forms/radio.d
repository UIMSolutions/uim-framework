module uim.html.classes.forms.radio;

import uim.html;

mixin(ShowModule!());

@safe:

class Radio : Input  {
  this() {
    super("input");
    attribute("type", "radio");
  }
}