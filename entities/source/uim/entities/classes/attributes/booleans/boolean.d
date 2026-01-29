/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module uim.entities.classes.attributes.booleans.boolean;

import uim.entities;

mixin(ShowModule!());

@safe:
class BooleanAttribute : UIMAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

/* Inheritance
any <- boolean
Traits
is.dataFormat.boolean */

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("boolean");
    this.addDataFormats(["boolean"]);
    this.registerPath("boolean");
  }

  override IValue createValue() {
    return BooleanValue(this); }
}