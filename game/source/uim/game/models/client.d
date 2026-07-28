/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.game.models.client;

import uim.game;

mixin(ShowModule!());

@safe:

Vector3 Vec3(double x, double y, double z) {
  Vector3 v;
  v.x = x;
  v.y = y;
  v.z = z;
  return v;
}

EngineResult EngineOk(SceneSnapshot snapshot, string message = "ok") {
  EngineResult value;
  value.success = true;
  value.message = message;
  value.snapshot = snapshot;
  return value;
}

EngineResult EngineErr(SceneSnapshot snapshot, string message) {
  EngineResult value;
  value.success = false;
  value.message = message;
  value.snapshot = snapshot;
  return value;
}

SceneSnapshot EmptyScene(string sceneId) {
  SceneSnapshot scene;
  scene.sceneId = sceneId;
  scene.tick = 0;
  scene.elapsedSeconds = 0.0;
  scene.running = false;
  return scene;
}

unittest {
  auto v = Vec3(1, 2, 3);
  assert(v.x == 1);

  auto s = EmptyScene("demo");
  auto ok = EngineOk(s);
  assert(ok.success);
}
