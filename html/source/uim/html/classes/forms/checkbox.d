module uim.html.classes.forms.checkbox;

import uim.html;

mixin(ShowModule!());

@safe:

class Checkbox : Input {
  this() {
    super("input");
    type("checkbox");
  }

  this(string tag) {
    super(tag);
    type("checkbox");
  }
}