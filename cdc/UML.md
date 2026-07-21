# UIM-CDC UML Description

## Overview

UIM-CDC provides a compact architecture for Virtual COM Port / USB CDC message exchange with synchronous and asynchronous operations.

## Core Types

```plantuml
@startuml CDC_Core

enum CDCParity {
  none
  odd
  even
  mark
  space
}

enum CDCStopBits {
  one
  onePointFive
  two
}

struct CDCPortConfig {
  + devicePath: string
  + baudRate: uint
  + dataBits: ubyte
  + parity: CDCParity
  + stopBits: CDCStopBits
  + readTimeoutMs: uint
  + newlineDelimited: bool
}

struct CDCFrame {
  + channel: string
  + text: string
  + payload: ubyte[]
}

struct CDCResult {
  + success: bool
  + bytesTransferred: size_t
  + message: string
}

interface ICDCService {
  + open(config: CDCPortConfig): bool
  + close(): bool
  + isOpen(): bool
  + config(): CDCPortConfig
  + setLoopback(enabled: bool): bool
  + clearBuffers(): bool
  + writeText(value: string): CDCResult
  + writeBytes(value: ubyte[]): CDCResult
  + readFrame(out frame: CDCFrame): bool
  + writeTextAsync(value: string, handler): bool
  + writeBytesAsync(value: ubyte[], handler): bool
  + pollAsync(handler, intervalMs: uint): bool
}

class UIMCDCService
UIMCDCService ..|> ICDCService

@enduml
```

## Helper Layer

```plantuml
@startuml CDC_Helpers

class CdcCodecHelpers {
  + cdcIsLoopbackPath(value: string): bool
  + cdcNormalizeLineEndings(value: string): string
  + cdcFrameFromText(value: string, channel: string): CDCFrame
  + cdcFindFrameEnd(buffer: ubyte[], newlineDelimited: bool): size_t
  + cdcOk(bytes: size_t, message: string): CDCResult
  + cdcFail(message: string): CDCResult
}

UIMCDCService --> CdcCodecHelpers : frame and result helpers

@enduml
```

## Sequence

```plantuml
@startuml CDC_Sequence

actor Application
participant Service as "UIMCDCService"
participant Task as "vibe.d runTask"
participant Handler as "CDCFrameHandler"

Application -> Service: open(config)
Application -> Service: writeText("AT+PING\\n")
Service --> Application: CDCResult

Application -> Service: readFrame(out frame)
Service --> Application: CDCFrame

Application -> Service: pollAsync(handler, 100)
Service -> Task: runTask(callback)
Task -> Handler: callback(frame)

@enduml
```
