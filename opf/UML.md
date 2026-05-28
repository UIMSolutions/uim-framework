# UIM-OPF UML Description

## Overview

The UIM-OPF library provides a compact architecture for working with Open Logistics Foundation API domains in D. It combines typed logistics resources, API request abstractions, and asynchronous callback dispatch.

## Core Types

```plantuml
@startuml OPF_Core

enum OPFResourceType {
  order
  transport
  warehouse
  shipment
  document
  inventory
  custom
}

enum OPFHttpMethod {
  get
  post
  put
  patch
  delete_
}

struct OPFApiResponse {
  + statusCode: ushort
  + body: string
  + headers: string[string]
}

interface IOPFResource {
  + id(): string
  + resourceType(): OPFResourceType
  + status(): string
  + payload(): string
  + metadata(): string[string]
  + isValid(): bool
}

interface IOPFService {
  + connect(baseUrl: string): bool
  + disconnect(): bool
  + upsertResource(resource: IOPFResource): bool
  + resourceById(resourceId: string): IOPFResource
  + resourcesByType(value: OPFResourceType): IOPFResource[]
  + request(method: OPFHttpMethod, path: string, body: string, headers: string[string]): OPFApiResponse
  + requestAsync(method: OPFHttpMethod, path: string, handler: OPFResponseHandler, body: string, headers: string[string]): bool
}

class UIMOPFResource
class UIMOPFService

UIMOPFResource ..|> IOPFResource
UIMOPFService ..|> IOPFService
UIMOPFService --> UIMOPFResource : stores

@enduml
```

## Helper Layer

```plantuml
@startuml OPF_Helpers

class HttpHelpers {
  + opfMethodToString(method: OPFHttpMethod): string
  + opfNormalizePath(path: string): string
  + opfBuildUrl(baseUrl: string, path: string): string
}

UIMOPFService --> HttpHelpers : request composition

@enduml
```

## Sequence

```plantuml
@startuml OPF_Sequence

actor Application
participant Service as "UIMOPFService"
participant Task as "vibe.d runTask"
participant Handler as "OPFResponseHandler"

Application -> Service: connect(baseUrl)
Application -> Service: upsertResource(order)
Application -> Service: request(GET, "/orders/ord-42")
Service --> Application: OPFApiResponse

Application -> Service: requestAsync(POST, "/orders", handler)
Service -> Task: runTask(callback)
Task -> Handler: on response

@enduml
```
