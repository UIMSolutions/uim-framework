/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.game.adapters.vibe_game_loop_adapter;

import vibe.d : runTask;

import uim.game;

mixin(ShowModule!());

@safe:

class VibeGameLoopAdapter {
  bool tickOnceAsync(IGameEngine engine, double deltaSeconds, AsyncResultHandler handler) {
    if (engine is null || handler is null) {
      return false;
    }

    auto localEngine = engine;
    auto localDelta = deltaSeconds;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(localEngine.tick(localDelta));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}
