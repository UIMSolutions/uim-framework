/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.arrays.bytes.image;

/* any <- byte <- image <- image
Traits
is.dataFormat.byte
is.dataFormat.array
means.content.image.image */

import uim.entities;

mixin(ShowModule!());

@safe:
class ImageAttribute : BinaryAttribute {
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

    /* 
means.content.binary.image */
    this
      .addDataFormats(["array"])
      .name("image");
    this.registerPath("image");

    return true;
  }
}