# Library uim-game

Updated on 28. July 2026

uim-game is a D/vibe.d library for building 3D web game backends with a clean and hexagonal architecture style. It provides a lightweight game engine core, deterministic tick loop, scene/object model, async game-loop integration via vibe.d, and adapter ports for persistence and frame publishing.

## Goals

- Build deterministic server-side 3D game simulation loops
- Keep game rules independent from frameworks and transport protocols
- Use ports/adapters to integrate storage, networking, and rendering bridges
- Provide an extensible foundation for multiplayer browser games

## Features

- `IGameEngine` service contract with sync and async tick APIs
- Domain world model with scene snapshots and object transforms
- Input handling for movement, rotation, and scale operations
- Deterministic update progression through fixed delta ticking
- Hexagonal ports:
  - `IWorldRepository` for persistence
  - `IFrameSink` for pushing frames/events outward
- Default adapters:
  - `InMemoryWorldRepository`
  - `NullFrameSink`
  - `VibeGameLoopAdapter` for async loop integration using `runTask`

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:game" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.game;

void main() {
  auto engine = GameEngine();

  EngineConfig cfg;
  cfg.sceneId = "arena";
  cfg.fixedDeltaSeconds = 1.0 / 60.0;
  cfg.maxObjects = 1000;

  assert(engine.configure(cfg));
  assert(engine.start().success);

  GameObject player;
  player.id = "player-1";
  player.name = "Player";
  player.dynamicBody = true;

  assert(engine.loadScene([player]).success);
  assert(engine.handleInput("player-1", InputAction.move, Vec3(0.5, 0.0, 0.0)).success);

  auto result = engine.tick();
  writeln("tick=", result.snapshot.tick, " elapsed=", result.snapshot.elapsedSeconds);

  engine.tickAsync(1.0 / 60.0, (EngineResult r) @safe {
    writeln("async tick success=", r.success);
  });
}
```

## Module Layout

- `uim.game`: package entrypoint and re-exports
- `uim.game.interfaces`: contracts, DTOs, and ports
- `uim.game.models`: model constructors and helper factories
- `uim.game.domain`: engine core domain state and rules
- `uim.game.application`: application/use-case functions
- `uim.game.adapters`: infrastructure adapters (in-memory, vibe loop)
- `uim.game.service`: orchestrating engine implementation

## Clean + Hexagonal Mapping

- Domain (`domain/world.d`) has no dependency on external IO concerns.
- Application (`application/engine_usecases.d`) coordinates use cases around domain behavior.
- Ports (`interfaces/client.d`) define boundaries for infrastructure integration.
- Adapters (`adapters/*.d`) implement those boundaries for runtime needs.
- Service (`service.d`) composes domain + adapters and exposes one engine API.

## Next Steps

- Add a websocket adapter to broadcast frame snapshots to browser clients.
- Add collision and physics integration with dedicated domain services.
- Add ECS-style component storage for larger scenes.
- Add snapshot delta compression for efficient multiplayer updates.
