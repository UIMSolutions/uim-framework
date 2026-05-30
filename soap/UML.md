# UIM-SOAP UML Description

## Overview

The UIM-SOAP library provides a compact architecture for SOAP workflows in D. It combines typed contracts, envelope helpers, model constructors, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml SOAP_Core

enum SOAPVersion {
  soap11
  soap12
}

struct SOAPConfig {
  + endpoint: string
  + soapAction: string
  + soapVersion: SOAPVersion
  + namespaceUri: string
  + strictMode: bool
  + timeoutMs: uint
}

struct SOAPHeader {
  + name: string
  + value: string
}

struct SOAPEnvelope {
  + operation: string
  + headers: SOAPHeader[]
  + bodyXml: string
  + rawXml: string
}

struct SOAPResult {
  + success: bool
  + statusCode: ushort
  + message: string
  + payload: string
}

interface ISOAPService {
  + configure(config: SOAPConfig): bool
  + buildEnvelope(operation: string, bodyXml: string, headers: SOAPHeader[]): SOAPEnvelope
  + parseEnvelope(xmlPayload: string): SOAPEnvelope
  + call(envelope: SOAPEnvelope): SOAPResult
  + parseEnvelopeAsync(xmlPayload: string, handler: SOAPEnvelopeHandler): bool
  + callAsync(envelope: SOAPEnvelope, handler: SOAPResultHandler): bool
}

class UIMSOAPService

UIMSOAPService ..|> ISOAPService

@enduml
```

## Helper Layer

```plantuml
@startuml SOAP_Helpers

class CodecHelpers {
  + soapVersionNamespace(version: SOAPVersion): string
  + soapBuildEnvelope(version: SOAPVersion, operation: string, bodyXml: string, headers: SOAPHeader[]): SOAPEnvelope
  + soapParseEnvelope(xmlPayload: string): SOAPEnvelope
}

UIMSOAPService --> CodecHelpers : build and parse envelope

@enduml
```

## Sequence

```plantuml
@startuml SOAP_Sequence

actor Application
participant Service as "UIMSOAPService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "SOAPResultHandler"

Application -> Service: configure(soapConfig)
Application -> Service: buildEnvelope(operation, bodyXml, headers)
Service -> Helpers: build XML envelope
Helpers --> Service: SOAPEnvelope
Service --> Application: SOAPEnvelope

Application -> Service: call(envelope)
Service --> Application: SOAPResult

Application -> Service: callAsync(envelope, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(result)

@enduml
```
