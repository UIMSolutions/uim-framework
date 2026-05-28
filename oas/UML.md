# UIM-OAS UML Description

## Overview

The UIM-OAS library provides a compact architecture for parsing and querying OpenAPI Specification content in D applications using vibe.d asynchronous patterns.

## Core Types

```plantuml
@startuml OAS_Core

enum OASVersion {
  v20
  v30
  v31
  unknown
}

struct OASEndpoint {
  + path: string
  + method: string
  + summary: string
}

interface IOASDocument {
  + raw(): string
  + version(): OASVersion
  + title(): string
  + documentVersion(): string
  + endpoints(): OASEndpoint[]
  + isValid(): bool
}

interface IOASService {
  + parse(source: string): IOASDocument
  + validate(document: IOASDocument): bool
  + findByMethod(document: IOASDocument, method: string): OASEndpoint[]
  + parseAsync(source: string, handler: OASDocumentHandler): bool
}

class UIMOASDocument
class UIMOASService

UIMOASDocument ..|> IOASDocument
UIMOASService ..|> IOASService
UIMOASService --> UIMOASDocument : builds

@enduml
```

## Helper Layer

```plantuml
@startuml OAS_Helpers

class ParserHelpers {
  + oasDetectVersion(source: string): OASVersion
  + oasExtractTitle(source: string): string
  + oasExtractDocumentVersion(source: string): string
  + oasExtractEndpoints(source: string): OASEndpoint[]
}

UIMOASService --> ParserHelpers : parse source

@enduml
```

## Sequence

```plantuml
@startuml OAS_Sequence

actor Application
participant Service as "UIMOASService"
participant Task as "vibe.d runTask"
participant Handler as "OASDocumentHandler"

Application -> Service: parse(source)
Service --> Application: IOASDocument

Application -> Service: parseAsync(source, handler)
Service -> Task: runTask(callback)
Task -> Handler: on parsed document

@enduml
```
