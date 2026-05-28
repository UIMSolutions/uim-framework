/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.saml.provider;

import uim.saml;

mixin(ShowModule!());

@safe:

// ===========================================================================
// XML serialisation helpers (internal — not exported)
// ===========================================================================

private string _samlNameIdXml(string prefix, SamlNameID nameId) {
  auto buf = `<` ~ prefix ~ `:NameID`;
  if (nameId.format.length)          buf ~= ` Format="` ~ samlXmlEscapeAttr(nameId.format) ~ `"`;
  if (nameId.spNameQualifier.length) buf ~= ` SPNameQualifier="` ~ samlXmlEscapeAttr(nameId.spNameQualifier) ~ `"`;
  if (nameId.nameQualifier.length)   buf ~= ` NameQualifier="` ~ samlXmlEscapeAttr(nameId.nameQualifier) ~ `"`;
  return buf ~ `>` ~ samlXmlEscapeText(nameId.value) ~ `</` ~ prefix ~ `:NameID>`;
}

private string _samlStatusXml(string prefix, SamlStatus status) {
  auto buf  = `<` ~ prefix ~ `:Status>`;
  buf ~= `<` ~ prefix ~ `:StatusCode Value="` ~ samlXmlEscapeAttr(status.statusCode) ~ `"/>`;
  if (status.statusMessage.length) {
    buf ~= `<` ~ prefix ~ `:StatusMessage>` ~ samlXmlEscapeText(status.statusMessage) ~ `</` ~ prefix ~ `:StatusMessage>`;
  }
  return buf ~ `</` ~ prefix ~ `:Status>`;
}

private string _samlConditionsXml(string samlPrefix, SamlConditions conds) {
  auto buf = `<` ~ samlPrefix ~ `:Conditions`;
  if (conds.notBefore.length)    buf ~= ` NotBefore="` ~ samlXmlEscapeAttr(conds.notBefore) ~ `"`;
  if (conds.notOnOrAfter.length) buf ~= ` NotOnOrAfter="` ~ samlXmlEscapeAttr(conds.notOnOrAfter) ~ `"`;
  buf ~= `>`;
  foreach (aud; conds.audienceRestrictions) {
    buf ~= `<` ~ samlPrefix ~ `:AudienceRestriction>`;
    buf ~= `<` ~ samlPrefix ~ `:Audience>` ~ samlXmlEscapeText(aud) ~ `</` ~ samlPrefix ~ `:Audience>`;
    buf ~= `</` ~ samlPrefix ~ `:AudienceRestriction>`;
  }
  return buf ~ `</` ~ samlPrefix ~ `:Conditions>`;
}

