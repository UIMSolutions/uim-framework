/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-LDAP

This document maps `uim-ldap` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM LDAP Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d / vibe-core TCP |
| Protocol | LDAP v3 (RFC 4511), Filters (RFC 4515), DN (RFC 4514) |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| LDAP | Lightweight Directory Access Protocol (RFC 4511) |
| DN | Distinguished Name — unique identifier for a directory entry |
| RDN | Relative Distinguished Name — the leftmost component of a DN |
| BER | Basic Encoding Rules — binary encoding used for LDAP PDUs |
| PDU | Protocol Data Unit — a single LDAP message on the wire |
| Filter | RFC 4515 search filter expression used in SearchRequest |
| Bind | Authentication operation; establishes the identity for subsequent operations |
| Unbind | Terminates the LDAP session |
| Search | Directory query returning zero or more entries matching a filter |
| Add | Creates a new directory entry |
| Modify | Changes attributes of an existing directory entry |
| Delete | Removes a directory entry |
| ModifyDN | Renames or moves a directory entry |
| Compare | Tests whether an entry contains a given attribute value |
| TLS | Transport Layer Security — encrypted channel over port 636 (LDAPS) |
| LdapResultCode | Enumerated LDAP result status as defined in RFC 4511 §4.1.9 |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
LDAP Client Operations
|- Connection Management
|  |- Establish TCP connection (vibe.d)
|  |- Optional TLS upgrade (LDAPS)
|  |- Graceful disconnect with Unbind notice
|- Authentication
|  |- Anonymous bind
|  |- Simple bind (DN + password)
|- Directory Operations
|  |- Search (base, one-level, whole subtree)
|  |- Add entry
|  |- Modify attributes (add, replace, delete values)
|  |- Delete entry
|  |- Rename / move entry (ModifyDN)
|  |- Compare attribute value
|- Filter Construction (RFC 4515)
|  |- Equality, presence, substring filters
|  |- Greater-or-equal, less-or-equal, approximate-match
|  |- Boolean operators: AND, OR, NOT
|  |- Value escaping
|- DN Utilities (RFC 4514)
|  |- Normalize DN
|  |- Build DN from RDN components
|  |- Extract RDN and parent DN
|  |- Hierarchical containment check
|- BER Encoding Helpers
|  |- Short and long-form length encoding
|  |- BER length decoding with consumed-bytes tracking
|  |- Hex encode/decode for diagnostic output
|- Message Factories
   |- Typed request constructors
   |- Typed result constructors
   |- Attribute / modification helpers
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| TCP transport | vibe.d `connectTCP` / `TCPConnection` |
| Async task dispatch | vibe.d `runTask` (optional, caller-controlled) |
| Protocol framing | BER definite-length encoding (RFC 5280 / X.690) |
| Filter safety | RFC 4515 special-character escaping |
| DN normalization | RFC 4514 component whitespace rules |

## OV - Operational View

### OV-1 Operational Concept

1. An application creates an `ILdapConnection` via `LdapConnection(host, port)` or `LdapsConnection(host)`.
2. The application calls `connect()` to establish the TCP channel to the LDAP server.
3. The application calls `bind(LdapBind(dn, password))` to authenticate.
4. Directory operations (search, add, modify, delete, modifyDN, compare) are invoked with typed request structs.
5. Each operation encodes a BER/ASN.1 LDAPMessage PDU, transmits it via the vibe.d TCP stream, reads the server response, and decodes it into a typed result struct.
6. Search responses iterate over `SearchResultEntry` PDUs until `SearchResultDone` is received.
7. The application calls `disconnect()` to send an `UnbindRequest` and close the TCP connection.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Create connection object | host, port, TLS flag | `ILdapConnection` instance |
| 2 | Connect | hostname, port | `bool` (success/failure) |
| 3 | Bind | `LdapBindRequest` | `LdapResult` |
| 4 | Build filter | attribute names and values | RFC 4515 filter string |
| 5 | Create search request | base DN, filter, scope | `LdapSearchRequest` |
| 6 | Execute search | `LdapSearchRequest` | `LdapSearchResult` |
| 7 | Process entries | `LdapEntry[]` | application-specific output |
| 8 | Modify / Add / Delete | typed request struct | `LdapResult` |
| 9 | Disconnect | — | TCP connection closed |

### OV-6 Operational Rules

| Rule | Description |
|---|---|
| R-1 | All DNs are normalized (whitespace stripped around `,` separators) before transmission. |
| R-2 | Filter values are RFC 4515-escaped before embedding in filter strings. |
| R-3 | A Bind operation must succeed before directory modification operations are attempted. |
| R-4 | UnbindRequest is sent as a best-effort notice before TCP close. |
| R-5 | Message IDs are monotonically increasing integers per connection lifetime. |
| R-6 | `LdapResultCode.success` (0) indicates operation succeeded; all other codes indicate an error or informational state. |

## SV - Systems View

### SV-1 Systems Interface Description

```text
Application Layer
      │
      │  ILdapConnection (D interface)
      ▼
UIMGrpcUnaryChannelLdapConnection
      │
      │  vibe.d TCPConnection
      ▼
LDAP Server (OpenLDAP, Active Directory, 389 DS, etc.)
      │
      │  LDAP v3 protocol (RFC 4511)
      │  Port 389 (plain) / 636 (LDAPS)
      ▼
X.500 Directory Information Tree
```

### SV-2 Systems Communication Description

| Link | Protocol | Port | Security |
|---|---|---|---|
| Application ↔ Connection class | D function calls | — | in-process |
| Connection class ↔ LDAP server | LDAP v3 / BER | 389 | none (StartTLS optional) |
| Connection class ↔ LDAP server (TLS) | LDAPS / BER over TLS | 636 | TLS 1.2+ |

### SV-4 Systems Functionality Description

| System | Functions |
|---|---|
| `uim.ldap.interfaces.types` | Define all protocol enums, request/response structs, `ILdapConnection` |
| `uim.ldap.helpers.dn` | RFC 4514 DN parse, normalize, build, hierarchy queries |
| `uim.ldap.helpers.filter` | RFC 4515 filter composition and value escaping |
| `uim.ldap.helpers.encoding` | BER length codec, hex encode/decode |
| `uim.ldap.message` | Factory functions for all request, result, attribute objects |
| `uim.ldap.connection` | TCP-backed `ILdapConnection` with BER/ASN.1 PDU encode/decode |

## TV - Technical Standards View

### TV-1 Technical Standards Profile

| Standard | Applicability |
|---|---|
| RFC 4511 | LDAP v3 protocol — message format and operations |
| RFC 4512 | LDAP directory information models |
| RFC 4513 | LDAP authentication methods and security mechanisms |
| RFC 4514 | String representation of Distinguished Names |
| RFC 4515 | String representation of LDAP search filters |
| RFC 4516 | LDAP Uniform Resource Identifier |
| X.690 / BER | ASN.1 Basic Encoding Rules used for PDU framing |
| TLS 1.2+ | Transport security for LDAPS (RFC 5246 / RFC 8446) |

### TV-2 Forecast Standards

| Standard | Direction |
|---|---|
| SASL (RFC 4422) | Future: GSSAPI / Kerberos bind support |
| LDAP Controls (RFC 4511 §4.1.11) | Future: paged results, sort control |
| StartTLS (RFC 4511 §4.14) | Future: in-band TLS upgrade on port 389 |
| RFC 4533 | Future: content synchronization (LDAP sync replication) |
