/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.game;

import vibe.d;

mixin(ShowModule!());

public {
  import uim.core;
  import uim.oop;
}

public {
  import uim.game.interfaces;
  import uim.game.models;
  import uim.game.domain;
  import uim.game.application;
  import uim.game.adapters;
}

public {
  import uim.game.service;
}