private string _samlAssertionXml(string samlPrefix, SamlAssertion a) {
  auto buf = `<` ~ samlPrefix ~ `:Assertion`;
  buf ~= ` xmlns:` ~ samlPrefix ~ `="` ~ SAML_NS ~ `"`;
  buf ~= ` ID="` ~ samlXmlEscapeAttr(a.id) ~ `"`;
  buf ~= ` Version="2.0"`;
  buf ~= ` IssueInstant="` ~ samlXmlEscapeAttr(a.issueInstant) ~ `">`;

  buf ~= `<` ~ samlPrefix ~ `:Issuer>` ~ samlXmlEscapeText(a.issuer) ~ `</` ~ samlPrefix ~ `:Issuer>`;

  // Subject
  buf ~= `<` ~ samlPrefix ~ `:Subject>`;
  buf ~= _samlNameIdXml(samlPrefix, a.subject.nameId);
  buf ~= `<` ~ samlPrefix ~ `:SubjectConfirmation Method="` ~ samlXmlEscapeAttr(a.subject.confirmationMethod) ~ `">`;
  buf ~= `<` ~ samlPrefix ~ `:SubjectConfirmationData`;
  if (a.subject.confirmationData.notOnOrAfter.length)
    buf ~= ` NotOnOrAfter="` ~ samlXmlEscapeAttr(a.subject.confirmationData.notOnOrAfter) ~ `"`;
  if (a.subject.confirmationData.recipient.length)
    buf ~= ` Recipient="` ~ samlXmlEscapeAttr(a.subject.confirmationData.recipient) ~ `"`;
  if (a.subject.confirmationData.inResponseTo.length)
    buf ~= ` InResponseTo="` ~ samlXmlEscapeAttr(a.subject.confirmationData.inResponseTo) ~ `"`;
  buf ~= `/>`;
  buf ~= `</` ~ samlPrefix ~ `:SubjectConfirmation>`;
  buf ~= `</` ~ samlPrefix ~ `:Subject>`;

  buf ~= _samlConditionsXml(samlPrefix, a.conditions);

  // AuthnStatements
  foreach (stmt; a.authnStatements) {
    buf ~= `<` ~ samlPrefix ~ `:AuthnStatement AuthnInstant="` ~ samlXmlEscapeAttr(stmt.authnInstant) ~ `"`;
    if (stmt.sessionIndex.length)
      buf ~= ` SessionIndex="` ~ samlXmlEscapeAttr(stmt.sessionIndex) ~ `"`;
    if (stmt.sessionNotOnOrAfter.length)
      buf ~= ` SessionNotOnOrAfter="` ~ samlXmlEscapeAttr(stmt.sessionNotOnOrAfter) ~ `"`;
    buf ~= `>`;
    buf ~= `<` ~ samlPrefix ~ `:AuthnContext>`;
    buf ~= `<` ~ samlPrefix ~ `:AuthnContextClassRef>` ~ samlXmlEscapeText(stmt.authnContextClassRef) ~ `</` ~ samlPrefix ~ `:AuthnContextClassRef>`;
    buf ~= `</` ~ samlPrefix ~ `:AuthnContext>`;
    buf ~= `</` ~ samlPrefix ~ `:AuthnStatement>`;
  }

  // AttributeStatement
  if (a.attributeStatement.attributes.length > 0) {
    buf ~= `<` ~ samlPrefix ~ `:AttributeStatement>`;
    foreach (attr; a.attributeStatement.attributes) {
      buf ~= `<` ~ samlPrefix ~ `:Attribute Name="` ~ samlXmlEscapeAttr(attr.name) ~ `"`;
      if (attr.nameFormat.length)
        buf ~= ` NameFormat="` ~ samlXmlEscapeAttr(attr.nameFormat) ~ `"`;
      if (attr.friendlyName.length)
        buf ~= ` FriendlyName="` ~ samlXmlEscapeAttr(attr.friendlyName) ~ `"`;
      buf ~= `>`;
      foreach (val; attr.values) {
        buf ~= `<` ~ samlPrefix ~ `:AttributeValue>` ~ samlXmlEscapeText(val) ~ `</` ~ samlPrefix ~ `:AttributeValue>`;
      }
      buf ~= `</` ~ samlPrefix ~ `:Attribute>`;
    }
    buf ~= `</` ~ samlPrefix ~ `:AttributeStatement>`;
  }

  return buf ~ `</` ~ samlPrefix ~ `:Assertion>`;
}

// ===========================================================================
// XML parsing helpers (internal)
// ===========================================================================

private SamlNameID _parseNameId(string xml) {
  SamlNameID n;
  n.value            = samlXmlTextContent(xml, "NameID");
  n.format           = samlXmlAttrValue(xml, "NameID", "Format");
  n.spNameQualifier  = samlXmlAttrValue(xml, "NameID", "SPNameQualifier");
  n.nameQualifier    = samlXmlAttrValue(xml, "NameID", "NameQualifier");
  return n;
}

private SamlStatus _parseStatus(string xml) {
  SamlStatus s;
  s.statusCode    = samlXmlAttrValue(xml, "StatusCode", "Value");
  s.statusMessage = samlXmlTextContent(xml, "StatusMessage");
  if (s.statusCode.length == 0) s.statusCode = SAML_STATUS_RESPONDER;
  return s;
}

