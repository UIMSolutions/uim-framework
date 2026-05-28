/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ldap.interfaces.types;

@safe:

// ---------------------------------------------------------------------------
// LDAP result codes (RFC 4511 §4.1.9)
// ---------------------------------------------------------------------------
enum LdapResultCode : int {
  success                     = 0,
  operationsError             = 1,
  protocolError               = 2,
  timeLimitExceeded           = 3,
  sizeLimitExceeded           = 4,
  compareFalse                = 5,
  compareTrue                 = 6,
  authMethodNotSupported      = 7,
  strongerAuthRequired        = 8,
  referral                    = 10,
  adminLimitExceeded          = 11,
  unavailableCriticalExtension= 12,
  confidentialityRequired     = 13,
  saslBindInProgress          = 14,
  noSuchAttribute             = 16,
  undefinedAttributeType      = 17,
  inappropriateMatching       = 18,
  constraintViolation         = 19,
  attributeOrValueExists      = 20,
  invalidAttributeSyntax      = 21,
  noSuchObject                = 32,
  aliasProblem                = 33,
  invalidDNSyntax             = 34,
  aliasDereferencingProblem   = 36,
  inappropriateAuthentication = 48,
  invalidCredentials          = 49,
  insufficientAccessRights    = 50,
  busy                        = 51,
  unavailable                 = 52,
  unwillingToPerform          = 53,
  loopDetect                  = 54,
  namingViolation             = 64,
  objectClassViolation        = 65,
  notAllowedOnNonLeaf         = 66,
  notAllowedOnRDN             = 67,
  entryAlreadyExists          = 68,
  objectClassModsProhibited   = 69,
  affectsMultipleDSAs         = 71,
  other                       = 80
}

// ---------------------------------------------------------------------------
// LDAP scope for search operations (RFC 4511 §4.5.1)
// ---------------------------------------------------------------------------
enum LdapScope : int {
  baseObject   = 0,
  singleLevel  = 1,
  wholeSubtree = 2
}

// ---------------------------------------------------------------------------
// LDAP deref aliases (RFC 4511 §4.5.1)
// ---------------------------------------------------------------------------
enum LdapDerefAliases : int {
  neverDerefAliases  = 0,
  derefInSearching   = 1,
  derefFindingBaseObj= 2,
  derefAlways        = 3
}

// ---------------------------------------------------------------------------
// LDAP modify operation type (RFC 4511 §4.6)
// ---------------------------------------------------------------------------
enum LdapModifyOp : int {
  add_     = 0,
  delete_  = 1,
  replace  = 2
}

// ---------------------------------------------------------------------------
// Core data structures
// ---------------------------------------------------------------------------

/// A single LDAP attribute value pair
struct LdapAttribute {
  string   type;
  string[] values;
}

/// An LDAP entry returned from a search
struct LdapEntry {
  string          dn;
  LdapAttribute[] attributes;

  /// Return all values for the named attribute (case-insensitive)
  string[] attr(string name) const @safe {
    import std.uni : toLower;
    auto lower = name.toLower;
    foreach (ref a; attributes) {
      if (a.type.toLower == lower) {
        return a.values.dup;
      }
    }
    return null;
  }

  /// Return the first value for the named attribute or empty string
  string firstAttr(string name) const @safe {
    auto vals = attr(name);
    return vals.length > 0 ? vals[0] : "";
  }
}

/// A single modify change (RFC 4511)
struct LdapModification {
  LdapModifyOp   operation;
  LdapAttribute  modification;
}

// ---------------------------------------------------------------------------
// Request / response structs
// ---------------------------------------------------------------------------

struct LdapBindRequest {
  string dn;
  string password;
  int    version_ = 3;
}

struct LdapSearchRequest {
  string         baseDN;
  LdapScope      scope_          = LdapScope.wholeSubtree;
  LdapDerefAliases derefAliases  = LdapDerefAliases.neverDerefAliases;
  int            sizeLimit       = 0;
  int            timeLimit       = 0;
  bool           typesOnly       = false;
  string         filter          = "(objectClass=*)";
  string[]       attributes;
}

struct LdapAddRequest {
  string          dn;
  LdapAttribute[] attributes;
}

struct LdapModifyRequest {
  string              dn;
  LdapModification[]  changes;
}

struct LdapDeleteRequest {
  string dn;
}

struct LdapModifyDNRequest {
  string dn;
  string newRDN;
  bool   deleteOldRDN = true;
  string newSuperior;
}

struct LdapCompareRequest {
  string dn;
  string attributeType;
  string assertionValue;
}

