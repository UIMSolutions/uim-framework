module uim.html.classes.forms.legend;

import uim.html;

mixin(ShowModule!());

@safe:

class Legend : DHtmlFormElement {
  this() {
    super("legend");
  }
}