private SamlConditions _parseConditions(string xml) {
  SamlConditions c;
  c.notBefore    = samlXmlAttrValue(xml, "Conditions", "NotBefore");
  c.notOnOrAfter = samlXmlAttrValue(xml, "Conditions", "NotOnOrAfter");
  auto audiences  = samlXmlElements(xml, "Audience");
  foreach (aud; audiences) {
    import std.string : indexOf;
    ptrdiff_t gt = aud.indexOf('>');
    ptrdiff_t lt = aud.indexOf('<', gt >= 0 ? cast(size_t) gt + 1 : 0);
    if (gt >= 0) {
      string val = lt >= 0
        ? aud[cast(size_t) gt + 1 .. cast(size_t) lt]
        : aud[cast(size_t) gt + 1 .. $];
      if (val.length) c.audienceRestrictions ~= val;
    }
  }
  return c;
}

private SamlAttribute _parseAttribute(string xml) {
  SamlAttribute a;
  a.name         = samlXmlAttrValue(xml, "Attribute", "Name");
  a.nameFormat   = samlXmlAttrValue(xml, "Attribute", "NameFormat");
  a.friendlyName = samlXmlAttrValue(xml, "Attribute", "FriendlyName");
  auto valEls = samlXmlElements(xml, "AttributeValue");
  foreach (el; valEls) {
    a.values ~= samlXmlTextContent(el, "AttributeValue");
  }
  return a;
}

private SamlAssertion _parseAssertion(string xml) {
  SamlAssertion a;
  a.id           = samlXmlAttrValue(xml, "Assertion", "ID");
  a.issuer       = samlXmlTextContent(xml, "Issuer");
  a.issueInstant = samlXmlAttrValue(xml, "Assertion", "IssueInstant");
  a.subject      = _parseSubject(xml);
  a.conditions   = _parseConditions(xml);

  auto authnEls = samlXmlElements(xml, "AuthnStatement");
  foreach (el; authnEls) {
    SamlAuthnStatement stmt;
    stmt.authnInstant         = samlXmlAttrValue(el, "AuthnStatement", "AuthnInstant");
    stmt.sessionIndex         = samlXmlAttrValue(el, "AuthnStatement", "SessionIndex");
    stmt.sessionNotOnOrAfter  = samlXmlAttrValue(el, "AuthnStatement", "SessionNotOnOrAfter");
    stmt.authnContextClassRef = samlXmlTextContent(el, "AuthnContextClassRef");
    a.authnStatements ~= stmt;
  }

  auto attrEls = samlXmlElements(xml, "Attribute");
  foreach (el; attrEls) {
    a.attributeStatement.attributes ~= _parseAttribute(el);
  }

  return a;
}

private SamlSubject _parseSubject(string xml) {
  SamlSubject s;
  s.nameId = _parseNameId(xml);
  s.confirmationMethod = samlXmlAttrValue(xml, "SubjectConfirmation", "Method");
  if (s.confirmationMethod.length == 0) s.confirmationMethod = SAML_CM_BEARER;
  s.confirmationData.notOnOrAfter = samlXmlAttrValue(xml, "SubjectConfirmationData", "NotOnOrAfter");
  s.confirmationData.recipient    = samlXmlAttrValue(xml, "SubjectConfirmationData", "Recipient");
  s.confirmationData.inResponseTo = samlXmlAttrValue(xml, "SubjectConfirmationData", "InResponseTo");
  return s;
}

// ===========================================================================
// Service Provider
// ===========================================================================

class UIMSamlServiceProvider : UIMObject, ISamlServiceProvider {
  private SamlSpConfig  _sp;
  private SamlIdpConfig _idp;

  this(SamlSpConfig sp, SamlIdpConfig idp) @safe {
    _sp  = sp;
    _idp = idp;
  }

  // ---- properties ----------------------------------------------------------

  @property string entityId() const @safe { return _sp.entityId; }
  @property string acsUrl()   const @safe { return _sp.acsUrl; }

  // ---- outgoing: AuthnRequest -----------------------------------------------

  SamlAuthnRequest buildAuthnRequest(string destination) @safe {
    return SamlBuildAuthnRequest(
      _sp.entityId,
      _sp.acsUrl,
      destination.length ? destination : _idp.ssoUrl,
      _sp.defaultBinding
    );
  }

