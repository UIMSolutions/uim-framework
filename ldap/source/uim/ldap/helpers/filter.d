/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ldap.helpers.filter;

import std.array  : appender, Appender;
import std.string : strip;

@safe:

// ---------------------------------------------------------------------------
// Low-level filter string escaping (RFC 4515 §3)
// ---------------------------------------------------------------------------

/// Escape a value string for use in an LDAP filter assertion
string ldapEscapeFilterValue(string value) {
  auto buf = appender!string;
  buf.reserve(value.length + 8);
  import std.string : representation;
  foreach (ubyte c; value.representation) {
    switch (c) {
      case '\\': buf ~= "\\5c"; break;
      case '*':  buf ~= "\\2a"; break;
      case '(':  buf ~= "\\28"; break;
      case ')':  buf ~= "\\29"; break;
      case '\0': buf ~= "\\00"; break;
      default:   buf ~= cast(char) c;
    }
  }
  return buf.data;
}

// ---------------------------------------------------------------------------
// Filter builder (fluent API)
// ---------------------------------------------------------------------------

/// Build simple equality filter: (type=value)
string ldapFilterEq(string attributeType, string value) {
  return "(" ~ attributeType ~ "=" ~ ldapEscapeFilterValue(value) ~ ")";
}

/// Build presence filter: (type=*)
string ldapFilterPresent(string attributeType) {
  return "(" ~ attributeType ~ "=*)";
}

/// Build substring filter: (type=*value*) — adds leading/trailing wildcards
string ldapFilterContains(string attributeType, string value) {
  return "(" ~ attributeType ~ "=*" ~ ldapEscapeFilterValue(value) ~ "*)";
}

/// Build starts-with filter: (type=value*)
string ldapFilterStartsWith(string attributeType, string value) {
  return "(" ~ attributeType ~ "=" ~ ldapEscapeFilterValue(value) ~ "*)";
}

/// Build ends-with filter: (type=*value)
string ldapFilterEndsWith(string attributeType, string value) {
  return "(" ~ attributeType ~ "=*" ~ ldapEscapeFilterValue(value) ~ ")";
}

/// Build NOT filter: (!(inner))
string ldapFilterNot(string inner) {
  return "(!" ~ inner ~ ")";
}

/// Build AND filter: (&(f1)(f2)...(fN))
string ldapFilterAnd(string[] filters...) {
  if (filters.length == 0) {
    return "";
  }

  auto buf = appender!string;
  buf ~= "(&";
  foreach (f; filters) {
    buf ~= f;
  }
  buf ~= ")";
  return buf.data;
}

/// Build OR filter: (|(f1)(f2)...(fN))
string ldapFilterOr(string[] filters...) {
  if (filters.length == 0) {
    return "";
  }

  auto buf = appender!string;
  buf ~= "(|";
  foreach (f; filters) {
    buf ~= f;
  }
  buf ~= ")";
  return buf.data;
}

/// Build greater-or-equal filter: (type>=value)
string ldapFilterGe(string attributeType, string value) {
  return "(" ~ attributeType ~ ">=" ~ ldapEscapeFilterValue(value) ~ ")";
}

/// Build less-or-equal filter: (type<=value)
string ldapFilterLe(string attributeType, string value) {
  return "(" ~ attributeType ~ "<=" ~ ldapEscapeFilterValue(value) ~ ")";
}

/// Build approximate match filter: (type~=value)
string ldapFilterApprox(string attributeType, string value) {
  return "(" ~ attributeType ~ "~=" ~ ldapEscapeFilterValue(value) ~ ")";
}

unittest {
  assert(ldapEscapeFilterValue("a*(b)\\c\0") == "a\\2a\\28b\\29\\5cc\\00");
  assert(ldapFilterEq("cn", "Alice") == "(cn=Alice)");
  assert(ldapFilterPresent("mail") == "(mail=*)");
  assert(ldapFilterContains("cn", "ali") == "(cn=*ali*)");
  assert(ldapFilterNot("(cn=Alice)") == "(!(cn=Alice))");
  assert(ldapFilterAnd("(cn=Alice)", "(objectClass=person)")
    == "(&(cn=Alice)(objectClass=person))");
  assert(ldapFilterOr("(cn=Alice)", "(cn=Bob)")
    == "(|(cn=Alice)(cn=Bob))");
}
