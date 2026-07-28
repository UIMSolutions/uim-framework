/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.game.service;

import vibe.d : runTask;

import uim.game;

mixin(ShowModule!());

@safe:

class UIMGameEngine : UIMObject, IGameEngine {
  private GameWorld _world;
  private IWorldRepository _repository;
  private IFrameSink _sink;
  private FrameReadyHandler _frameHandler;

  this() {
    _world = new GameWorld();
    _repository = new InMemoryWorldRepository();
    _sink = new NullFrameSink();
  }

  bool configure(EngineConfig config) {
    return _world.configure(config);
  }

  EngineConfig config() {
    return _world.config();
  }

  bool setWorldRepository(IWorldRepository repository) {
    if (repository is null) {
      return false;
    }

    _repository = repository;
    return true;
  }

  bool setFrameSink(IFrameSink sink) {
    if (sink is null) {
      return false;
    }

    _sink = sink;
    return true;
  }

  bool setFrameHandler(FrameReadyHandler handler) {
    _frameHandler = handler;
    return true;
  }

  EngineResult start() {
    return _world.start();
  }

  EngineResult stop() {
    auto result = _world.stop();
    if (result.success) {
      _repository.save(result.snapshot);
    }

    return result;
  }

  EngineResult loadScene(GameObject[] objects) {
    auto result = _world.loadScene(objects);
    if (result.success) {
      _repository.save(result.snapshot);
    }

    return result;
  }

  EngineResult handleInput(string objectId, InputAction action, Vector3 delta) {
    auto result = _world.handleInput(objectId, action, delta);
    if (result.success) {
      _repository.save(result.snapshot);
      publishFrame(result.snapshot);
    }

    return result;
  }

  EngineResult tick(double deltaSeconds = 0.0) {
    auto result = _world.tick(deltaSeconds);
    if (result.success) {
      _repository.save(result.snapshot);
      publishFrame(result.snapshot);
    }

    return result;
  }

  SceneSnapshot state() {
    return _world.state();
  }

  bool tickAsync(double deltaSeconds, AsyncResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localDelta = deltaSeconds;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(tick(localDelta));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  private void publishFrame(SceneSnapshot snapshot) {
    _sink.publish(snapshot);
    if (_frameHandler !is null) {
      _frameHandler(snapshot);
    }
  }
}

IGameEngine GameEngine() {
  return new UIMGameEngine();
}

unittest {
  auto engine = GameEngine();

  EngineConfig cfg;
  cfg.sceneId = "sandbox";
  cfg.maxObjects = 100;

  assert(engine.configure(cfg));
  assert(engine.start().success);

  GameObject cube;
  cube.id = "cube-1";
  cube.name = "Cube";
  cube.dynamicBody = true;

  assert(engine.loadScene([cube]).success);
  assert(engine.handleInput("cube-1", InputAction.move, Vec3(1, 0, 0)).success);

  auto tickRes = engine.tick();
  assert(tickRes.success);
  assert(tickRes.snapshot.tick == 1);

  assert(engine.stop().success);
}
