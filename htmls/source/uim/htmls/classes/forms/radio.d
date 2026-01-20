module uim.htmls.classes.forms.radio;

import uim.htmls;

mixin(ShowModule!());

@safe:

class DRadio : DInput  {
  this() {
    super("input");
    attribute("type", "radio");
  }
}