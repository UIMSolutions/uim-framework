/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module  source.uim.entities.classes.attributes.entities.contact;

import uim.entities;

mixin(ShowModule!());

@safe:

/* class ContactAttribute : UIMEntityAttribute {
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


    this.name("contact");
    this.registerPath("contact");
  }  
} */