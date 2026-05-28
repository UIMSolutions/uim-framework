/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-LDAP UML Description

## Overview

The `uim-ldap` library is structured around a clean separation between protocol contracts (`interfaces`), utility helpers (`helpers`), factory functions (`message`), and the vibe.d TCP connection (`connection`). All LDAP operations are exposed through the `ILdapConnection` interface so that mock/test implementations can substitute the real TCP connection easily.

---

## Core Type Model

```plantuml
@startuml LDAP_Types

enum LdapResultCode {
  success = 0
  operationsError = 1
  protocolError = 2
  timeLimitExceeded = 3
  sizeLimitExceeded = 4
  invalidCredentials = 49
  insufficientAccessRights = 50
  unavailable = 52
  noSuchObject = 32
  entryAlreadyExists = 68
  other = 80
  .. (full set: RFC 4511 §4.1.9) ..
}

enum LdapScope {
  baseObject = 0
  singleLevel = 1
  wholeSubtree = 2
}

enum LdapModifyOp {
  add_ = 0
  delete_ = 1
  replace = 2
}

struct LdapAttribute {
  + type: string
  + values: string[]
}

struct LdapEntry {
  + dn: string
  + attributes: LdapAttribute[]
  + attr(name: string): string[]
  + firstAttr(name: string): string
}

struct LdapModification {
  + operation: LdapModifyOp
  + modification: LdapAttribute
}

struct LdapResult {
  + resultCode: LdapResultCode
  + matchedDN: string
  + diagnosticMessage: string
  + success(): bool
}

struct LdapSearchResult {
  + result: LdapResult
  + entries: LdapEntry[]
}

struct LdapCompareResult {
  + result: LdapResult
  + matched: bool
}

@enduml
```

---

## Request Types

```plantuml
@startuml LDAP_Requests

struct LdapBindRequest {
  + dn: string
  + password: string
  + version_: int
}

struct LdapSearchRequest {
  + baseDN: string
  + scope_: LdapScope
  + derefAliases: LdapDerefAliases
  + sizeLimit: int
  + timeLimit: int
  + typesOnly: bool
  + filter: string
  + attributes: string[]
}

struct LdapAddRequest {
  + dn: string
  + attributes: LdapAttribute[]
}

struct LdapModifyRequest {
  + dn: string
  + changes: LdapModification[]
}

struct LdapDeleteRequest {
  + dn: string
}

struct LdapModifyDNRequest {
  + dn: string
  + newRDN: string
  + deleteOldRDN: bool
  + newSuperior: string
}

struct LdapCompareRequest {
  + dn: string
  + attributeType: string
  + assertionValue: string
}

@enduml
```

---

## Connection Interface and Implementation

```plantuml
@startuml LDAP_Connection

interface ILdapConnection {
  + connected(): bool
  + host(): string
  + port(): ushort
  + useTLS(): bool
  + connect(): bool
  + disconnect(): void
  + bind(request: LdapBindRequest): LdapResult
  + unbind(): LdapResult
  + search(request: LdapSearchRequest): LdapSearchResult
  + add(request: LdapAddRequest): LdapResult
  + modify(request: LdapModifyRequest): LdapResult
  + remove(request: LdapDeleteRequest): LdapResult
  + modifyDN(request: LdapModifyDNRequest): LdapResult
  + compare(request: LdapCompareRequest): LdapCompareResult
}

class UIMGrpcUnaryChannelLdapConnection {
  - _host: string
  - _port: ushort
  - _useTLS: bool
  - _tcp: TCPConnection
  - _connected: bool
  - _bound: bool
  - _messageId: int
  + connect(): bool
  + disconnect(): void
  + bind(...): LdapResult
  + unbind(): LdapResult
  + search(...): LdapSearchResult
  + add(...): LdapResult
  + modify(...): LdapResult
  + remove(...): LdapResult
  + modifyDN(...): LdapResult
  + compare(...): LdapCompareResult
  - _encodeBind(...): ubyte[]
  - _encodeSearch(...): ubyte[]
  - _encodeAdd(...): ubyte[]
  - _encodeModify(...): ubyte[]
  - _encodeDelete(...): ubyte[]
  - _encodeModifyDN(...): ubyte[]
  - _encodeCompare(...): ubyte[]
  - _encodeFilter(...): ubyte[]
  - _decodeResult(...): LdapResult
  - _decodeEntry(...): LdapEntry
  - _sendPDU(...): void
  - _receivePDU(): ubyte[]
}

UIMGrpcUnaryChannelLdapConnection ..|> ILdapConnection
UIMGrpcUnaryChannelLdapConnection --> "1" TCPConnection : uses (vibe.d)

@enduml
```

