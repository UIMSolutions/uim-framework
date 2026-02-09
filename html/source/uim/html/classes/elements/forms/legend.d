module uim.html.classes.forms.legend;

import uim.html;

mixin(ShowModule!());

@safe:

class Legend : FormElement {
  this() {
    super("legend");
  }

  static Legend opCall() {
    return new Legend();
  }
}
/// 
unittest {
  assert(Legend() == "<legend></legend>");
}