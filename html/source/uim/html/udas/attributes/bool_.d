/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
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
