/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
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
