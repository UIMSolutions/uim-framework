module uim.html.classes.forms.radio;

import uim.html;

mixin(ShowModule!());

@safe:

class DRadio : DInput  {
  this() {
    super("input");
    attribute("type", "radio");
  }
}