/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.game.domain.world;

import uim.game;

mixin(ShowModule!());

@safe:

final class GameWorld {
  private EngineConfig _config;
  private SceneSnapshot _state;
  private bool _configured;

  bool configure(EngineConfig config) {
    if (config.sceneId.length == 0 || config.maxObjects == 0) {
      _configured = false;
      return false;
    }

    if (config.fixedDeltaSeconds <= 0.0) {
      config.fixedDeltaSeconds = 1.0 / 60.0;
    }

    _config = config;
    _state = EmptyScene(config.sceneId);
    _configured = true;
    return true;
  }

  EngineConfig config() {
    return _config;
  }

  SceneSnapshot state() {
    return _state;
  }

  EngineResult start() {
    if (!_configured) {
      return EngineErr(_state, "engine is not configured");
    }

    _state.running = true;
    return EngineOk(_state, "engine started");
  }

  EngineResult stop() {
    if (!_configured) {
      return EngineErr(_state, "engine is not configured");
    }

    _state.running = false;
    return EngineOk(_state, "engine stopped");
  }

  EngineResult loadScene(GameObject[] objects) {
    if (!_configured) {
      return EngineErr(_state, "engine is not configured");
    }

    if (objects.length > _config.maxObjects) {
      return EngineErr(_state, "scene exceeds maxObjects");
    }

    _state.objects = objects.dup;
    return EngineOk(_state, "scene loaded");
  }

  EngineResult handleInput(string objectId, InputAction action, Vector3 delta) {
    if (!_configured) {
      return EngineErr(_state, "engine is not configured");
    }

    if (objectId.length == 0) {
      return EngineErr(_state, "objectId is required");
    }

    bool found;
    foreach (ref obj; _state.objects) {
      if (obj.id != objectId) {
        continue;
      }

      found = true;
      final switch (action) {
        case InputAction.move:
          obj.transform.position.x += delta.x;
          obj.transform.position.y += delta.y;
          obj.transform.position.z += delta.z;
          break;

        case InputAction.rotate:
          obj.transform.rotationEuler.x += delta.x;
          obj.transform.rotationEuler.y += delta.y;
          obj.transform.rotationEuler.z += delta.z;
          break;

        case InputAction.scale:
          obj.transform.scale.x += delta.x;
          obj.transform.scale.y += delta.y;
          obj.transform.scale.z += delta.z;
          break;
      }

      break;
    }

    if (!found) {
      return EngineErr(_state, "object not found");
    }

    return EngineOk(_state, "input handled");
  }

  EngineResult tick(double deltaSeconds) {
    if (!_configured) {
      return EngineErr(_state, "engine is not configured");
    }

    if (!_state.running) {
      return EngineErr(_state, "engine is not running");
    }

    double dt = deltaSeconds;
    if (dt <= 0.0) {
      dt = _config.fixedDeltaSeconds;
    }

    _state.tick += 1;
    _state.elapsedSeconds += dt;

    foreach (ref obj; _state.objects) {
      if (!obj.dynamicBody) {
        continue;
      }

      // Apply a simple deterministic yaw update for dynamic entities.
      obj.transform.rotationEuler.y += dt * 0.25;
    }

    return EngineOk(_state, "tick complete");
  }
}

unittest {
  auto world = new GameWorld();

  EngineConfig cfg;
  cfg.sceneId = "arena";
  cfg.maxObjects = 10;
  assert(world.configure(cfg));

  auto startRes = world.start();
  assert(startRes.success);

  GameObject player;
  player.id = "player";
  player.dynamicBody = true;

  auto loadRes = world.loadScene([player]);
  assert(loadRes.success);

  auto tickRes = world.tick(0.016);
  assert(tickRes.success);
  assert(tickRes.snapshot.tick == 1);
}
