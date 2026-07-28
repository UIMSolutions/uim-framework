/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.game.adapters.in_memory_world_repository;

import uim.game;

mixin(ShowModule!());

@safe:

class InMemoryWorldRepository : IWorldRepository {
  private SceneSnapshot[string] _store;

  bool save(SceneSnapshot snapshot) {
    if (snapshot.sceneId.length == 0) {
      return false;
    }

    _store[snapshot.sceneId] = snapshot;
    return true;
  }

  SceneSnapshot load(string sceneId) {
    if (sceneId in _store) {
      return _store[sceneId];
    }

    return EmptyScene(sceneId);
  }
}

class NullFrameSink : IFrameSink {
  bool publish(SceneSnapshot snapshot) {
    return snapshot.sceneId.length > 0;
  }
}
