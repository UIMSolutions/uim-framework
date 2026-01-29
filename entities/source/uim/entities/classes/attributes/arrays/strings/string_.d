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

  this(Json configSettings) {
    super(configSettings);
  }
  
  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("StringArrayAttribute");
    this.dataFormats(["string", "array"]);
    this.registerPath("StringArrayAttribute");
  }

  override IValue createValue() {
    return (new StringArrayValue).attribute(this);
  }
}
