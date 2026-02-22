module uim.html.udas.attributes.string_;

import uim.html;

@safe:

struct StringAttribute {
  string methodName;
  string attributeName;

  this(string methodName, string attributeName = "") {
    this.methodName = methodName;
    this.attributeName = attributeName.length > 0 ? attributeName : methodName;
  }
}
