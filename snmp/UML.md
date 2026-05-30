# UIM-SNMP UML Description

## Overview

The UIM-SNMP library provides a compact architecture for SNMP workflows in D. It combines typed contracts, parser helpers, model constructors, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml SNMP_Core

enum SNMPVersion {
  v1
  v2c
  v3
}

enum SNMPSecurityLevel {
  noAuthNoPriv
  authNoPriv
  authPriv
}

struct SNMPConfig {
  + host: string
  + port: ushort
  + version: SNMPVersion
  + securityLevel: SNMPSecurityLevel
  + community: string
  + username: string
}

struct SNMPOidValue {
  + oid: string
  + typeTag: string
  + value: string
  + timestamp: long
}

struct SNMPResult {
  + success: bool
  + statusCode: ushort
  + message: string
}

interface ISNMPService {
  + configure(config: SNMPConfig): bool
  + get(oid: string): SNMPOidValue
  + walk(rootOid: string, maxRepetitions: uint): SNMPOidValue[]
  + set(oid: string, value: string, typeTag: string): SNMPResult
  + getAsync(oid: string, handler: SNMPOidValueHandler): bool
  + walkAsync(rootOid: string, maxRepetitions: uint, handler: SNMPOidValuesHandler): bool
  + setAsync(oid: string, value: string, typeTag: string, handler: SNMPResultHandler): bool
}

class UIMSNMPService

UIMSNMPService ..|> ISNMPService

@enduml
```

## Helper Layer

```plantuml
@startuml SNMP_Helpers

class CodecHelpers {
  + snmpParseOidLine(line: string, fallbackOid: string): SNMPOidValue
  + snmpParseWalkBlock(block: string, rootOid: string): SNMPOidValue[]
}

UIMSNMPService --> CodecHelpers : parse OID output

@enduml
```

## Sequence

```plantuml
@startuml SNMP_Sequence

actor Application
participant Service as "UIMSNMPService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "SNMPOidValueHandler"

Application -> Service: configure(snmpConfig)
Application -> Service: get("1.3.6.1.2.1.1.5.0")
Service --> Application: SNMPOidValue

Application -> Service: walk("1.3.6.1.2.1.1", 10)
Service --> Application: SNMPOidValue[]

Application -> Service: setAsync(oid, value, "STRING", handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(result)

Application -> Service: parseOidLine(rawLine)
Service -> Helpers: parse line
Helpers --> Service: SNMPOidValue
Service --> Application: SNMPOidValue

@enduml
```
