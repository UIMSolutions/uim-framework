/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.mixins.store;
import uim.service;

mixin(ShowModule!());

@safe:
string sapStoreTemplate() {
  return q{
  this() {
    super();
  }

  this(Json initData) {
    super(initData);
  }

  this(Json[string] initData) {
    super(initData);
  }
  };
}

template UIMStoreTemplate(alias Symbol) {
  const char[] SAPStoreTemplate = sapStoreTemplate();
}
