/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.game.application.engine_usecases;

import uim.game;

mixin(ShowModule!());

@safe:

EngineResult startEngine(GameWorld world) {
  return world.start();
}

EngineResult stopEngine(GameWorld world) {
  return world.stop();
}

EngineResult tickEngine(GameWorld world, double deltaSeconds = 0.0) {
  return world.tick(deltaSeconds);
}
