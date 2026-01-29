/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.arrays.bytes.binary;

import uim.entities;

mixin(ShowModule!());

@safe:
class DBinaryAttribute : UIMAttribute {
  mixin(AttributeThis!("BinaryAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);


    /* Inheritance
    any <- byte <- binary
    Traits
    is.dataFormat.byte
    is.dataFormat.array */
    this
      .addDataFormats(["array"])
      .name("binary");
    this.registerPath("binary");
  }
}