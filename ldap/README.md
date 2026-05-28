# Library uim-ldap

Updated on 28. May 2026

A lightweight LDAP client library for dlang built on top of vibe.d TCP primitives. The library provides typed request/response contracts for all common LDAP operations, RFC 4515-compliant filter construction helpers, Distinguished Name utilities, minimal BER encoding helpers, and a vibe.d TCP-backed connection class that implements the full `ILdapConnection` interface.

## Features

- Complete LDAP result code enumeration (`LdapResultCode` — RFC 4511 §4.1.9)
- Typed request structs: Bind, Search, Add, Modify, Delete, ModifyDN, Compare
- Typed response structs: `LdapResult`, `LdapSearchResult`, `LdapCompareResult`
- `LdapEntry` with case-insensitive attribute lookup (`attr()`, `firstAttr()`)
- RFC 4515 filter builder: equality, presence, substring, `AND`, `OR`, `NOT`, `>=`, `<=`, `~=`
- Distinguished Name helpers: normalize, build, RDN, parent, `isUnderBase`
- BER length encoding / decoding helpers (short and long form)
- Hex encode/decode helpers for binary data debugging
- `UIMGrpcUnaryChannelLdapConnection` — vibe.d TCP connection with full protocol encoding
- Factory functions: `LdapConnection()`, `LdapsConnection()`
- Full unit-test coverage for all helper and message modules

## Installation

Add this dependency to your `dub.sdl`:

```
dependency "uim-framework:ldap" version="*"
```

## Quick Start

```d
import uim.ldap;

void main() {
  auto conn = LdapConnection("ldap.example.com", 389);

  if (!conn.connect()) {
    writeln("Connection failed");
    return;
  }

  // Bind
  auto bindResult = conn.bind(LdapBind("cn=admin,dc=example,dc=com", "secret"));
  if (!bindResult.success()) {
    writeln("Bind failed: ", bindResult.diagnosticMessage);
    conn.disconnect();
    return;
  }

  // Search
  auto searchResult = conn.search(LdapSearch(
    "dc=example,dc=com",
    ldapFilterEq("objectClass", "person"),
    ["cn", "mail", "uid"]
  ));

  foreach (entry; searchResult.entries) {
    writeln("DN: ", entry.dn, "  CN: ", entry.firstAttr("cn"));
  }

  // Add an entry
  auto addResult = conn.add(LdapAdd(
    "cn=Alice,ou=People,dc=example,dc=com",
    [
      LdapAttr("objectClass", ["top", "person", "inetOrgPerson"]),
      LdapAttr("cn",          ["Alice"]),
      LdapAttr("sn",          ["Smith"]),
      LdapAttr("mail",        ["alice@example.com"])
    ]
  ));

  // Modify
  auto modResult = conn.modify(LdapModify(
    "cn=Alice,ou=People,dc=example,dc=com",
    [LdapReplaceAttr("mail", ["alice.smith@example.com"])]
  ));

  // Compare
  auto cmpResult = conn.compare(LdapCompare(
    "cn=Alice,ou=People,dc=example,dc=com", "cn", "Alice"
  ));
  writeln("Compare matched: ", cmpResult.matched);

  // Delete
  conn.remove(LdapDelete("cn=Alice,ou=People,dc=example,dc=com"));

  conn.disconnect();
}
```

## Modules

| Module | Purpose |
|---|---|
| `uim.ldap` | Package entry point and re-exports |
| `uim.ldap.interfaces.types` | Enums, structs, `ILdapConnection` interface |
| `uim.ldap.helpers.dn` | DN normalization, parsing and hierarchy helpers |
| `uim.ldap.helpers.filter` | RFC 4515 LDAP search filter builder |
| `uim.ldap.helpers.encoding` | BER length codec and hex utilities |
| `uim.ldap.message` | Request / result / attribute factory functions |
| `uim.ldap.connection` | vibe.d TCP-backed `ILdapConnection` implementation |

## Filter Builder Examples

```d
// Equality
ldapFilterEq("cn", "Alice")                     // (cn=Alice)

// Presence
ldapFilterPresent("mail")                       // (mail=*)

// Substring
ldapFilterContains("cn", "ali")                 // (cn=*ali*)
ldapFilterStartsWith("cn", "Ali")               // (cn=Ali*)

// Boolean
ldapFilterAnd(
  ldapFilterEq("objectClass", "person"),
  ldapFilterPresent("mail")
)                                               // (&(objectClass=person)(mail=*))

ldapFilterNot(ldapFilterEq("cn", "disabled"))   // (!(cn=disabled))
```

## DN Helpers

```d
ldapNormalizeDN("cn=Alice , dc=example , dc=com")
// → "cn=Alice,dc=example,dc=com"

ldapRDN("cn=Alice,dc=example,dc=com")           // "cn=Alice"
ldapParentDN("cn=Alice,dc=example,dc=com")      // "dc=example,dc=com"

ldapIsUnderBase(
  "cn=Alice,dc=example,dc=com",
  "dc=example,dc=com"
)  // true
```

## Notes

- TLS/StartTLS support (`useTLS = true`) records the flag; full TLS upgrade using vibe-tls requires `vibe.tls` integration at the application layer.
- For high-volume directory operations, consider connection pooling at the application level.
- The BER/ASN.1 PDU encoder covers all RFC 4511 operations. A complete, externally-verified ASN.1 codec can be substituted by replacing the encoder/decoder methods in `UIMGrpcUnaryChannelLdapConnection`.

## License

Apache-2.0
