/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.helpers.factory;

import uim.errors;
import uim.services.interfaces.service;
import uim.services.classes.service;

mixin(ShowModule!());

@safe:

// Factory for creating instances of services. This factory allows for the registration of different types of services and provides a way to create them by name.
class ServiceFactory : UIMFactory!(string, IService) {
  this() {
    super();
  }
}
///
unittest {
  mixin(ShowTest!"Testing ServiceFactory");

  auto factory = new ServiceFactory();
  assert(factory !is null);
  factory.register("test", () => new UIMService());
  auto service = factory.create("test");
  assert(service !is null);
}
