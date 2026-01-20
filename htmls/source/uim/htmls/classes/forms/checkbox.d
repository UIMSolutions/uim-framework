module uim.htmls.classes.forms.checkbox;

import uim.htmls;

@safe:

class DCheckbox : DInput {
  this() {
    super("input");
    type("checkbox");
  }

  this(string tag) {
    super(tag);
    type("checkbox");
  }
}