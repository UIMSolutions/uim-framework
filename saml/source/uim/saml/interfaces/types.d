/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.saml.interfaces.types;

@safe:

// ---------------------------------------------------------------------------
// SAML 2.0 namespace constants
// ---------------------------------------------------------------------------
immutable SAML_NS       = "urn:oasis:names:tc:SAML:2.0:assertion";
immutable SAMLP_NS      = "urn:oasis:names:tc:SAML:2.0:protocol";
immutable SAMLMETA_NS   = "urn:oasis:names:tc:SAML:2.0:metadata";
immutable SAMLSIG_NS    = "http://www.w3.org/2000/09/xmldsig#";
immutable SAMLENC_NS    = "http://www.w3.org/2001/04/xmlenc#";

// ---------------------------------------------------------------------------
// Protocol binding URNs
// ---------------------------------------------------------------------------
immutable SAML_BINDING_HTTP_POST      = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST";
immutable SAML_BINDING_HTTP_REDIRECT  = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect";
immutable SAML_BINDING_HTTP_ARTIFACT  = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact";
immutable SAML_BINDING_SOAP           = "urn:oasis:names:tc:SAML:2.0:bindings:SOAP";

// ---------------------------------------------------------------------------
// Status code URNs (RFC 4511-style string constants)
// ---------------------------------------------------------------------------
immutable SAML_STATUS_SUCCESS         = "urn:oasis:names:tc:SAML:2.0:status:Success";
immutable SAML_STATUS_REQUESTER       = "urn:oasis:names:tc:SAML:2.0:status:Requester";
immutable SAML_STATUS_RESPONDER       = "urn:oasis:names:tc:SAML:2.0:status:Responder";
immutable SAML_STATUS_VERSION_MISMATCH= "urn:oasis:names:tc:SAML:2.0:status:VersionMismatch";
immutable SAML_STATUS_AUTHN_FAILED    = "urn:oasis:names:tc:SAML:2.0:status:AuthnFailed";
immutable SAML_STATUS_INVALID_ATTR    = "urn:oasis:names:tc:SAML:2.0:status:InvalidAttrNameOrValue";
immutable SAML_STATUS_INVALID_NAMEID  = "urn:oasis:names:tc:SAML:2.0:status:InvalidNameIDPolicy";
immutable SAML_STATUS_NO_AUTHN        = "urn:oasis:names:tc:SAML:2.0:status:NoAuthnContext";
immutable SAML_STATUS_NO_PASSIVE      = "urn:oasis:names:tc:SAML:2.0:status:NoPassive";
immutable SAML_STATUS_REQUEST_DENIED  = "urn:oasis:names:tc:SAML:2.0:status:RequestDenied";
immutable SAML_STATUS_UNSUPPORTED_BIND= "urn:oasis:names:tc:SAML:2.0:status:UnsupportedBinding";
immutable SAML_STATUS_PARTIAL_LOGOUT  = "urn:oasis:names:tc:SAML:2.0:status:PartialLogout";

// ---------------------------------------------------------------------------
// NameID format URNs
// ---------------------------------------------------------------------------
immutable SAML_NAMEID_UNSPECIFIED     = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified";
immutable SAML_NAMEID_EMAIL           = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress";
immutable SAML_NAMEID_X509            = "urn:oasis:names:tc:SAML:1.1:nameid-format:X509SubjectName";
immutable SAML_NAMEID_WINDOWS         = "urn:oasis:names:tc:SAML:1.1:nameid-format:WindowsDomainQualifiedName";
immutable SAML_NAMEID_KERBEROS        = "urn:oasis:names:tc:SAML:2.0:nameid-format:kerberos";
immutable SAML_NAMEID_ENTITY          = "urn:oasis:names:tc:SAML:2.0:nameid-format:entity";
immutable SAML_NAMEID_PERSISTENT      = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent";
immutable SAML_NAMEID_TRANSIENT       = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient";

