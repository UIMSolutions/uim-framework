# UIM-OPENAPI UML Description

## Overview

The UIM-OPENAPI library provides a compact architecture to parse and query OpenAPI documents in D. It combines typed document models, lightweight parser helpers, and service-level orchestration with async callback support via vibe.d.

## Core Types

```plantuml
@startuml OpenAPI_Core

enum OpenAPIVersion {
  v20
  v30
  v31
  unknown
}

struct OpenAPIOperation {
  + path: string
  + method: string
  + operationId: string
  + summary: string
}

interface IOpenAPIDocument {
  + raw(): string
  + version_(): OpenAPIVersion
  + title(): string
  + documentVersion(): string
  + servers(): string[]
  + operations(): OpenAPIOperation[]
  + isValid(): bool
}

interface IOpenAPIService {
  + parse(source: string): IOpenAPIDocument
  + validate(document: IOpenAPIDocument): bool
  + operationsByMethod(document: IOpenAPIDocument, method: string): OpenAPIOperation[]
  + operationsByPath(document: IOpenAPIDocument, path: string): OpenAPIOperation[]
  + parseAsync(source: string, handler: OpenAPIDocumentHandler): bool
}

class UIMOpenAPIDocument
class UIMOpenAPIService

UIMOpenAPIDocument ..|> IOpenAPIDocument
UIMOpenAPIService ..|> IOpenAPIService
UIMOpenAPIService --> UIMOpenAPIDocument : creates

@enduml
```

## Helper Layer

```plantuml
@startuml OpenAPI_Helpers

class ParserHelpers {
  + openapiDetectVersion(source: string): OpenAPIVersion
  + openapiExtractTitle(source: string): string
  + openapiExtractDocumentVersion(source: string): string
  + openapiExtractServers(source: string): string[]
  + openapiExtractOperations(source: string): OpenAPIOperation[]
}

UIMOpenAPIService --> ParserHelpers : parse document

@enduml
```

## Sequence

```plantuml
@startuml OpenAPI_Sequence

actor Application
participant Service as "UIMOpenAPIService"
participant Parser as "ParserHelpers"
participant Task as "vibe.d runTask"
participant Handler as "OpenAPIDocumentHandler"

Application -> Service: parse(source)
Service -> Parser: extract metadata + operations
Service --> Application: IOpenAPIDocument

Application -> Service: parseAsync(source, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(document)

@enduml
```
