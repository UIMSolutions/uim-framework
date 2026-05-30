# NAF v4 Architecture - UIM-IMAP

This document maps uim-imap capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM IMAP Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | IMAP mailbox access and message orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| IMAP Service | Service that orchestrates mailbox and message operations |
| Mailbox Info | State summary for a selected mailbox |
| Search IDs | UID list resulting from IMAP search criteria |
| Fetch Message | Retrieved message payload from IMAP FETCH |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
IMAP Integration Capability
|- Session Configuration
|  |- host, port, security, credentials
|- Mailbox Discovery
|  |- mailbox list parsing
|  |- mailbox selection state
|- Message Access
|  |- search by criteria
|  |- fetch by uid
|  |- delete/expunge workflow orchestration
|- Async Processing
   |- async select callback
   |- async fetch and delete callbacks
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| Response parsing | codec helper functions |
| Default integration mode | in-memory service providers |
| Real server communication | injected provider delegates |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures IMAP server and credentials.
2. Service lists mailboxes and selects a target mailbox.
3. Service performs search by requested criteria.
4. Service fetches messages by UID.
5. Service can delete messages and expose async callbacks.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | IMAPConfig | ready-to-query state |
| 2 | Discover mailboxes | LIST response or provider | IMAPMailboxInfo[] |
| 3 | Select mailbox | mailbox name | IMAPMailboxInfo |
| 4 | Search messages | mailbox + criteria | UID list |
| 5 | Fetch/Delete message | UID and mailbox | IMAPMessage / IMAPResult |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - mailbox processing      |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.imap                  |
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
| uim.imap.interfaces.mailbox | IMAP contracts, enums, and value types |
| uim.imap.models.mailbox | mailbox/message/result helper factories |
| uim.imap.helpers.codec | LIST/SEARCH/FETCH parsing helpers |
| uim.imap.service | list/select/search/fetch/delete orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| IMAP4rev1 | RFC 3501 | mailbox and message access semantics |
| STARTTLS for IMAP | RFC 2595 | optional secure session upgrade reference |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed IMAP model and service API | Implemented | mailbox, search, fetch, delete APIs |
| IMAP parser helper layer | Implemented | LIST/SEARCH/FETCH parsing |
| Async operations | Implemented | callback-based select/fetch/delete |
| In-memory provider defaults | Implemented | immediate integration without server |
| Full socket IMAP transport | Planned | LOGIN, SELECT, UID SEARCH/FETCH/STORE and EXPUNGE flow |

## L - Logical Model

### L-1 Logical Data Model

```text
IMAPConfig
  |- host: string
  |- port: ushort
  |- security: IMAPSecurity
  |- username: string
  |- password: string

IMAPMailboxInfo
  |- name: string
  |- messages: uint
  |- recent: uint
  |- unseen: uint

IMAPMessage
  |- uid: ulong
  |- headers: string
  |- body: string

IMAPResult
  |- success: bool
  |- message: string
```

### L-2 Constraints

- Service operations require configured host and non-zero port.
- Search/fetch/delete requires non-empty mailbox identifiers.
- Message uid must be greater than zero for fetch/delete operations.
- Async callback invocation is exception-isolated.
