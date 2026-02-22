module uim.html.udas.attributes.bool_;

import uim.html;

@safe:

struct BoolAttribute {
  string methodName;
  string attributeName;
  string isName;

  this(string methodName, string attributeName = "") {
    this.methodName = methodName;
    this.attributeName = attributeName.length > 0 ? attributeName : methodName;
    this.isName = "is" ~ methodName[0 .. 1].toUpper() ~ methodName[1 .. $];
  }
}
