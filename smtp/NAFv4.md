# NAF v4 Architecture - UIM-SMTP

This document maps uim-smtp capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM SMTP Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | SMTP message composition and orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| SMTP Service | Service that validates, composes, and sends SMTP messages |
| SMTP Message | Typed email object containing sender, recipients, and body content |
| SMTP Response | Parsed SMTP server response line with code and continuation flag |
| Transport Delegate | Injectable function that executes concrete SMTP delivery |
| Async Send | Non-blocking message send callback dispatched via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
SMTP Integration Capability
|- Message Modeling
|  |- sender and recipient collections
|  |- subject, text body, html body
|- Message Composition
|  |- SMTP header generation
|  |- MIME plain or multipart assembly
|- Validation and Parsing
|  |- email format checks
|  |- SMTP response line parsing
|- Delivery Orchestration
   |- synchronous send result
   |- asynchronous send callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async send callbacks | vibe.d runTask |
| Header/body composition | codec helper functions |
| Address validation | regex-based email checker |
| Delivery execution | optional transport delegate |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures SMTP server details in the service.
2. Application builds a typed SMTP message.
3. Service validates sender/recipient addresses and message body.
4. Service composes SMTP/MIME payload.
5. Service returns send result immediately or through async callback.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | SMTPServerConfig | ready-to-send service state |
| 2 | Validate message | ISMTPMessage | valid/invalid status |
| 3 | Compose payload | ISMTPMessage | SMTP DATA payload |
| 4 | Execute transport | config + payload | SMTPResult |
| 5 | Parse response | SMTP response line | SMTPResponse |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - business notifications  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.smtp                  |
| - interfaces              |
| - models                  |
| - codec helpers           |
| - service orchestration   |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask callback engine |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.smtp.interfaces.message | SMTP contracts, enums, and value types |
| uim.smtp.models.message | concrete SMTP message model |
| uim.smtp.helpers.codec | parsing/normalization/address helpers |
| uim.smtp.service | compose, parse, send, and async orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| SMTP | RFC 5321 | server command/response model |
| MIME | RFC 2045/2046 | body content structure |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed message and config model | Implemented | sender/recipients/body/config DTOs |
| MIME composition | Implemented | plain and multipart/alternative output |
| SMTP response parser | Implemented | 3-digit code and continuation parsing |
| Async send API | Implemented | callback-based orchestration |
| Socket/TLS transport | Planned | direct SMTP client handshake and AUTH support |

## L - Logical Model

### L-1 Logical Data Model

```text
SMTPServerConfig
  |- host: string
  |- port: ushort
  |- security: SMTPSecurity
  |- authMode: SMTPAuthMode
  |- username: string
  |- password: string

ISMTPMessage
  |- from: SMTPAddress
  |- to: SMTPAddress[]
  |- cc: SMTPAddress[]
  |- bcc: SMTPAddress[]
  |- subject: string
  |- textBody: string
  |- htmlBody: string

SMTPResult
  |- success: bool
  |- code: ushort
  |- message: string
  |- transactionId: string
```

### L-2 Constraints

- A valid message requires a sender, at least one recipient, and at least one body representation.
- `Bcc` recipients are not emitted in message headers.
- Response parsing requires a 3-digit numeric prefix.
- Async callback invocation is exception-isolated.
