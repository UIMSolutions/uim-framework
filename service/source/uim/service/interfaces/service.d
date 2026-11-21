/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.interfaces.service;

import uim.service;

mixin(ShowModule!());

@safe:
/// Lifecycle contract of a service.
interface IService {
  void start();
  void stop();
}

/// Configuration and probe contract of a service.
interface IUIMService {
  IUIMConfig config();
  void config(IUIMConfig cfg);

  Json health();
  Json ready();
}
