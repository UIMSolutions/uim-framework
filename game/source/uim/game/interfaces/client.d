/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.game.interfaces.client;

@safe:

enum InputAction : ubyte {
  move = 0,
  rotate = 1,
  scale = 2
}

struct Vector3 {
  double x;
  double y;
  double z;
}

struct Transform {
  Vector3 position;
  Vector3 rotationEuler;
  Vector3 scale = Vector3(1.0, 1.0, 1.0);
}

struct MeshRef {
  string meshId;
  string materialId;
}

struct GameObject {
  string id;
  string name;
  bool dynamicBody;
  Transform transform;
  MeshRef mesh;
}

struct SceneSnapshot {
  string sceneId;
  ulong tick;
  double elapsedSeconds;
  bool running;
  GameObject[] objects;
}

struct EngineConfig {
  string sceneId;
  double fixedDeltaSeconds = 1.0 / 60.0;
  uint maxObjects = 10_000;
  bool deterministic = true;
}

struct EngineResult {
  bool success;
  string message;
  SceneSnapshot snapshot;
}

alias FrameReadyHandler = void delegate(SceneSnapshot snapshot) @safe;
alias AsyncResultHandler = void delegate(EngineResult result) @safe;

interface IWorldRepository {
  bool save(SceneSnapshot snapshot);
  SceneSnapshot load(string sceneId);
}

interface IFrameSink {
  bool publish(SceneSnapshot snapshot);
}

interface IGameEngine {
  bool configure(EngineConfig config);
  EngineConfig config();

  bool setWorldRepository(IWorldRepository repository);
  bool setFrameSink(IFrameSink sink);
  bool setFrameHandler(FrameReadyHandler handler);

  EngineResult start();
  EngineResult stop();
  EngineResult loadScene(GameObject[] objects);
  EngineResult handleInput(string objectId, InputAction action, Vector3 delta);
  EngineResult tick(double deltaSeconds = 0.0);
  SceneSnapshot state();

  bool tickAsync(double deltaSeconds, AsyncResultHandler handler);
}
