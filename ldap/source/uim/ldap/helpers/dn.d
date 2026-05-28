/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ldap.helpers.dn;

import std.string : strip, split, join;
import std.array  : appender;

@safe:

/// Normalize a Distinguished Name: trim whitespace around components
string ldapNormalizeDN(string dn) {
  auto trimmed = dn.strip;
  if (trimmed.length == 0) {
    return "";
  }

  auto parts = trimmed.split(',');
  auto result = appender!(string[])();
  foreach (part; parts) {
    result ~= part.strip;
  }
  return result.data.join(',');
}

/// Build a DN from an array of RDN strings ("cn=Alice", "dc=example", "dc=com")
string ldapBuildDN(string[] rdns) {
  if (rdns.length == 0) {
    return "";
  }

  auto result = appender!(string[])();
  foreach (rdn; rdns) {
    auto trimmed = rdn.strip;
    if (trimmed.length > 0) {
      result ~= trimmed;
    }
  }
  return result.data.join(',');
}

/// Return the RDN (first component) of a DN
string ldapRDN(string dn) {
  auto normalized = ldapNormalizeDN(dn);
  if (normalized.length == 0) {
    return "";
  }

  auto parts = normalized.split(',');
  return parts.length > 0 ? parts[0] : "";
}

/// Return the parent DN (all components after the first)
string ldapParentDN(string dn) {
  auto normalized = ldapNormalizeDN(dn);
  if (normalized.length == 0) {
    return "";
  }

  auto parts = normalized.split(',');
  if (parts.length <= 1) {
    return "";
  }
  return parts[1 .. $].join(',');
}

/// Return true if `childDN` is equal to or subordinate to `baseDN`
bool ldapIsUnderBase(string childDN, string baseDN) {
  import std.uni : toLower;
  auto child = ldapNormalizeDN(childDN).toLower;
  auto base  = ldapNormalizeDN(baseDN).toLower;
  if (base.length == 0) {
    return true;
  }
  if (child.length < base.length) {
    return false;
  }
  if (child == base) {
    return true;
  }
  // child must end with ",base"
  return child.length > base.length
      && child[$ - base.length .. $] == base
      && child[$ - base.length - 1] == ',';
}

unittest {
  assert(ldapNormalizeDN("cn=Alice , dc=example , dc=com") == "cn=Alice,dc=example,dc=com");
  assert(ldapRDN("cn=Alice,dc=example,dc=com") == "cn=Alice");
  assert(ldapParentDN("cn=Alice,dc=example,dc=com") == "dc=example,dc=com");
  assert(ldapBuildDN(["cn=Alice", "dc=example", "dc=com"]) == "cn=Alice,dc=example,dc=com");
  assert(ldapIsUnderBase("cn=Alice,dc=example,dc=com", "dc=example,dc=com"));
  assert(!ldapIsUnderBase("dc=other,dc=com", "dc=example,dc=com"));
  assert(ldapIsUnderBase("dc=example,dc=com", "dc=example,dc=com"));
}
