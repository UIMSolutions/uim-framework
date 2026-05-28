/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-XMPP UML Description

## Overview
The UIM-XMPP library provides a compact architecture for building XMPP clients in D. It combines a typed stanza API, XML helpers, and an optional TCP transport adapter based on vibe-core networking.

## Core Types

```plantuml
@startuml XMPP_Core

enum XMPPStanzaKind {
  message
  presence
  iq
}

interface IXMPPStanza {
  + kind(): XMPPStanzaKind
  + id(): string
  + toJid(): string
  + fromJid(): string
  + stanzaType(): string
  + body(): string
  + payloadXml(): string
}

interface IXMPPClient {
  + connect(serverUrl: string, jid: string = "", password: string = ""): bool
  + disconnect(): bool
  + send(stanza: IXMPPStanza): bool
  + on(kind: XMPPStanzaKind, handler: XMPPStanzaHandler): bool
  + connected(): bool
  + jid(): string
}

class UIMXMPPStanza {
  - _kind: XMPPStanzaKind
  - _id: string
  - _toJid: string
  - _fromJid: string
  - _stanzaType: string
  - _body: string
  - _payloadXml: string
}

class UIMXMPPClient {
  - _connected: bool
  - _serverUrl: string
  - _jid: string
  - _handlers: XMPPStanzaHandler[][XMPPStanzaKind]
  - _transport: UIMXMPPTcpAdapter
}

UIMXMPPStanza ..|> IXMPPStanza
UIMXMPPClient ..|> IXMPPClient

@enduml
```

## Transport Layer

```plantuml
@startuml XMPP_Transport

class UIMXMPPTcpAdapter {
  - _endpoint: XMPPEndpoint
  - _connection: TCPConnection
  + open(serverUrl: string): bool
  + close(): bool
  + sendRaw(data: string): bool
}

class XMPPXmlCodec {
  + xmppEncodeStanza(stanza: IXMPPStanza): string
  + xmppTryDecodeStanza(xml: string): (bool, IXMPPStanza)
}

UIMXMPPClient --> UIMXMPPTcpAdapter : optional usage
UIMXMPPTcpAdapter --> XMPPXmlCodec : sends encoded stanzas

@enduml
```

## Sequence

```plantuml
@startuml XMPP_Sequence

actor Application
participant Client as "UIMXMPPClient"
participant Codec as "xmppEncodeStanza"
participant Adapter as "UIMXMPPTcpAdapter"
participant Socket as "TCPConnection"

Application -> Client: connect("xmpp://localhost:5222", "alice@example.org")
Client -> Adapter: open(serverUrl)
Adapter -> Socket: connectTCP(host, port)
Socket --> Adapter: ok
Adapter --> Client: true
Client --> Application: true

Application -> Client: send(message stanza)
Client -> Codec: encode(stanza)
Codec --> Client: "<message ...>..."
Client -> Adapter: sendRaw(xml)
Adapter -> Socket: write(xml)

@enduml
```