struct LdapResult {
  LdapResultCode resultCode    = LdapResultCode.success;
  string         matchedDN;
  string         diagnosticMessage;
  bool           success() const @safe { return resultCode == LdapResultCode.success; }
}

struct LdapSearchResult {
  LdapResult  result;
  LdapEntry[] entries;
}

struct LdapCompareResult {
  LdapResult result;
  bool       matched = false;
}

// ---------------------------------------------------------------------------
// Aliases for delegate types
// ---------------------------------------------------------------------------

alias LdapEntryHandler  = void delegate(LdapEntry entry) @safe;
alias LdapResultHandler = void delegate(LdapResult result) @safe;

// ---------------------------------------------------------------------------
// Connection interface
// ---------------------------------------------------------------------------

interface ILdapConnection {
  @property bool     connected() const @safe;
  @property string   host()      const @safe;
  @property ushort   port()      const @safe;
  @property bool     useTLS()    const @safe;

  bool connect() @safe;
  void disconnect() @safe;

  LdapResult       bind(LdapBindRequest request) @safe;
  LdapResult       unbind() @safe;

  LdapSearchResult search(LdapSearchRequest request) @safe;
  LdapResult       add(LdapAddRequest request) @safe;
  LdapResult       modify(LdapModifyRequest request) @safe;
  LdapResult       remove(LdapDeleteRequest request) @safe;
  LdapResult       modifyDN(LdapModifyDNRequest request) @safe;
  LdapCompareResult compare(LdapCompareRequest request) @safe;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

string ldapResultText(LdapResultCode code) pure nothrow @safe {
  switch (code) {
    case LdapResultCode.success:                      return "Success";
    case LdapResultCode.operationsError:              return "Operations error";
    case LdapResultCode.protocolError:                return "Protocol error";
    case LdapResultCode.timeLimitExceeded:            return "Time limit exceeded";
    case LdapResultCode.sizeLimitExceeded:            return "Size limit exceeded";
    case LdapResultCode.compareFalse:                 return "Compare false";
    case LdapResultCode.compareTrue:                  return "Compare true";
    case LdapResultCode.authMethodNotSupported:       return "Auth method not supported";
    case LdapResultCode.strongerAuthRequired:         return "Stronger auth required";
    case LdapResultCode.referral:                     return "Referral";
    case LdapResultCode.adminLimitExceeded:           return "Admin limit exceeded";
    case LdapResultCode.unavailableCriticalExtension: return "Unavailable critical extension";
    case LdapResultCode.confidentialityRequired:      return "Confidentiality required";
    case LdapResultCode.saslBindInProgress:           return "SASL bind in progress";
    case LdapResultCode.noSuchAttribute:              return "No such attribute";
    case LdapResultCode.undefinedAttributeType:       return "Undefined attribute type";
    case LdapResultCode.inappropriateMatching:        return "Inappropriate matching";
    case LdapResultCode.constraintViolation:          return "Constraint violation";
    case LdapResultCode.attributeOrValueExists:       return "Attribute or value exists";
    case LdapResultCode.invalidAttributeSyntax:       return "Invalid attribute syntax";
    case LdapResultCode.noSuchObject:                 return "No such object";
    case LdapResultCode.aliasProblem:                 return "Alias problem";
    case LdapResultCode.invalidDNSyntax:              return "Invalid DN syntax";
    case LdapResultCode.aliasDereferencingProblem:    return "Alias dereferencing problem";
    case LdapResultCode.inappropriateAuthentication:  return "Inappropriate authentication";
    case LdapResultCode.invalidCredentials:           return "Invalid credentials";
    case LdapResultCode.insufficientAccessRights:     return "Insufficient access rights";
    case LdapResultCode.busy:                         return "Busy";
    case LdapResultCode.unavailable:                  return "Unavailable";
    case LdapResultCode.unwillingToPerform:           return "Unwilling to perform";
    case LdapResultCode.loopDetect:                   return "Loop detect";
    case LdapResultCode.namingViolation:              return "Naming violation";
    case LdapResultCode.objectClassViolation:         return "Object class violation";
    case LdapResultCode.notAllowedOnNonLeaf:          return "Not allowed on non-leaf";
    case LdapResultCode.notAllowedOnRDN:              return "Not allowed on RDN";
    case LdapResultCode.entryAlreadyExists:           return "Entry already exists";
    case LdapResultCode.objectClassModsProhibited:    return "Object class mods prohibited";
    case LdapResultCode.affectsMultipleDSAs:          return "Affects multiple DSAs";
    default:                                          return "Other";
  }
}
