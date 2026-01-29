module uim.html.classes.forms.radio;

import uim.html;

mixin(ShowModule!());

@safe:

class Radio : DInput  {
  this() {
    super("input");
    attribute("type", "radio");
  }
}