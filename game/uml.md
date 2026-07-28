# UIM-GAME UML Description

## Overview

uim-game provides a clean + hexagonal architecture for a 3D web game engine built with D and vibe.d integration points.

## Core Model

```plantuml
@startuml GAME_Core

enum InputAction {
  move
  rotate
  scale
}

struct Vector3 {
  + x: double
  + y: double
  + z: double
}

struct Transform {
  + position: Vector3
  + rotationEuler: Vector3
  + scale: Vector3
}

struct GameObject {
  + id: string
  + name: string
  + dynamicBody: bool
  + transform: Transform
}

struct SceneSnapshot {
  + sceneId: string
  + tick: ulong
  + elapsedSeconds: double
  + running: bool
  + objects: GameObject[]
}

struct EngineConfig {
  + sceneId: string
  + fixedDeltaSeconds: double
  + maxObjects: uint
  + deterministic: bool
}

struct EngineResult {
  + success: bool
  + message: string
  + snapshot: SceneSnapshot
}

@enduml
```

## Hexagonal Ports

```plantuml
@startuml GAME_Ports

interface IWorldRepository {
  + save(snapshot: SceneSnapshot): bool
  + load(sceneId: string): SceneSnapshot
}

interface IFrameSink {
  + publish(snapshot: SceneSnapshot): bool
}

interface IGameEngine {
  + configure(config: EngineConfig): bool
  + start(): EngineResult
  + stop(): EngineResult
  + loadScene(objects: GameObject[]): EngineResult
  + handleInput(objectId: string, action: InputAction, delta: Vector3): EngineResult
  + tick(deltaSeconds: double): EngineResult
  + tickAsync(deltaSeconds: double, handler: AsyncResultHandler): bool
  + state(): SceneSnapshot
}

class UIMGameEngine
class GameWorld
class InMemoryWorldRepository
class NullFrameSink
class VibeGameLoopAdapter

UIMGameEngine ..|> IGameEngine
InMemoryWorldRepository ..|> IWorldRepository
NullFrameSink ..|> IFrameSink
UIMGameEngine --> GameWorld
UIMGameEngine --> IWorldRepository
UIMGameEngine --> IFrameSink
VibeGameLoopAdapter --> IGameEngine

@enduml
```

## Sequence: One Tick with Input

```plantuml
@startuml GAME_Sequence

actor Client
participant Engine as "UIMGameEngine"
participant World as "GameWorld"
participant Repo as "IWorldRepository"
participant Sink as "IFrameSink"

Client -> Engine: handleInput("player-1", move, delta)
Engine -> World: handleInput(...)
World --> Engine: EngineResult
Engine -> Repo: save(snapshot)
Engine -> Sink: publish(snapshot)
Engine --> Client: EngineResult

Client -> Engine: tick(1/60)
Engine -> World: tick(1/60)
World --> Engine: EngineResult
Engine -> Repo: save(snapshot)
Engine -> Sink: publish(snapshot)
Engine --> Client: EngineResult

@enduml
```

## Package Dependencies

```plantuml
@startuml GAME_Packages

package "uim.game.interfaces" {
  [client.d]
}

package "uim.game.domain" {
  [world.d]
}

package "uim.game.application" {
  [engine_usecases.d]
}

package "uim.game.adapters" {
  [in_memory_world_repository.d]
  [vibe_game_loop_adapter.d]
}

package "uim.game.service" {
  [service.d]
}

"uim.game.service" --> "uim.game.domain"
"uim.game.service" --> "uim.game.adapters"
"uim.game.domain" --> "uim.game.models"
"uim.game.application" --> "uim.game.domain"
"uim.game.adapters" --> "uim.game.interfaces"

@enduml
```