// ---------------------------------------------------------------------------
// AuthnContext class reference URNs
// ---------------------------------------------------------------------------
immutable SAML_AUTHN_PPT              = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport";
immutable SAML_AUTHN_PASSWORD         = "urn:oasis:names:tc:SAML:2.0:ac:classes:Password";
immutable SAML_AUTHN_TLS_CLIENT       = "urn:oasis:names:tc:SAML:2.0:ac:classes:TLSClient";
immutable SAML_AUTHN_X509             = "urn:oasis:names:tc:SAML:2.0:ac:classes:X509";
immutable SAML_AUTHN_KERBEROS         = "urn:oasis:names:tc:SAML:2.0:ac:classes:Kerberos";
immutable SAML_AUTHN_UNSPECIFIED      = "urn:oasis:names:tc:SAML:2.0:ac:classes:unspecified";

// Subject confirmation methods
immutable SAML_CM_BEARER              = "urn:oasis:names:tc:SAML:2.0:cm:bearer";
immutable SAML_CM_HOLDER_OF_KEY       = "urn:oasis:names:tc:SAML:2.0:cm:holder-of-key";
immutable SAML_CM_SENDER_VOUCHES      = "urn:oasis:names:tc:SAML:2.0:cm:sender-vouches";

// Attribute name formats
immutable SAML_ATTRFMT_BASIC          = "urn:oasis:names:tc:SAML:2.0:attrname-format:basic";
immutable SAML_ATTRFMT_URI            = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri";
immutable SAML_ATTRFMT_UNSPECIFIED    = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified";

// ---------------------------------------------------------------------------
// Binding enum (categorical — not URI)
// ---------------------------------------------------------------------------
enum SamlBinding {
  httpPost,
  httpRedirect,
  httpArtifact,
  soap
}

string samlBindingUrn(SamlBinding binding) pure nothrow @safe {
  final switch (binding) {
    case SamlBinding.httpPost:      return SAML_BINDING_HTTP_POST;
    case SamlBinding.httpRedirect:  return SAML_BINDING_HTTP_REDIRECT;
    case SamlBinding.httpArtifact:  return SAML_BINDING_HTTP_ARTIFACT;
    case SamlBinding.soap:          return SAML_BINDING_SOAP;
  }
}

// ---------------------------------------------------------------------------
// Core data structures
// ---------------------------------------------------------------------------

struct SamlNameID {
  string value;
  string format  = SAML_NAMEID_UNSPECIFIED;
  string spNameQualifier;
  string nameQualifier;
}

struct SamlAttribute {
  string   name;
  string   nameFormat   = SAML_ATTRFMT_BASIC;
  string   friendlyName;
  string[] values;
}

struct SamlConditions {
  string   notBefore;
  string   notOnOrAfter;
  string[] audienceRestrictions;
}

struct SamlSubjectConfirmationData {
  string notOnOrAfter;
  string recipient;
  string inResponseTo;
  string address;
}

struct SamlSubject {
  SamlNameID                  nameId;
  string                      confirmationMethod = SAML_CM_BEARER;
  SamlSubjectConfirmationData confirmationData;
}

struct SamlAuthnStatement {
  string authnInstant;
  string sessionIndex;
  string sessionNotOnOrAfter;
  string authnContextClassRef = SAML_AUTHN_PPT;
}

struct SamlAttributeStatement {
  SamlAttribute[] attributes;
}

struct SamlAssertion {
  string                id;
  string                issuer;
  string                issueInstant;
  string                version_         = "2.0";
  SamlSubject           subject;
  SamlConditions        conditions;
  SamlAuthnStatement[]  authnStatements;
  SamlAttributeStatement attributeStatement;
}

struct SamlStatus {
  string statusCode      = SAML_STATUS_SUCCESS;
  string statusMessage;
  bool   success() const @safe { return statusCode == SAML_STATUS_SUCCESS; }
}

// ---------------------------------------------------------------------------
// Request / response message structs
// ---------------------------------------------------------------------------

