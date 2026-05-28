/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-CoAP

This document maps `uim-coap` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM CoAP Library |
| Version | 26.x |
| Date | 26 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d / vibe-core |
| Transport | UDP (CoAP), planned DTLS (CoAPS) |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| CoAP | Constrained Application Protocol for IoT devices |
| CON | Confirmable CoAP message type |
| ACK | Acknowledgement CoAP message type |
| Token | Request/response correlation identifier |
| Option | CoAP header extension entries (Uri-Path, Content-Format, etc.) |
| Message ID | 16-bit CoAP message identifier for reliability processing |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
CoAP Client Communication
|- Endpoint Management
|  |- Parse coap:// and coaps:// endpoints
|  |- Open/close UDP channel
|- Message Modeling
|  |- Type, code, message ID, token
|  |- Path and payload
|  |- Option collection
|- Packet Processing
|  |- CoAP binary encode
|  |- CoAP binary decode
|  |- Option delta/length handling
|- Async Request Flow
   |- Non-blocking callback dispatch
   |- Optional UDP transport routing
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| UDP datagram exchange | vibe.core.net `UDPConnection` |
| Async response callbacks | vibe.d `runTask` |
| Packet interoperability | RFC 7252 binary message format |
| Path mapping | CoAP Uri-Path option encoding |

## OV - Operational View

### OV-1 Operational Concept

1. Application creates and connects a CoAP client to a CoAP endpoint.
2. The client creates a request message with code, path, payload, token, and message ID.
3. The codec serializes the request into CoAP binary packet format.
4. UDP adapter transmits the datagram to the remote endpoint.
5. Responses are decoded and passed to application handlers asynchronously.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Connect endpoint | endpoint URL | Open logical CoAP session |
| 2 | Build request | method, path, payload | CoAP message object |
| 3 | Encode datagram | message object | binary packet |
| 4 | Send packet | binary packet | datagram over UDP |
| 5 | Receive packet | inbound datagram | response message |
| 6 | Dispatch callback | response | async application handling |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+--------------------------+
| Application Layer        |
|  calls uim.coap API      |
+------------+-------------+
             |
             v
+--------------------------+
| uim.coap                 |
| - UIMCoAPClient          |
| - UIMCoAPMessage         |
| - CoAP packet codec      |
| - UDP adapter            |
+------------+-------------+
             |
             v
+--------------------------+
| vibe-core net            |
| - listenUDP              |
| - UDPConnection send/recv|
+--------------------------+
```

### SV-4 Function Mapping

| Module | Function |
|---|---|
| `uim.coap.interfaces.message` | Message contracts and protocol enums |
| `uim.coap.interfaces.client` | Client contract and callback type |
| `uim.coap.message` | Concrete CoAP message implementation |
| `uim.coap.transport.codec` | Packet encoder/decoder |
| `uim.coap.transport.udp_adapter` | UDP endpoint adapter |
| `uim.coap.client` | Async client orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
|---|---|---|
| RFC 7252 | CoAP | Binary packet framing and semantics |
| D Language | 2.x | Implementation language |
| vibe.d / vibe-core | 0.10.x / 2.x | Async runtime and UDP networking |
| Apache License | 2.0 | Distribution and reuse |

### TV-2 Technical Roadmap

| Item | Status | Description |
|---|---|---|
| Basic CoAP codec | Implemented | Header/token/options/payload support |
| UDP adapter | Implemented | Endpoint open/send/receive |
| Retransmission logic | Planned | CON retransmit/backoff support |
| Observe support | Planned | Server push notifications |
| DTLS security | Planned | CoAPS with secure transport |

## L - Logical Model

### L-1 Logical Data Model

```text
UIMCoAPMessage
  |- type: CoAPType
  |- code: CoAPCode
  |- messageId: ushort
  |- token: ubyte[]
  |- path: string
  |- options: CoAPOption[]
  |- payload: ubyte[]

UIMCoAPClient
  |- endpoint: string
  |- connected: bool
  |- transportEnabled: bool
  |- transport: UIMCoAPUdpAdapter
```

### L-2 Constraints

- Token length is limited to 0..8 bytes.
- CoAP version 1 packet parsing is enforced.
- Request path must be non-empty for request operations.
- UDP transport usage is optional and gracefully degrades if unavailable.
