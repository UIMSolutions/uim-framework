/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module uim.entities.classes.attributes.arrays.strings.string_;

import uim.entities;

mixin(ShowModule!());

@safe:
class StringArrayAttribute : UIMAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  
  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


    this.name("StringArrayAttribute");
    this.dataFormats(["string", "array"]);
    this.registerPath("StringArrayAttribute");

        return true;
  }

  override IValue createValue() {
    return new StringArrayValue(this);
  }
}
