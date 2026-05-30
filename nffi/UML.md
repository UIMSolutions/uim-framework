# UIM-NFFI UML Description

## Overview

The UIM-NFFI library provides a compact architecture for NATO Friendly Force Information workflows in D. It combines typed contracts, payload codec helpers, model constructors, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml NFFI_Core

enum NFFIStandard {
  atp45
  app11
  custom
}

struct NFFIConfig {
  + endpoint: string
  + nationCode: string
  + forceId: string
  + standard: NFFIStandard
  + strictValidation: bool
  + timeoutMs: uint
}

struct NFFITrack {
  + unitId: string
  + callsign: string
  + affiliation: string
  + symbolCode: string
  + latitude: double
  + longitude: double
  + altitude: double
  + timestamp: long
  + source: string
}

struct NFFIResult {
  + success: bool
  + statusCode: ushort
  + message: string
  + referenceId: string
}

interface INFFIService {
  + configure(config: NFFIConfig): bool
  + publishTrack(track: NFFITrack): NFFIResult
  + getTrack(unitId: string): NFFITrack
  + synchronizeArea(areaId: string): NFFITrack[]
  + getTrackAsync(unitId: string, handler: NFFITrackHandler): bool
  + synchronizeAreaAsync(areaId: string, handler: NFFITracksHandler): bool
  + publishTrackAsync(track: NFFITrack, handler: NFFIResultHandler): bool
}

class UIMNFFIService

UIMNFFIService ..|> INFFIService

@enduml
```

## Helper Layer

```plantuml
@startuml NFFI_Helpers

class CodecHelpers {
  + nffiEncodeTrack(track: NFFITrack): string
  + nffiDecodeTrack(payload: string): NFFITrack
}

UIMNFFIService --> CodecHelpers : encode and decode track payloads

@enduml
```

## Sequence

```plantuml
@startuml NFFI_Sequence

actor Application
participant Service as "UIMNFFIService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "NFFIResultHandler"

Application -> Service: configure(nffiConfig)
Application -> Service: getTrack("DEU-ARMY-0007")
Service --> Application: NFFITrack

Application -> Service: encodeTrack(track)
Service -> Helpers: serialize payload
Helpers --> Service: encoded string
Service --> Application: payload

Application -> Service: publishTrackAsync(track, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(result)

@enduml
```
