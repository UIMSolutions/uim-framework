/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.s2000m;

import vibe.d;

mixin(ShowModule!());

public {
  import uim.core;
  import uim.oop;
}

public {
  import uim.s2000m.interfaces;
  import uim.s2000m.models;
  import uim.s2000m.helpers;
}

public {
  import uim.s2000m.catalog;
  import uim.s2000m.service;
}