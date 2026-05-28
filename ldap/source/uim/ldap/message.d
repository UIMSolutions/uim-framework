/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ldap.message;

import uim.ldap;

mixin(ShowModule!());

@safe:

// ---------------------------------------------------------------------------
// Request factories
// ---------------------------------------------------------------------------

/// Create a simple anonymous bind request (version 3)
LdapBindRequest LdapAnonBind() {
  LdapBindRequest req;
  req.dn       = "";
  req.password = "";
  req.version_ = 3;
  return req;
}

/// Create a simple bind request
LdapBindRequest LdapBind(string dn, string password, int protocolVersion = 3) {
  LdapBindRequest req;
  req.dn       = dn;
  req.password = password;
  req.version_ = protocolVersion;
  return req;
}

/// Create a search request with sensible defaults
LdapSearchRequest LdapSearch(
  string   baseDN,
  string   filter     = "(objectClass=*)",
  string[] attributes = null,
  LdapScope scope_    = LdapScope.wholeSubtree,
  int      sizeLimit  = 0,
  int      timeLimit  = 0
) {
  LdapSearchRequest req;
  req.baseDN     = ldapNormalizeDN(baseDN);
  req.filter     = filter.length ? filter : "(objectClass=*)";
  req.attributes = attributes.dup;
  req.scope_     = scope_;
  req.sizeLimit  = sizeLimit;
  req.timeLimit  = timeLimit;
  return req;
}

/// Create an add request
LdapAddRequest LdapAdd(string dn, LdapAttribute[] attributes) {
  LdapAddRequest req;
  req.dn         = ldapNormalizeDN(dn);
  req.attributes = attributes.dup;
  return req;
}

/// Create a delete request
LdapDeleteRequest LdapDelete(string dn) {
  LdapDeleteRequest req;
  req.dn = ldapNormalizeDN(dn);
  return req;
}

/// Create a modify request
LdapModifyRequest LdapModify(string dn, LdapModification[] changes) {
  LdapModifyRequest req;
  req.dn      = ldapNormalizeDN(dn);
  req.changes = changes.dup;
  return req;
}

/// Create a modifyDN request (rename / move)
LdapModifyDNRequest LdapModifyDN(
  string dn,
  string newRDN,
  bool   deleteOldRDN = true,
  string newSuperior  = ""
) {
  LdapModifyDNRequest req;
  req.dn           = ldapNormalizeDN(dn);
  req.newRDN       = newRDN;
  req.deleteOldRDN = deleteOldRDN;
  req.newSuperior  = newSuperior.length ? ldapNormalizeDN(newSuperior) : "";
  return req;
}

/// Create a compare request
LdapCompareRequest LdapCompare(string dn, string attributeType, string value) {
  LdapCompareRequest req;
  req.dn             = ldapNormalizeDN(dn);
  req.attributeType  = attributeType;
  req.assertionValue = value;
  return req;
}

// ---------------------------------------------------------------------------
// Result factories
// ---------------------------------------------------------------------------

/// Create a success result
LdapResult LdapSuccess(string matchedDN = "", string message = "") {
  LdapResult result;
  result.resultCode         = LdapResultCode.success;
  result.matchedDN          = matchedDN;
  result.diagnosticMessage  = message.length ? message : ldapResultText(LdapResultCode.success);
  return result;
}

/// Create an error result
LdapResult LdapFailure(LdapResultCode code, string message = "") {
  LdapResult result;
  result.resultCode        = code;
  result.matchedDN         = "";
  result.diagnosticMessage = message.length ? message : ldapResultText(code);
  return result;
}

/// Create a modification change entry for use in an LdapModifyRequest
LdapModification LdapChange(LdapModifyOp operation, string type, string[] values) {
  LdapModification mod;
  mod.operation           = operation;
  mod.modification.type   = type;
  mod.modification.values = values.dup;
  return mod;
}

/// Shorthand: add a value to an attribute
LdapModification LdapAddAttr(string type, string[] values) {
  return LdapChange(LdapModifyOp.add_, type, values);
}

/// Shorthand: replace attribute values
LdapModification LdapReplaceAttr(string type, string[] values) {
  return LdapChange(LdapModifyOp.replace, type, values);
}

/// Shorthand: delete attribute (or specific values)
LdapModification LdapDeleteAttr(string type, string[] values = null) {
  return LdapChange(LdapModifyOp.delete_, type, values ? values : []);
}

/// Build an LdapAttribute
LdapAttribute LdapAttr(string type, string[] values) {
  LdapAttribute a;
  a.type   = type;
  a.values = values.dup;
  return a;
}

unittest {
  auto bind = LdapBind("cn=admin,dc=example,dc=com", "secret");
  assert(bind.dn == "cn=admin,dc=example,dc=com");
  assert(bind.version_ == 3);

  auto search = LdapSearch("dc=example,dc=com", "(cn=Alice)");
  assert(search.baseDN == "dc=example,dc=com");
  assert(search.filter == "(cn=Alice)");

  auto ok = LdapSuccess();
  assert(ok.success());

  auto err = LdapFailure(LdapResultCode.invalidCredentials);
  assert(!err.success());

  auto change = LdapAddAttr("mail", ["alice@example.com"]);
  assert(change.operation == LdapModifyOp.add_);
  assert(change.modification.values.length == 1);
}
