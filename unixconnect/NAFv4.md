# NAF v4 Architecture - UIM-UNIXCONNECT

This document maps uim-unixconnect capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM UNIX-CONNECT Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | UNIX domain socket style inter-process messaging |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| UNIX-CONNECT | Connection model using UNIX socket paths for IPC |
| Session | Logical connection context bound to a socket path |
| Channel | Named route for message distribution |
| Stream Socket | Connection-oriented message transport |
| Datagram Socket | Connectionless message transport |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
UNIX IPC Messaging
|- Session Management
|  |- create session from socket path
|  |- track connected/disconnected state
|- Channel Routing
|  |- normalize channel identifiers
|  |- subscribe and unsubscribe handlers
|- Message Dispatch
|  |- send message to channel subscribers
|  |- async callback scheduling with runTask
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async callbacks | vibe.d runTask |
| Session registry | in-memory dictionary storage |
| Route normalization | unixconnect helper functions |
| Message contracts | unixconnect interface definitions |

## OV - Operational View

### OV-1 Operational Concept

1. Application opens a UNIX-CONNECT session using a socket path.
2. Application subscribes handlers to channels.
3. Application sends channel messages associated with a valid session.
4. Service dispatches messages asynchronously to subscribed handlers.
5. Session can be disconnected and removed from active registry.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Connect session | socket path + socket type | active session |
| 2 | Subscribe channel | channel + handler | routing table entry |
| 3 | Send message | session id + channel + payload | routed message |
| 4 | Dispatch callback | message + handlers | async callback execution |
| 5 | Disconnect session | session id | inactive session |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - IPC-enabled components  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.unixconnect           |
| - interfaces              |
| - session model           |
| - channel helper          |
| - service dispatch logic  |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask scheduler       |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.unixconnect.interfaces.session | Session/service contracts and message struct |
| uim.unixconnect.helpers.channel | Channel normalization logic |
| uim.unixconnect.models.session | Concrete session implementation |
| uim.unixconnect.service | Session lifecycle and async routing orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | asynchronous dispatch |
| UNIX Domain Socket Pattern | common IPC pattern | local process communication model |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Session model | Implemented | Socket path/type and metadata |
| Channel routing | Implemented | Subscribe/unsubscribe and normalization |
| Async send dispatch | Implemented | Callback delivery via runTask |
| Real socket adapter | Planned | Direct UNIX socket transport integration |
| Access control hooks | Planned | Policy checks for channels/sessions |

## L - Logical Model

### L-1 Logical Data Model

```text
IUnixConnectSession
  |- id: string
  |- socketPath: string
  |- socketType: UnixConnectSocketType
  |- connected: bool
  |- metadata: string[string]

UnixConnectMessage
  |- sessionId: string
  |- channel: string
  |- payload: string
  |- headers: string[string]
```

### L-2 Constraints

* Send operations require an active, connected session.
* Channels are normalized prior to subscription and send routing.
* Handlers are invoked asynchronously and exception-isolated.
* Session IDs are unique within the active service instance.
