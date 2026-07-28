# NAF v4 Architecture - UIM-GAME

This document maps uim-game capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM Game Engine Library |
| Version | 26.x |
| Date | 28 Jul 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | 3D web game simulation and orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| Game Engine | Service managing scene state and deterministic updates |
| Scene Snapshot | Tick-based representation of objects and transforms |
| Port | Interface boundary independent from infrastructure |
| Adapter | Implementation of a port for specific runtime concerns |
| Tick | One update step using fixed or provided delta time |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
3D Web Game Simulation Capability
|- Engine Lifecycle
|  |- configure world limits and deterministic mode
|  |- start and stop execution
|- Scene Management
|  |- load object collections
|  |- store and load snapshots via repository port
|- Input Processing
|  |- movement updates
|  |- rotation updates
|  |- scale updates
|- Simulation Loop
|  |- fixed-time tick progression
|  |- dynamic object auto updates
|- Async Runtime Integration
   |- vibe.d runTask based async tick execution
   |- frame publication via frame sink port
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async tick | vibe.d runTask |
| Scene persistence | IWorldRepository port |
| Frame fan-out | IFrameSink port |
| Engine orchestration | UIMGameEngine service |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures engine with deterministic tick settings.
2. Scene objects are loaded into domain world state.
3. Browser/player input events are mapped to engine input commands.
4. Engine executes tick cycle and updates snapshot.
5. Snapshot is persisted and published through output ports.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure engine | EngineConfig | configured world |
| 2 | Start simulation | start command | running scene |
| 3 | Apply input | objectId + InputAction + delta | updated transform |
| 4 | Tick world | delta time | incremented snapshot tick |
| 5 | Publish frame | SceneSnapshot | delivered frame output |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+--------------------------------------+
| Browser / Game Client                |
+-------------------+------------------+
                    |
                    v
+--------------------------------------+
| Application Layer                    |
| - gameplay command mapping           |
+-------------------+------------------+
                    |
                    v
+--------------------------------------+
| uim.game.service (UIMGameEngine)     |
| - lifecycle / input / tick API       |
+-------------------+------------------+
                    |
        +-----------+------------+
        |                        |
        v                        v
+---------------+        +----------------+
| IWorldRepo    |        | IFrameSink     |
| adapter impls |        | adapter impls  |
+---------------+        +----------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.game.interfaces.client | contracts, DTOs, ports |
| uim.game.models.client | model helper constructors |
| uim.game.domain.world | core simulation and rules |
| uim.game.application.engine_usecases | use-case orchestration |
| uim.game.adapters.* | infrastructure integration |
| uim.game.service | composition and API facade |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| Hexagonal Architecture | N/A | boundary-driven design |
| Clean Architecture | N/A | domain-centric layering |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Domain world and tick loop | Implemented | deterministic simulation core |
| Port and adapter boundaries | Implemented | repo and frame sink ports |
| Async loop adapter | Implemented | non-blocking tick integration |
| Websocket broadcasting adapter | Planned | real-time browser frame output |
| Physics and collision subsystem | Planned | modular domain service extension |
