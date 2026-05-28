/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim;

import vibe.d;
mixin(ShowModule!());

public {
  import uim.core;
  import uim.oop;

  import uim.scim.types;
  import uim.scim.schemas;
  import uim.scim.operations;
  import uim.scim.store;
}