struct SamlAuthnRequest {
  string      id;
  string      version_                    = "2.0";
  string      issueInstant;
  string      issuer;
  string      destination;
  string      assertionConsumerServiceUrl;
  string      protocolBinding             = SAML_BINDING_HTTP_POST;
  bool        forceAuthn                  = false;
  bool        isPassive                   = false;
  bool        allowCreate                 = true;
  string      nameIdFormat                = SAML_NAMEID_UNSPECIFIED;
  string      authnContextClassRef        = SAML_AUTHN_PPT;
  string      authnContextComparison      = "exact";
  string      providerName;
}

struct SamlResponse {
  string          id;
  string          version_      = "2.0";
  string          issueInstant;
  string          issuer;
  string          destination;
  string          inResponseTo;
  SamlStatus      status;
  SamlAssertion[] assertions;
}

struct SamlLogoutRequest {
  string     id;
  string     version_     = "2.0";
  string     issueInstant;
  string     issuer;
  string     destination;
  SamlNameID nameId;
  string     sessionIndex;
  string     reason;
}

struct SamlLogoutResponse {
  string     id;
  string     version_     = "2.0";
  string     issueInstant;
  string     issuer;
  string     destination;
  string     inResponseTo;
  SamlStatus status;
}

// ---------------------------------------------------------------------------
// Metadata structures
// ---------------------------------------------------------------------------

struct SamlEndpoint {
  SamlBinding binding;
  string      location;
  bool        isDefault = false;
}

struct SamlEntityDescriptor {
  string         entityId;
  string         certPEM;           // PEM-encoded signing certificate (no -----BEGIN/END----- headers)
  SamlEndpoint[] ssoEndpoints;
  SamlEndpoint[] sloEndpoints;
  SamlEndpoint[] acsEndpoints;
  string[]       nameIdFormats;
}

// ---------------------------------------------------------------------------
// Validation result
// ---------------------------------------------------------------------------

struct SamlValidationResult {
  bool   valid   = false;
  string error;
  bool   success() const @safe { return valid; }
}

// ---------------------------------------------------------------------------
// Service Provider configuration
// ---------------------------------------------------------------------------

struct SamlSpConfig {
  string       entityId;
  string       acsUrl;
  string       sloUrl;
  SamlBinding  defaultBinding  = SamlBinding.httpPost;
}

// ---------------------------------------------------------------------------
// Identity Provider configuration (as seen by the SP)
// ---------------------------------------------------------------------------

struct SamlIdpConfig {
  string entityId;
  string ssoUrl;
  string sloUrl;
  string certificate;   // PEM public certificate for signature verification
}

// ---------------------------------------------------------------------------
// Service Provider interface
// ---------------------------------------------------------------------------

interface ISamlServiceProvider {
  @property string     entityId() const @safe;
  @property string     acsUrl()   const @safe;

  SamlAuthnRequest buildAuthnRequest(string destination) @safe;
  string           buildAuthnRequestXml(SamlAuthnRequest request) @safe;
  string           buildAuthnRequestPostParam(SamlAuthnRequest request) @safe;
  string           buildAuthnRequestRedirectUrl(SamlAuthnRequest request, string idpUrl, string relayState = "") @safe;

  SamlResponse     parseResponse(string xmlString) @safe;
  SamlValidationResult validateResponse(SamlResponse response) @safe;

  SamlLogoutRequest    buildLogoutRequest(SamlNameID nameId, string sessionIndex = "") @safe;
  string               buildLogoutRequestXml(SamlLogoutRequest request) @safe;
  SamlLogoutResponse   parseLogoutResponse(string xmlString) @safe;
}

// ---------------------------------------------------------------------------
// Identity Provider interface
// ---------------------------------------------------------------------------

interface ISamlIdentityProvider {
  @property string entityId() const @safe;

  SamlAuthnRequest parseAuthnRequest(string xmlString) @safe;
  SamlResponse     buildResponse(SamlAssertion assertion, string destination, string inResponseTo) @safe;
  string           buildResponseXml(SamlResponse response) @safe;
  SamlLogoutResponse buildLogoutResponse(SamlLogoutRequest request, bool success_) @safe;
  string           buildLogoutResponseXml(SamlLogoutResponse response) @safe;
}
