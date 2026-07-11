# UIM-SARIF UML Description

## Overview

The UIM-SARIF library provides a practical SARIF 2.1.0 model for D applications, with JSON round-tripping and a vibe.d-friendly service layer.

## Core Types

```plantuml
@startuml SARIF_Core

enum SarifVersion {
  unknown
  v2_1_0
}

struct SarifMessage {
  + text: string
  + markdown: string
  + id: string
}

struct SarifArtifactLocation {
  + uri: string
  + uriBaseId: string
  + description: string
}

struct SarifRegion {
  + startLine: size_t
  + startColumn: size_t
  + endLine: size_t
  + endColumn: size_t
}

struct SarifPhysicalLocation {
  + artifactLocation: SarifArtifactLocation
  + region: SarifRegion
}

struct SarifLocation {
  + id: string
  + message: string
  + physicalLocation: SarifPhysicalLocation
}

struct SarifReportingDescriptor {
  + id: string
  + name: string
  + shortDescription: SarifMessage
  + fullDescription: SarifMessage
  + helpUri: string
}

struct SarifToolComponent {
  + name: string
  + version_: string
  + semanticVersion: string
  + downloadUri: string
  + informationUri: string
  + fullName: string
  + language: string
  + rules: SarifReportingDescriptor[]
}

struct SarifTool {
  + driver: SarifToolComponent
}

struct SarifResult {
  + ruleId: string
  + level: string
  + kind: string
  + message: SarifMessage
  + locations: SarifLocation[]
}

struct SarifRun {
  + tool: SarifTool
  + results: SarifResult[]
}

struct SarifLog {
  + sarifVersion: SarifVersion
  + runs: SarifRun[]
  + toJsonString(): string
  + isValid(): bool
}

interface SarifDocumentHandler {
  + onDocument(document: SarifLog)
}

class SarifService {
  + parse(source: string): SarifLog
  + validate(document: SarifLog): bool
  + stringify(document: SarifLog): string
  + parseAsync(source: string, handler: SarifDocumentHandler): void
}

SarifTool --> SarifToolComponent : driver
SarifRun --> SarifTool : tool
SarifRun --> SarifResult : results
SarifResult --> SarifMessage : message
SarifResult --> SarifLocation : locations
SarifLocation --> SarifPhysicalLocation : physicalLocation
SarifPhysicalLocation --> SarifArtifactLocation : artifactLocation

@enduml
```

## Sequence

```plantuml
@startuml SARIF_Sequence

actor Application
participant Service as "SarifService"
participant Parser as "SarifLog.fromJsonString"
participant Task as "vibe.d runTask"
participant Handler as "SarifDocumentHandler"

Application -> Service: parse(source)
Service -> Parser: fromJsonString(source)
Parser --> Service: SarifLog
Service --> Application: SarifLog

Application -> Service: parseAsync(source, handler)
Service -> Task: runTask(callback)
Task -> Parser: parse source
Task -> Handler: invoke callback

@enduml
```
