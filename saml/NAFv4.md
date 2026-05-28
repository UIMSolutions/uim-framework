# NAFv4 — uim-saml

Architecture description of the **uim-saml** library according to the NATO Architecture Framework version 4 (NAFv4).

---

## AV — Architecture Vision

### AV-1 Overview and Summary Information

| Field | Value |
|---|---|
| Architecture name | uim-saml |
| Version | 1.0.0 |
| Owner | UI-Manufaktur UG |
| Date | 2026 |
| Purpose | Provide SAML 2.0 Web Browser SSO and Single Logout capability as a reusable D / vibe.d library |
| Scope | Service Provider (SP) and Identity Provider (IdP) roles; HTTP-POST and HTTP-Redirect bindings |
| Standards | SAML 2.0 Core (OASIS), SAML 2.0 Bindings, Web Browser SSO Profile, Single Logout Profile |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| Assertion | A set of statements about a subject made by an IdP (authentication, attributes, authorisation) |
| ACS URL | Assertion Consumer Service URL — the SP endpoint that receives the `SAMLResponse` |
| AuthnRequest | Message sent by an SP to an IdP requesting authentication of a user |
| Binding | Mechanism for transporting SAML messages (HTTP-POST, HTTP-Redirect, SOAP, …) |
| Entity ID | Globally unique URI identifying a SAML entity (SP or IdP) |
| HTTP-POST Binding | Sends SAML messages as base64-encoded form parameters in an HTML form POST |
| HTTP-Redirect Binding | Sends SAML messages as raw-DEFLATE-compressed, base64url-encoded query parameters |
| IdP | Identity Provider — authenticates users and issues SAML assertions |
| NameID | An identifier for the authenticated principal (persistent, transient, email, …) |
| Relying Party | See SP |
| SLO | Single Logout — coordinated logout from all SPs in a federation |
| SP | Service Provider — consumes assertions produced by an IdP |
| SSO | Single Sign-On — log in once, access multiple SPs |

---

## CV — Capability Viewpoint

### CV-1 Capability Taxonomy

```
SAML 2.0 Library (uim-saml)
├── Authentication Capability
│   ├── AuthnRequest generation (SP)
│   ├── AuthnRequest parsing    (IdP)
│   ├── Response generation     (IdP)
│   └── Response parsing + validation (SP)
├── Message Transport Capability
│   ├── HTTP-POST binding
│   └── HTTP-Redirect binding (DEFLATE + Base64URL)
├── Session Management Capability
│   ├── LogoutRequest  generation + parsing
│   └── LogoutResponse generation + parsing
└── Identity Attribute Capability
    ├── NameID formats (persistent, transient, email, unspecified)
    └── Attribute statements (name, nameFormat, values)
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| HTTP-Redirect binding | DEFLATE compression (`std.zlib`), Base64URL encoding (`std.base64`) |
| HTTP-POST binding | Standard Base64 encoding (`std.base64`) |
| Assertion validation | Time window check (`uim.saml.helpers.time`), audience restriction check |
| ID generation | UUID generation (`std.uuid`) |

---

## OV — Operational Viewpoint

### OV-2 Operational Node Connectivity

```
[Browser / User Agent]
       │
       │ HTTP GET /protected
       ▼
[Service Provider — UIMSamlServiceProvider]
       │
       │ 302 Redirect  ?SAMLRequest=<deflated+b64url>
       ▼
[Identity Provider — UIMSamlIdentityProvider]
       │
       │ POST /acs  SAMLResponse=<b64>
       ▼
[Service Provider — UIMSamlServiceProvider]
       │
       │ validateResponse()
       ▼
