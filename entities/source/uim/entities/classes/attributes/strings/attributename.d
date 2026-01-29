/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.attributename;

// Type for trait parameters that take attribute names as values

import uim.entities;

mixin(ShowModule!());

@safe:
class AttributeNameAttribute : StringAttribute {
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }
  /*
attributeName
Description

Type for trait parameters that take attribute names as values

Inheritance
any <- char <- string <- attributeName
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.attributeName

  */

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("attributeName");
    this.registerPath("attributeName");
  }
}