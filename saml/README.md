# uim-saml

SAML 2.0 implementation for D / vibe.d — supports the Web Browser SSO Profile (HTTP-POST and HTTP-Redirect bindings) and the Single Logout Profile.

## Features

- **SAML 2.0 Web Browser SSO** — Service Provider and Identity Provider roles
- **HTTP-POST binding** — base64-encoded `SAMLRequest` / `SAMLResponse` in HTML forms
- **HTTP-Redirect binding** — raw-DEFLATE-compressed + base64url-encoded `SAMLRequest` in the query string
- **Single Logout (SLO)** — `LogoutRequest` / `LogoutResponse` for both bindings
- **Assertion validation** — status, audience restriction, `NotBefore` / `NotOnOrAfter` time window, `Recipient` URL
- **Pure XML serialisation/parsing** — no external XML library required; lightweight string-based helpers

## Quick Start

### Service Provider — SSO flow

```d
import uim.saml;

// Configure SP and IdP endpoints
auto spCfg = SamlSpConfig(
  "https://sp.example.com",             // entity ID
  "https://sp.example.com/acs",         // ACS URL
  "https://sp.example.com/slo"          // SLO URL
);
auto idpCfg = SamlIdpConfig(
  "https://idp.example.com",            // entity ID
  "https://idp.example.com/sso",        // SSO URL
  "https://idp.example.com/slo",        // SLO URL
  ""                                    // certificate (not validated here)
);

auto sp = SamlServiceProvider(spCfg, idpCfg);

// 1. Build an AuthnRequest and redirect the user
auto req = sp.buildAuthnRequest("https://idp.example.com/sso");
auto url = sp.buildAuthnRequestRedirectUrl(req, "https://idp.example.com/sso");
// res.redirect(url);

// 2. Receive and validate the SAMLResponse at the ACS endpoint
string responseXml = samlBase64DecodeString(req_body_SAMLResponse);
auto samlResp    = sp.parseResponse(responseXml);
auto validation  = sp.validateResponse(samlResp);
if (!validation.valid) {
  // Handle error: validation.error
}
// Access the authenticated user's name ID
string nameIdValue = samlResp.assertions[0].subject.nameId.value;
```

### Service Provider — POST binding

```d
// Build a form that auto-submits to the IdP
auto req       = sp.buildAuthnRequest("https://idp.example.com/sso");
auto samlParam = sp.buildAuthnRequestPostParam(req);
// Render: <form method="POST" action="https://idp.example.com/sso">
//           <input type="hidden" name="SAMLRequest" value="<samlParam>">
```

### Service Provider — Single Logout

```d
auto nameId     = SamlEmailNameID("alice@example.com");
auto logoutReq  = sp.buildLogoutRequest(nameId, "_session001");
auto logoutXml  = sp.buildLogoutRequestXml(logoutReq);
auto logoutUrl  = /* deflate + base64url + url-encode logoutXml, append to IdP SLO URL */;
```

### Identity Provider

```d
auto idp = SamlIdentityProvider("https://idp.example.com");

// Parse an incoming AuthnRequest from an SP
auto authnReq = idp.parseAuthnRequest(incomingXml);

// Build a success response
auto nameId    = SamlEmailNameID("alice@example.com");
auto attrs     = [SamlAttr("email", ["alice@example.com"]),
                  SamlAttr("groups", ["admin", "users"])];
auto assertion = SamlBuildAssertion(
  "https://idp.example.com",
  nameId,
  authnReq.assertionConsumerServiceUrl,
  authnReq.id,
  [authnReq.issuer],
  attrs
);
auto samlResp = idp.buildResponse(assertion, authnReq.assertionConsumerServiceUrl, authnReq.id);
auto respXml  = idp.buildResponseXml(samlResp);
// base64-encode and POST to SP ACS
```

## Module Structure

```
uim.saml
├── uim.saml.helpers
│   ├── xml        — samlXmlEscapeAttr/Text, samlXmlTextContent, samlXmlAttrValue, samlXmlElements
│   ├── encoding   — Base64, Base64URL, raw DEFLATE, URL-encoding
│   └── time       — samlNow(), samlFutureDateTime(), samlWithinWindow()
├── uim.saml.interfaces
│   └── types      — constants, enums, structs, ISamlServiceProvider, ISamlIdentityProvider
├── uim.saml.message   — factory functions (SamlBuildAuthnRequest, SamlBuildAssertion, …)
└── uim.saml.provider  — UIMSamlServiceProvider, UIMSamlIdentityProvider
```

## Dependencies

- `uim-framework:core`
- `uim-framework:oop`
- `vibe-d ~>0.10.3`
- Phobos `std.zlib`, `std.base64`, `std.uuid`, `std.datetime`

## SAML Bindings Supported

| Binding | Direction | Notes |
|---------|-----------|-------|
| HTTP-POST | SP → IdP (AuthnRequest) | `buildAuthnRequestPostParam` |
| HTTP-POST | IdP → SP (Response) | `buildResponseXml` |
| HTTP-Redirect | SP → IdP (AuthnRequest) | `buildAuthnRequestRedirectUrl` |
| HTTP-Redirect | SP → IdP (LogoutRequest) | `buildLogoutRequestXml` + manual compression |
| HTTP-POST | IdP → SP (LogoutResponse) | `buildLogoutResponseXml` |

## Limitations

- **No XML signature verification** — a production deployment must validate the `<ds:Signature>` element on assertions (out of scope for this library).
- **No encryption** — `<saml:EncryptedAssertion>` is not supported.
- Simple string-based XML parser — handles well-formed SAML documents; does not support all XML edge cases.
