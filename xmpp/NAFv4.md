/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-XMPP

This document maps `uim-xmpp` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM XMPP Library |
| Version | 26.x |
| Date | 27 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d / vibe-core |
| Transport | TCP (XMPP), planned TLS/SASL extensions |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| XMPP | Extensible Messaging and Presence Protocol |
| JID | Jabber Identifier in bare/full form |
| Stanza | Core XMPP message unit (`message`, `presence`, `iq`) |
| IQ | Request/response style stanza for service interaction |
| Presence | Availability and subscription signaling stanza |
| Stream | Long-lived XML stream over TCP/TLS |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
XMPP Client Messaging
|- Session Management
|  |- Parse xmpp:// and xmpps:// endpoints
|  |- Open/close TCP channel
|- Stanza Modeling
|  |- message/presence/iq typing
|  |- JID and stanza metadata
|  |- body and payload xml handling
|- XML Processing
|  |- stanza xml encoding
|  |- basic stanza xml decoding
|- Async Dispatch
   |- Non-blocking handler execution via vibe.d tasks
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| TCP socket exchange | vibe.core.net `connectTCP` |
| Async stanza callbacks | vibe.d `runTask` |
| XML stanza interoperability | RFC 6120 stanza model subset |
| JID normalization | `uim.xmpp.helpers.jid` |

## OV - Operational View

### OV-1 Operational Concept

1. Application creates and connects an XMPP client with server URL and local JID.
2. The client optionally opens a TCP transport for remote stanza delivery.
3. Application builds stanzas (message/presence/iq) and sends them through the client.
4. XML codec serializes stanzas for transport and decodes inbound stanzas.
5. Matching handlers are dispatched asynchronously to application code.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Connect endpoint | server URL, jid | Open logical XMPP session |
| 2 | Register handlers | stanza kind, callback | Routing table |
| 3 | Build stanza | kind, JIDs, body/payload | Stanza object |
| 4 | Encode and send | stanza object | XML stanza over TCP |
| 5 | Decode inbound | raw XML stanza | typed stanza |
| 6 | Dispatch callback | typed stanza | async application handling |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
|  calls uim.xmpp API       |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.xmpp                  |
| - UIMXMPPClient           |
| - UIMXMPPStanza           |
| - XML codec               |
| - JID helpers             |
| - TCP adapter             |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe-core net             |
| - connectTCP              |
| - TCPConnection write/read|
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
|---|---|
| `uim.xmpp.interfaces.stanza` | Stanza contracts and kind typing |
| `uim.xmpp.interfaces.client` | Client contract and callback type |
| `uim.xmpp.stanza` | Concrete stanza implementation |
| `uim.xmpp.transport.xml_codec` | XML encode/decode helpers |
| `uim.xmpp.transport.tcp_adapter` | TCP endpoint adapter |
| `uim.xmpp.client` | Async client orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
|---|---|---|
| RFC 6120/6121 (subset) | XMPP Core/IM | Stanza shapes and semantics |
| D Language | 2.x | Implementation language |
| vibe.d / vibe-core | 0.10.x / 2.x | Async runtime and TCP networking |
| Apache License | 2.0 | Distribution and reuse |

### TV-2 Technical Roadmap

| Item | Status | Description |
|---|---|---|
| Typed stanza model | Implemented | message/presence/iq data contracts |
| XML stanza codec | Implemented | basic encode/decode for common stanzas |
| TCP adapter | Implemented | endpoint open/send/close |
| Stream negotiation | Planned | stream open/close lifecycle management |
| SASL/TLS | Planned | secure authentication and transport |

## L - Logical Model

### L-1 Logical Data Model

```text
UIMXMPPStanza
  |- kind: XMPPStanzaKind
  |- id: string
  |- toJid: string
  |- fromJid: string
  |- stanzaType: string
  |- body: string
  |- payloadXml: string

UIMXMPPClient
  |- serverUrl: string
  |- jid: string
  |- connected: bool
  |- transportEnabled: bool
  |- handlers: stanzaKind -> callbacks[]
```

### L-2 Constraints

- Empty server URLs are rejected.
- Sending stanzas requires an active connection.
- Stanza kind must map to one of message/presence/iq.
- JIDs are normalized to a trimmed representation for routing.
- XML helper parser handles common stanza shapes and is intentionally minimal.