  string buildAuthnRequestXml(SamlAuthnRequest req) @safe {
    auto buf = `<?xml version="1.0" encoding="UTF-8"?>` ~ "\n";
    buf ~= `<samlp:AuthnRequest`;
    buf ~= ` xmlns:samlp="` ~ SAMLP_NS ~ `"`;
    buf ~= ` xmlns:saml="` ~ SAML_NS ~ `"`;
    buf ~= ` ID="` ~ samlXmlEscapeAttr(req.id) ~ `"`;
    buf ~= ` Version="2.0"`;
    buf ~= ` IssueInstant="` ~ samlXmlEscapeAttr(req.issueInstant) ~ `"`;
    if (req.destination.length)
      buf ~= ` Destination="` ~ samlXmlEscapeAttr(req.destination) ~ `"`;
    buf ~= ` AssertionConsumerServiceURL="` ~ samlXmlEscapeAttr(req.assertionConsumerServiceUrl) ~ `"`;
    buf ~= ` ProtocolBinding="` ~ samlXmlEscapeAttr(req.protocolBinding) ~ `"`;
    if (req.forceAuthn) buf ~= ` ForceAuthn="true"`;
    if (req.isPassive)  buf ~= ` IsPassive="true"`;
    if (req.providerName.length)
      buf ~= ` ProviderName="` ~ samlXmlEscapeAttr(req.providerName) ~ `"`;
    buf ~= `>` ~ "\n";
    buf ~= `  <saml:Issuer>` ~ samlXmlEscapeText(req.issuer) ~ `</saml:Issuer>` ~ "\n";
    buf ~= `  <samlp:NameIDPolicy`;
    buf ~= ` Format="` ~ samlXmlEscapeAttr(req.nameIdFormat) ~ `"`;
    buf ~= ` AllowCreate="` ~ (req.allowCreate ? "true" : "false") ~ `"`;
    buf ~= `/>` ~ "\n";
    if (req.authnContextClassRef.length) {
      buf ~= `  <samlp:RequestedAuthnContext Comparison="` ~ samlXmlEscapeAttr(req.authnContextComparison) ~ `">` ~ "\n";
      buf ~= `    <saml:AuthnContextClassRef>` ~ samlXmlEscapeText(req.authnContextClassRef) ~ `</saml:AuthnContextClassRef>` ~ "\n";
      buf ~= `  </samlp:RequestedAuthnContext>` ~ "\n";
    }
    buf ~= `</samlp:AuthnRequest>`;
    return buf;
  }

  /// Return base64-encoded AuthnRequest XML for HTTP-POST binding
  string buildAuthnRequestPostParam(SamlAuthnRequest req) @safe {
    auto xml = buildAuthnRequestXml(req);
    return samlBase64EncodeString(xml);
  }

  /// Return full redirect URL with SAMLRequest + optional RelayState params
  string buildAuthnRequestRedirectUrl(SamlAuthnRequest req, string idpUrl, string relayState = "") @safe {
    auto xml       = buildAuthnRequestXml(req);
    auto deflated  = samlDeflateString(xml);
    auto encoded   = samlBase64UrlEncode(deflated);
    auto samlParam = samlUrlEncode(encoded);

    auto url = (idpUrl.length ? idpUrl : _idp.ssoUrl) ~ "?SAMLRequest=" ~ samlParam;
    if (relayState.length) {
      url ~= "&RelayState=" ~ samlUrlEncode(relayState);
    }
    return url;
  }

  // ---- incoming: Response --------------------------------------------------

  SamlResponse parseResponse(string xmlString) @safe {
    SamlResponse resp;
    resp.id           = samlXmlAttrValue(xmlString, "Response", "ID");
    resp.issueInstant = samlXmlAttrValue(xmlString, "Response", "IssueInstant");
    resp.issuer       = samlXmlTextContent(xmlString, "Issuer");
    resp.destination  = samlXmlAttrValue(xmlString, "Response", "Destination");
    resp.inResponseTo = samlXmlAttrValue(xmlString, "Response", "InResponseTo");
    resp.status       = _parseStatus(xmlString);

    auto assertionEls = samlXmlElements(xmlString, "Assertion");
    foreach (el; assertionEls) {
      resp.assertions ~= _parseAssertion(el);
    }
    return resp;
  }