[Application]
```

### OV-5a Operational Activity Decomposition

**SP Operations**
1. `buildAuthnRequest` — create request with unique ID, issueInstant, issuer, ACS URL
2. `buildAuthnRequestXml` — serialise to XML string
3. `buildAuthnRequestPostParam` — base64-encode for HTTP-POST
4. `buildAuthnRequestRedirectUrl` — DEFLATE + base64url + percent-encode for HTTP-Redirect
5. `parseResponse` — deserialise XML `<samlp:Response>` + `<saml:Assertion>`
6. `validateResponse` — check status, audience, time window, recipient
7. `buildLogoutRequest` — create SLO request
8. `parseLogoutResponse` — deserialise `<samlp:LogoutResponse>`

**IdP Operations**
1. `parseAuthnRequest` — deserialise incoming SP request
2. `buildResponse` — wrap assertion in `<samlp:Response>`
3. `buildResponseXml` — serialise to XML
4. `buildLogoutResponse` — create SLO response
5. `buildLogoutResponseXml` — serialise to XML

---

## SV — System Viewpoint

### SV-1 System Interface Description

```
uim.saml.provider
    │
    ├── uses → uim.saml.message  (factory functions)
    ├── uses → uim.saml.helpers.xml       (XML escape + extraction)
    ├── uses → uim.saml.helpers.encoding  (Base64/DEFLATE/URL)
    ├── uses → uim.saml.helpers.time      (SAML instants)
    └── uses → uim.saml.interfaces.types  (structs, interfaces)

uim.saml
    ├── re-exports → uim.core, uim.oop
    ├── re-exports → uim.saml.helpers
    ├── re-exports → uim.saml.interfaces
    ├── re-exports → uim.saml.message
    └── re-exports → uim.saml.provider
```

### SV-2 Systems Communication Description

| Interface | Protocol / Format |
|---|---|
| SP → IdP (redirect) | HTTP 302 with `?SAMLRequest=` query parameter (raw DEFLATE + Base64URL) |
| SP → IdP (POST) | HTTP POST with `SAMLRequest` form field (Base64 standard) |
| IdP → SP (POST) | HTTP POST with `SAMLResponse` form field (Base64 standard) |
| IdP → SP (redirect) | HTTP 302 with `?SAMLResponse=` query parameter |

### SV-4 Systems Functionality Description

**`uim.saml.helpers.encoding`**
- `samlDeflate(ubyte[])` — zlib compress, strip 2-byte header + 4-byte Adler-32 → raw DEFLATE
- `samlInflate(ubyte[])` — raw inflate (`winbits=-15`)
- `samlBase64Encode/Decode` — standard Base64 (HTTP-POST)
- `samlBase64UrlEncode/Decode` — URL-safe Base64 no-pad (HTTP-Redirect)
- `samlUrlEncode(string)` — RFC 3986 percent-encoding

**`uim.saml.helpers.xml`**
- `samlXmlEscapeAttr/Text` — XML 1.0 character escaping
- `samlXmlTextContent(xml, localName)` — extract text of first matching element
- `samlXmlAttrValue(xml, localName, attrName)` — extract attribute value
- `samlXmlElements(xml, localName)` — collect all matching element outer XML strings

**`uim.saml.helpers.time`**
- `samlNow()` — UTC ISO 8601 instant
- `samlFutureDateTime(int)` — instant N seconds from now
- `samlWithinWindow(notBefore, notOnOrAfter, tolerance)` — validate assertion time window

---

## TV — Technical Standards Viewpoint

### TV-1 Technical Standards Profile

| Standard | Version | Application |
|---|---|---|
| SAML Core | OASIS SSTC 2005 | Message syntax and semantics |
| SAML Bindings | OASIS SSTC 2005 | HTTP-POST and HTTP-Redirect transport |
| SAML Web Browser SSO Profile | OASIS SSTC 2005 | SP-initiated SSO |
| SAML Single Logout Profile | OASIS SSTC 2005 | Coordinated logout |
| RFC 1951 (DEFLATE) | IETF 1996 | HTTP-Redirect SAMLRequest compression |
| RFC 4648 (Base64 / Base64URL) | IETF 2006 | Encoding of binary messages for HTTP transport |
| RFC 3986 (URI) | IETF 2005 | Percent-encoding of query parameters |
| XML 1.0 | W3C 2008 | XML serialisation |
| ISO 8601 | ISO 1988 | SAML instant format |
| D Programming Language | DMD 2.x | Implementation language |
| vibe.d | 0.10.x | Async I/O framework (indirect dependency) |
