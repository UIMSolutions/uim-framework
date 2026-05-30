# UIM-WEBDAV UML Description

## Overview

The UIM-WEBDAV library provides a compact architecture for WebDAV resource workflows in D. It combines typed contracts, parser helpers, result model constructors, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml WEBDAV_Core

enum WebDAVSecurity {
  none
  tls
}

struct WebDAVConfig {
  + baseUrl: string
  + security: WebDAVSecurity
  + username: string
  + password: string
}

struct WebDAVResource {
  + href: string
  + collection: bool
  + contentLength: ulong
  + contentType: string
  + etag: string
  + lastModified: string
}

struct WebDAVResult {
  + success: bool
  + statusCode: ushort
  + message: string
}

interface IWebDAVService {
  + configure(config: WebDAVConfig): bool
  + list(path: string, depth: uint): WebDAVResource[]
  + get(path: string): string
  + put(path: string, content: string, contentType: string): WebDAVResult
  + mkcol(path: string): WebDAVResult
  + remove(path: string): WebDAVResult
  + listAsync(path: string, depth: uint, handler: WebDAVResourcesHandler): bool
  + putAsync(path: string, content: string, contentType: string, handler: WebDAVResultHandler): bool
}

class UIMWebDAVService

UIMWebDAVService ..|> IWebDAVService

@enduml
```

## Helper Layer

```plantuml
@startuml WEBDAV_Helpers

class ParserHelpers {
  + webdavParsePropfindResponse(xmlContent: string): WebDAVResource[]
}

UIMWebDAVService --> ParserHelpers : parse PROPFIND payload

@enduml
```

## Sequence

```plantuml
@startuml WEBDAV_Sequence

actor Application
participant Service as "UIMWebDAVService"
participant Parser as "ParserHelpers"
participant Task as "vibe.d runTask"
participant Handler as "WebDAVResourcesHandler"

Application -> Service: configure(webdavConfig)
Application -> Service: list("/docs/", 1)
Service --> Application: WebDAVResource[]

Application -> Service: put("/docs/readme.txt", content, "text/plain")
Service --> Application: WebDAVResult

Application -> Service: listAsync("/docs/", 1, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(resources)

Application -> Service: parsePropfindResponse(xml)
Service -> Parser: parse xml
Parser --> Service: resources
Service --> Application: resources

@enduml
```