  SamlValidationResult validateResponse(SamlResponse resp) @safe {
    SamlValidationResult result;

    if (!resp.status.success()) {
      result.error = "SAML status is not Success: " ~ resp.status.statusCode;
      return result;
    }

    if (resp.assertions.length == 0) {
      result.error = "Response contains no assertions";
      return result;
    }

    auto a = resp.assertions[0];

    // Validate audience restriction
    bool audienceOk = false;
    foreach (aud; a.conditions.audienceRestrictions) {
      if (aud == _sp.entityId) { audienceOk = true; break; }
    }
    if (a.conditions.audienceRestrictions.length > 0 && !audienceOk) {
      result.error = "Audience mismatch — expected " ~ _sp.entityId;
      return result;
    }

    // Validate time window
    if (!samlWithinWindow(a.conditions.notBefore, a.conditions.notOnOrAfter)) {
      result.error = "Assertion conditions time window is invalid";
      return result;
    }

    // Validate SubjectConfirmationData.Recipient
    auto recipient = a.subject.confirmationData.recipient;
    if (recipient.length > 0 && recipient != _sp.acsUrl) {
      result.error = "SubjectConfirmationData.Recipient mismatch";
      return result;
    }

    result.valid = true;
    return result;
  }

  // ---- outgoing: LogoutRequest ---------------------------------------------

  SamlLogoutRequest buildLogoutRequest(SamlNameID nameId, string sessionIndex = "") @safe {
    return SamlBuildLogoutRequest(_sp.entityId, _idp.sloUrl, nameId, sessionIndex);
  }

  string buildLogoutRequestXml(SamlLogoutRequest req) @safe {
    auto buf = `<?xml version="1.0" encoding="UTF-8"?>` ~ "\n";
    buf ~= `<samlp:LogoutRequest`;
    buf ~= ` xmlns:samlp="` ~ SAMLP_NS ~ `"`;
    buf ~= ` xmlns:saml="` ~ SAML_NS ~ `"`;
    buf ~= ` ID="` ~ samlXmlEscapeAttr(req.id) ~ `"`;
    buf ~= ` Version="2.0"`;
    buf ~= ` IssueInstant="` ~ samlXmlEscapeAttr(req.issueInstant) ~ `"`;
    if (req.destination.length)
      buf ~= ` Destination="` ~ samlXmlEscapeAttr(req.destination) ~ `"`;
    buf ~= `>` ~ "\n";
    buf ~= `  <saml:Issuer>` ~ samlXmlEscapeText(req.issuer) ~ `</saml:Issuer>` ~ "\n";
    buf ~= `  ` ~ _samlNameIdXml("saml", req.nameId) ~ "\n";
    if (req.sessionIndex.length)
      buf ~= `  <samlp:SessionIndex>` ~ samlXmlEscapeText(req.sessionIndex) ~ `</samlp:SessionIndex>` ~ "\n";
    buf ~= `</samlp:LogoutRequest>`;
    return buf;
  }

  SamlLogoutResponse parseLogoutResponse(string xmlString) @safe {
    SamlLogoutResponse resp;
    resp.id           = samlXmlAttrValue(xmlString, "LogoutResponse", "ID");
    resp.issueInstant = samlXmlAttrValue(xmlString, "LogoutResponse", "IssueInstant");
    resp.issuer       = samlXmlTextContent(xmlString, "Issuer");
    resp.destination  = samlXmlAttrValue(xmlString, "LogoutResponse", "Destination");
    resp.inResponseTo = samlXmlAttrValue(xmlString, "LogoutResponse", "InResponseTo");
    resp.status       = _parseStatus(xmlString);
    return resp;
  }
}

// ===========================================================================
// Identity Provider
// ===========================================================================

