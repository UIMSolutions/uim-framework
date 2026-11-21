/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.mixins.config;
import uim.service;

mixin(ShowModule!());

@safe:
string uimConfigTemplate() {
  return "
  this() {
  super();
  }

  this(Json[string] initData) {
  super(initData);
  }
  ";
}

template UIMConfigTemplate(alias Symbol) {
  const char[] UIMConfigTemplate = uimConfigTemplate();
}
