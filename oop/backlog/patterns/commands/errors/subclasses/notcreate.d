/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.commands.errors.subclasses.notcreate;

import uim.oop;

mixin(ShowModule!());

@safe:

// Base commands exception.
/* 
class DNotCreateCommandException : DCommandException {
  mixin(ExceptionThis!("NotCreateCommand"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    messageTemplate("default", "Not able to create command '{name}' in '{instance}'");

    return true;
  }
*/