class UIMSamlIdentityProvider : UIMObject, ISamlIdentityProvider {
  private string _entityId;

  this(string entityId) @safe {
    _entityId = entityId;
  }

  @property string entityId() const @safe { return _entityId; }

  SamlAuthnRequest parseAuthnRequest(string xmlString) @safe {
    SamlAuthnRequest req;
    req.id                          = samlXmlAttrValue(xmlString, "AuthnRequest", "ID");
    req.issueInstant                = samlXmlAttrValue(xmlString, "AuthnRequest", "IssueInstant");
    req.issuer                      = samlXmlTextContent(xmlString, "Issuer");
    req.destination                 = samlXmlAttrValue(xmlString, "AuthnRequest", "Destination");
    req.assertionConsumerServiceUrl = samlXmlAttrValue(xmlString, "AuthnRequest", "AssertionConsumerServiceURL");
    req.protocolBinding             = samlXmlAttrValue(xmlString, "AuthnRequest", "ProtocolBinding");
    req.nameIdFormat                = samlXmlAttrValue(xmlString, "NameIDPolicy", "Format");
    req.authnContextClassRef        = samlXmlTextContent(xmlString, "AuthnContextClassRef");
    req.forceAuthn = samlXmlAttrValue(xmlString, "AuthnRequest", "ForceAuthn") == "true";
    req.isPassive  = samlXmlAttrValue(xmlString, "AuthnRequest", "IsPassive")  == "true";
    return req;
  }

  SamlResponse buildResponse(SamlAssertion assertion, string destination, string inResponseTo) @safe {
    return SamlBuildSuccessResponse(_entityId, destination, inResponseTo, [assertion]);
  }

  string buildResponseXml(SamlResponse resp) @safe {
    auto buf = `<?xml version="1.0" encoding="UTF-8"?>` ~ "\n";
    buf ~= `<samlp:Response`;
    buf ~= ` xmlns:samlp="` ~ SAMLP_NS ~ `"`;
    buf ~= ` xmlns:saml="` ~ SAML_NS ~ `"`;
    buf ~= ` ID="` ~ samlXmlEscapeAttr(resp.id) ~ `"`;
    buf ~= ` Version="2.0"`;
    buf ~= ` IssueInstant="` ~ samlXmlEscapeAttr(resp.issueInstant) ~ `"`;
    if (resp.destination.length)
      buf ~= ` Destination="` ~ samlXmlEscapeAttr(resp.destination) ~ `"`;
    if (resp.inResponseTo.length)
      buf ~= ` InResponseTo="` ~ samlXmlEscapeAttr(resp.inResponseTo) ~ `"`;
    buf ~= `>` ~ "\n";
    buf ~= `  <saml:Issuer>` ~ samlXmlEscapeText(resp.issuer) ~ `</saml:Issuer>` ~ "\n";
    buf ~= `  ` ~ _samlStatusXml("samlp", resp.status) ~ "\n";
    foreach (a; resp.assertions) {
      buf ~= `  ` ~ _samlAssertionXml("saml", a) ~ "\n";
    }
    buf ~= `</samlp:Response>`;
    return buf;
  }

  SamlLogoutResponse buildLogoutResponse(SamlLogoutRequest req, bool success_) @safe {
    return SamlBuildLogoutResponse(_entityId, req.issuer, req.id, success_);
  }

  string buildLogoutResponseXml(SamlLogoutResponse resp) @safe {
    auto buf = `<?xml version="1.0" encoding="UTF-8"?>` ~ "\n";
    buf ~= `<samlp:LogoutResponse`;
    buf ~= ` xmlns:samlp="` ~ SAMLP_NS ~ `"`;
    buf ~= ` xmlns:saml="` ~ SAML_NS ~ `"`;
    buf ~= ` ID="` ~ samlXmlEscapeAttr(resp.id) ~ `"`;
    buf ~= ` Version="2.0"`;
    buf ~= ` IssueInstant="` ~ samlXmlEscapeAttr(resp.issueInstant) ~ `"`;
    if (resp.destination.length)
      buf ~= ` Destination="` ~ samlXmlEscapeAttr(resp.destination) ~ `"`;
    if (resp.inResponseTo.length)
      buf ~= ` InResponseTo="` ~ samlXmlEscapeAttr(resp.inResponseTo) ~ `"`;
    buf ~= `>` ~ "\n";
    buf ~= `  <saml:Issuer>` ~ samlXmlEscapeText(resp.issuer) ~ `</saml:Issuer>` ~ "\n";
    buf ~= `  ` ~ _samlStatusXml("samlp", resp.status) ~ "\n";
    buf ~= `</samlp:LogoutResponse>`;
    return buf;
  }
}

