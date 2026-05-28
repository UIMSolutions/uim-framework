/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.saml.message;

import uim.saml;

mixin(ShowModule!());

@safe:

// ---------------------------------------------------------------------------
// ID generation
// ---------------------------------------------------------------------------

/// Generate a unique SAML message ID (NCName-safe: starts with '_')
string samlGenerateId() @trusted {
  import std.uuid : randomUUID;
  import std.string : replace;
  return "_" ~ randomUUID().toString().replace("-", "");
}

// ---------------------------------------------------------------------------
// NameID factories
// ---------------------------------------------------------------------------

SamlNameID SamlEmailNameID(string email) {
  SamlNameID n;
  n.value  = email;
  n.format = SAML_NAMEID_EMAIL;
  return n;
}

SamlNameID SamlPersistentNameID(string value, string spNameQualifier = "") {
  SamlNameID n;
  n.value            = value;
  n.format           = SAML_NAMEID_PERSISTENT;
  n.spNameQualifier  = spNameQualifier;
  return n;
}

SamlNameID SamlTransientNameID(string value = "") {
  SamlNameID n;
  n.value  = value.length ? value : samlGenerateId();
  n.format = SAML_NAMEID_TRANSIENT;
  return n;
}

// ---------------------------------------------------------------------------
// Attribute factories
// ---------------------------------------------------------------------------

SamlAttribute SamlAttr(string name, string[] values, string nameFormat = SAML_ATTRFMT_BASIC) {
  SamlAttribute a;
  a.name       = name;
  a.nameFormat = nameFormat;
  a.values     = values.dup;
  return a;
}

SamlAttribute SamlUriAttr(string name, string[] values) {
  return SamlAttr(name, values, SAML_ATTRFMT_URI);
}

// ---------------------------------------------------------------------------
// Status factory
// ---------------------------------------------------------------------------

SamlStatus SamlStatusOk() {
  SamlStatus s;
  s.statusCode    = SAML_STATUS_SUCCESS;
  s.statusMessage = "Success";
  return s;
}

SamlStatus SamlStatusError(string statusCode, string message = "") {
  SamlStatus s;
  s.statusCode    = statusCode;
  s.statusMessage = message.length ? message : _statusDescription(statusCode);
  return s;
}

private string _statusDescription(string code) pure nothrow @safe {
  switch (code) {
    case SAML_STATUS_SUCCESS:          return "Success";
    case SAML_STATUS_REQUESTER:        return "Requester error";
    case SAML_STATUS_RESPONDER:        return "Responder error";
    case SAML_STATUS_VERSION_MISMATCH: return "Version mismatch";
    case SAML_STATUS_AUTHN_FAILED:     return "Authentication failed";
    case SAML_STATUS_NO_PASSIVE:       return "No passive";
    case SAML_STATUS_REQUEST_DENIED:   return "Request denied";
    case SAML_STATUS_UNSUPPORTED_BIND: return "Unsupported binding";
    case SAML_STATUS_INVALID_NAMEID:   return "Invalid NameID policy";
    default:                           return "Unknown status";
  }
}

// ---------------------------------------------------------------------------
// Conditions factory
// ---------------------------------------------------------------------------

SamlConditions SamlBuildConditions(string[] audiences, int windowSeconds = 300) {
  SamlConditions c;
  c.notBefore           = samlDefaultNotBefore();
  c.notOnOrAfter        = samlDefaultNotOnOrAfter();
  c.audienceRestrictions = audiences.dup;
  return c;
}

// ---------------------------------------------------------------------------
// AuthnStatement factory
// ---------------------------------------------------------------------------

SamlAuthnStatement SamlBuildAuthnStatement(
  string authnContextClassRef = SAML_AUTHN_PPT,
  string sessionIndex = ""
) {
  SamlAuthnStatement stmt;
  stmt.authnInstant         = samlNow();
  stmt.sessionIndex         = sessionIndex;
  stmt.authnContextClassRef = authnContextClassRef;
  stmt.sessionNotOnOrAfter  = samlFutureDateTime(28800);  // 8 hours
  return stmt;
}

// ---------------------------------------------------------------------------
// Assertion factory
// ---------------------------------------------------------------------------

