module uim.html.classes.forms.checkbox;

import uim.html;

@safe:

class Checkbox : DInput {
  this() {
    super("input");
    type("checkbox");
  }

  this(string tag) {
    super(tag);
    type("checkbox");
  }
}