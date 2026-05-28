/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-CoAP UML Description

## Overview
The UIM-CoAP library provides a compact architecture for building CoAP clients in D. It combines a typed message API, a binary packet codec, and a UDP transport adapter implemented with vibe-core networking.

## Core Types

```plantuml
@startuml COAP_Core

enum CoAPType {
  confirmable
  nonConfirmable
  acknowledgement
  reset
}

enum CoAPCode {
  empty
  get
  post
  put
  delete_
  content
  created
  changed
  deleted
}

interface ICoAPMessage {
  + type(): CoAPType
  + code(): CoAPCode
  + messageId(): ushort
  + token(): ubyte[]
  + path(): string
  + payload(): ubyte[]
  + options(): CoAPOption[]
}

interface ICoAPClient {
  + connect(endpointUrl: string): bool
  + disconnect(): bool
  + request(method: CoAPCode, path: string, payload: ubyte[], handler: CoAPResponseHandler): bool
  + connected(): bool
  + endpoint(): string
}

class UIMCoAPMessage {
  - _type: CoAPType
  - _code: CoAPCode
  - _messageId: ushort
  - _token: ubyte[]
  - _path: string
  - _payload: ubyte[]
  - _options: CoAPOption[]
}

class UIMCoAPClient {
  - _connected: bool
  - _endpoint: string
  - _transport: UIMCoAPUdpAdapter
  - _transportEnabled: bool
}

UIMCoAPMessage ..|> ICoAPMessage
UIMCoAPClient ..|> ICoAPClient

@enduml
```

## Transport Layer

```plantuml
@startuml COAP_Transport

class UIMCoAPUdpAdapter {
  - _endpoint: CoAPEndpoint
  - _socket: UDPConnection
  + open(endpointUrl: string): bool
  + close(): bool
  + send(message: ICoAPMessage): bool
  + receive(message: ICoAPMessage): bool
}

class CoAPCodec {
  + coapEncodeMessage(message: ICoAPMessage): ubyte[]
  + coapDecodeMessage(packet: ubyte[]): ICoAPMessage
}

UIMCoAPClient --> UIMCoAPUdpAdapter : optional usage
UIMCoAPUdpAdapter --> CoAPCodec : encodes/decodes packets

@enduml
```

## Sequence

```plantuml
@startuml COAP_Sequence

actor Application
participant Client as "UIMCoAPClient"
participant Adapter as "UIMCoAPUdpAdapter"
participant Codec as "coapEncodeMessage"
participant Socket as "UDPConnection"

Application -> Client: connect("coap://localhost:5683")
Client -> Adapter: open(endpoint)
Adapter -> Socket: listenUDP(0); connect(host, port)
Socket --> Adapter: ok
Adapter --> Client: true
Client --> Application: true

Application -> Client: request(GET, "/sensors/temp", payload)
Client -> Codec: encode(message)
Codec --> Client: packet
Client -> Adapter: send(message)
Adapter -> Socket: send(packet)

@enduml
```
