module uim.html.classes.forms.legend;

import uim.html;

mixin(ShowModule!());

@safe:

class Legend : HtmlFormElement {
  this() {
    super("legend");
  }
}