---

## Helper Layer

```plantuml
@startuml LDAP_Helpers

class DnHelpers << (M,#ADD1B2) module >> {
  + ldapNormalizeDN(dn: string): string
  + ldapBuildDN(rdns: string[]): string
  + ldapRDN(dn: string): string
  + ldapParentDN(dn: string): string
  + ldapIsUnderBase(child: string, base: string): bool
}

class FilterHelpers << (M,#ADD1B2) module >> {
  + ldapEscapeFilterValue(value: string): string
  + ldapFilterEq(type: string, value: string): string
  + ldapFilterPresent(type: string): string
  + ldapFilterContains(type: string, value: string): string
  + ldapFilterStartsWith(type: string, value: string): string
  + ldapFilterEndsWith(type: string, value: string): string
  + ldapFilterNot(inner: string): string
  + ldapFilterAnd(filters: string[]...): string
  + ldapFilterOr(filters: string[]...): string
  + ldapFilterGe(type: string, value: string): string
  + ldapFilterLe(type: string, value: string): string
  + ldapFilterApprox(type: string, value: string): string
}

class EncodingHelpers << (M,#ADD1B2) module >> {
  + berEncodeLength(length: size_t): ubyte[]
  + berDecodeLength(buf: ubyte[], consumed: out size_t): size_t
  + toHexString(data: ubyte[]): string
  + fromHexString(hex: string): ubyte[]
}

@enduml
```

---

## Message Factory Layer

```plantuml
@startuml LDAP_Message

class MessageFactories << (M,#FFD700) module >> {
  + LdapAnonBind(): LdapBindRequest
  + LdapBind(dn, password, version): LdapBindRequest
  + LdapSearch(baseDN, filter, attrs, scope, ...): LdapSearchRequest
  + LdapAdd(dn, attributes): LdapAddRequest
  + LdapDelete(dn): LdapDeleteRequest
  + LdapModify(dn, changes): LdapModifyRequest
  + LdapModifyDN(dn, newRDN, deleteOld, newSup): LdapModifyDNRequest
  + LdapCompare(dn, type, value): LdapCompareRequest
  + LdapSuccess(matchedDN, message): LdapResult
  + LdapFailure(code, message): LdapResult
  + LdapChange(op, type, values): LdapModification
  + LdapAddAttr(type, values): LdapModification
  + LdapReplaceAttr(type, values): LdapModification
  + LdapDeleteAttr(type, values): LdapModification
  + LdapAttr(type, values): LdapAttribute
}

@enduml
```

---

## Sequence: Bind and Search

```plantuml
@startuml LDAP_Sequence_Search

actor Application
participant "UIMGrpcUnaryChannelLdapConnection" as Conn
participant "vibe.d TCPConnection" as TCP
participant "LDAP Server" as Server

Application -> Conn : LdapConnection("ldap.example.com")
Application -> Conn : connect()
Conn -> TCP : connectTCP(host, port)
TCP -> Server : TCP handshake
Conn --> Application : true

Application -> Conn : bind(LdapBind("cn=admin,...", "secret"))
Conn -> Conn : _encodeBind() → BER PDU
Conn -> TCP : write(pdu)
TCP -> Server : BindRequest PDU
Server -> TCP : BindResponse PDU
TCP -> Conn : _receivePDU()
Conn -> Conn : _decodeResult()
Conn --> Application : LdapResult(success)

Application -> Conn : search(LdapSearch("dc=example,dc=com", "(cn=Alice)"))
Conn -> Conn : _encodeSearch() → BER PDU
Conn -> TCP : write(pdu)
TCP -> Server : SearchRequest PDU
Server -> TCP : SearchResultEntry × N
Server -> TCP : SearchResultDone
loop each SearchResultEntry
  TCP -> Conn : _receivePDU() [tag=0x64]
  Conn -> Conn : _decodeEntry()
end
TCP -> Conn : _receivePDU() [tag=0x65]
Conn -> Conn : _decodeResult()
Conn --> Application : LdapSearchResult(entries, result)

Application -> Conn : disconnect()
Conn -> TCP : _sendUnbindNotice()
Conn -> TCP : close()

@enduml
```
