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
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


    this.name("boolean");
    this.addDataFormats(["boolean"]);
    this.registerPath("boolean");

    return true;
  }

  override IValue createValue() {
    return new BooleanValue(this); }
}