// ===========================================================================
// Factory functions
// ===========================================================================

/// Create a SAML Service Provider
UIMSamlServiceProvider SamlServiceProvider(SamlSpConfig sp, SamlIdpConfig idp) @safe {
  return new UIMSamlServiceProvider(sp, idp);
}

/// Create a SAML Identity Provider
UIMSamlIdentityProvider SamlIdentityProvider(string entityId) @safe {
  return new UIMSamlIdentityProvider(entityId);
}

// ===========================================================================
// Unit tests
// ===========================================================================

unittest {
  auto sp = new UIMSamlServiceProvider(
    SamlSpConfig(
      "https://sp.example.com",
      "https://sp.example.com/acs",
      "https://sp.example.com/slo"
    ),
    SamlIdpConfig(
      "https://idp.example.com",
      "https://idp.example.com/sso",
      "https://idp.example.com/slo",
      ""
    )
  );

  auto req = sp.buildAuthnRequest("https://idp.example.com/sso");
  assert(req.id.length > 1);
  assert(req.issuer == "https://sp.example.com");
  assert(req.assertionConsumerServiceUrl == "https://sp.example.com/acs");

  auto xml = sp.buildAuthnRequestXml(req);
  assert(xml.length > 0);
  import std.string : indexOf;
  assert(xml.indexOf("AuthnRequest") >= 0);
  assert(xml.indexOf(req.id) >= 0);

  auto postParam = sp.buildAuthnRequestPostParam(req);
  assert(postParam.length > 0);

  auto redirectUrl = sp.buildAuthnRequestRedirectUrl(req, "https://idp.example.com/sso");
  assert(redirectUrl.indexOf("SAMLRequest=") >= 0);

  // IdP
  auto idp = SamlIdentityProvider("https://idp.example.com");
  assert(idp.entityId == "https://idp.example.com");

  auto parsedReq = idp.parseAuthnRequest(xml);
  assert(parsedReq.id == req.id);
  assert(parsedReq.issuer == "https://sp.example.com");

  // Build and serialize a response
  auto nameId    = SamlEmailNameID("alice@example.com");
  auto assertion = SamlBuildAssertion(
    "https://idp.example.com", nameId,
    "https://sp.example.com/acs", req.id,
    ["https://sp.example.com"],
    [SamlAttr("email", ["alice@example.com"])]
  );
  auto resp    = idp.buildResponse(assertion, "https://sp.example.com/acs", req.id);
  auto respXml = idp.buildResponseXml(resp);
  assert(respXml.indexOf("Response") >= 0);
  assert(respXml.indexOf("alice@example.com") >= 0);

  // SP parses the response
  auto parsedResp = sp.parseResponse(respXml);
  assert(parsedResp.status.success());
  assert(parsedResp.assertions.length == 1);
  assert(parsedResp.assertions[0].subject.nameId.value == "alice@example.com");

  // Logout round-trip
  auto logoutReq    = sp.buildLogoutRequest(nameId, "_session001");
  auto logoutReqXml = sp.buildLogoutRequestXml(logoutReq);
  assert(logoutReqXml.indexOf("LogoutRequest") >= 0);

  auto logoutResp    = idp.buildLogoutResponse(logoutReq, true);
  auto logoutRespXml = idp.buildLogoutResponseXml(logoutResp);
  auto parsedLogout  = sp.parseLogoutResponse(logoutRespXml);
  assert(parsedLogout.status.success());
}