SamlAssertion SamlBuildAssertion(
  string issuer,
  SamlNameID nameId,
  string recipient,
  string inResponseTo,
  string[] audiences,
  SamlAttribute[] attributes = null,
  string authnContextClassRef = SAML_AUTHN_PPT
) {
  SamlAssertion a;
  a.id           = samlGenerateId();
  a.issuer       = issuer;
  a.issueInstant = samlNow();

  a.subject.nameId               = nameId;
  a.subject.confirmationMethod   = SAML_CM_BEARER;
  a.subject.confirmationData.recipient    = recipient;
  a.subject.confirmationData.inResponseTo = inResponseTo;
  a.subject.confirmationData.notOnOrAfter = samlFutureDateTime(300);

  a.conditions = SamlBuildConditions(audiences);
  a.authnStatements ~= SamlBuildAuthnStatement(authnContextClassRef);

  if (attributes.length > 0) {
    a.attributeStatement.attributes = attributes.dup;
  }
  return a;
}

// ---------------------------------------------------------------------------
// AuthnRequest factory
// ---------------------------------------------------------------------------

SamlAuthnRequest SamlBuildAuthnRequest(
  string issuer,
  string acsUrl,
  string destination,
  SamlBinding binding = SamlBinding.httpPost
) {
  SamlAuthnRequest req;
  req.id                          = samlGenerateId();
  req.issueInstant                = samlNow();
  req.issuer                      = issuer;
  req.destination                 = destination;
  req.assertionConsumerServiceUrl = acsUrl;
  req.protocolBinding             = samlBindingUrn(binding);
  return req;
}

// ---------------------------------------------------------------------------
// Response factories
// ---------------------------------------------------------------------------

SamlResponse SamlBuildSuccessResponse(
  string issuer,
  string destination,
  string inResponseTo,
  SamlAssertion[] assertions
) {
  SamlResponse resp;
  resp.id           = samlGenerateId();
  resp.issueInstant = samlNow();
  resp.issuer       = issuer;
  resp.destination  = destination;
  resp.inResponseTo = inResponseTo;
  resp.status       = SamlStatusOk();
  resp.assertions   = assertions.dup;
  return resp;
}

SamlResponse SamlBuildErrorResponse(
  string issuer,
  string destination,
  string inResponseTo,
  string statusCode,
  string statusMessage = ""
) {
  SamlResponse resp;
  resp.id           = samlGenerateId();
  resp.issueInstant = samlNow();
  resp.issuer       = issuer;
  resp.destination  = destination;
  resp.inResponseTo = inResponseTo;
  resp.status       = SamlStatusError(statusCode, statusMessage);
  return resp;
}

// ---------------------------------------------------------------------------
// Logout request / response factories
// ---------------------------------------------------------------------------

SamlLogoutRequest SamlBuildLogoutRequest(
  string issuer,
  string destination,
  SamlNameID nameId,
  string sessionIndex = ""
) {
  SamlLogoutRequest req;
  req.id           = samlGenerateId();
  req.issueInstant = samlNow();
  req.issuer       = issuer;
  req.destination  = destination;
  req.nameId       = nameId;
  req.sessionIndex = sessionIndex;
  return req;
}

SamlLogoutResponse SamlBuildLogoutResponse(
  string issuer,
  string destination,
  string inResponseTo,
  bool success_
) {
  SamlLogoutResponse resp;
  resp.id           = samlGenerateId();
  resp.issueInstant = samlNow();
  resp.issuer       = issuer;
  resp.destination  = destination;
  resp.inResponseTo = inResponseTo;
  resp.status       = success_ ? SamlStatusOk()
                               : SamlStatusError(SAML_STATUS_RESPONDER);
  return resp;
}

// ---------------------------------------------------------------------------
// Unit tests
// ---------------------------------------------------------------------------

unittest {
  auto id = samlGenerateId();
  assert(id.length > 1 && id[0] == '_');

  auto nameId = SamlEmailNameID("alice@example.com");
  assert(nameId.format == SAML_NAMEID_EMAIL);

  auto attr = SamlAttr("mail", ["alice@example.com"]);
  assert(attr.values.length == 1);

  auto status = SamlStatusOk();
  assert(status.success());

  auto errStatus = SamlStatusError(SAML_STATUS_AUTHN_FAILED);
  assert(!errStatus.success());

  auto req = SamlBuildAuthnRequest(
    "https://sp.example.com",
    "https://sp.example.com/acs",
    "https://idp.example.com/sso"
  );
  assert(req.id[0] == '_');
  assert(req.protocolBinding == SAML_BINDING_HTTP_POST);
}
