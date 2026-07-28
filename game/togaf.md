# TOGAF Mapping - UIM-GAME

This document maps the uim-game library to TOGAF architecture domains.

## 1. Architecture Vision

uim-game provides a reusable, domain-centric engine component for 3D web game simulation. The architectural intent is to isolate game rules from technology details so infrastructure can evolve (websocket transport, persistence, telemetry) without changing domain logic.

## 2. Business Architecture

### 2.1 Business Capabilities

- Real-time gameplay state progression
- Deterministic simulation for authoritative server design
- Scene and object lifecycle handling
- Input command processing
- Frame publication to downstream channels

### 2.2 Stakeholders

- Game backend developers
- Web frontend teams consuming frame data
- Platform engineers operating runtime services
- QA engineers validating deterministic behavior

## 3. Information Systems Architecture

### 3.1 Data Architecture

Key canonical data objects:

- `EngineConfig`
- `SceneSnapshot`
- `GameObject`
- `Transform`
- `Vector3`
- `EngineResult`

Data lifecycle:

1. Configure engine with scene metadata.
2. Load mutable scene object set.
3. Apply input commands that mutate transforms.
4. Persist and publish snapshot after update operations.

### 3.2 Application Architecture

Layer and dependency direction:

- `interfaces` defines contracts and ports
- `domain` contains pure simulation behavior
- `application` exposes use-case functions
- `adapters` implement infrastructure concerns
- `service` composes dependencies into one façade

This enforces inward dependency flow and aligns with hexagonal architecture.

## 4. Technology Architecture

- Language: D
- Runtime integration: vibe.d (`runTask` async scheduling)
- Packaging: dub subpackage (`uim-framework:game`)
- Default persistence adapter: in-memory map storage

## 5. Implementation Governance

### 5.1 Architectural Principles

- Domain rules are framework-independent.
- Infrastructure dependencies only enter through ports.
- Async operations must isolate failures and avoid leaking exceptions.
- Public API should remain stable and typed.

### 5.2 Compliance Checks

- Verify no adapter-only concern leaks into domain modules.
- Verify engine can execute synchronously and asynchronously.
- Verify snapshots remain serializable transport DTOs.

## 6. Migration Roadmap

### Phase A

- Core deterministic tick loop and input operations
- In-memory repository and null sink adapters
- Async loop execution adapter using vibe.d

### Phase B

- Websocket frame broadcaster adapter
- Multi-scene session manager
- Replay and rollback support for server authority

### Phase C

- Physics plugin ports (collision, rigid-body)
- ECS-oriented storage strategies
- Horizontal scaling and distributed scene ownership
