/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.schemas.group;

import uim.scim.schemas.resource;

@safe:

// Group member reference (RFC 7643 §4.2)
struct ScimGroupMember {
  string value;    // user or nested group id
  string ref_;     // $ref — URI of the member resource
  string display;  // displayName of the member
  string type;     // "User" or "Group"
}

// SCIM Group resource (RFC 7643 §4.2)
// Schema URN: urn:ietf:params:scim:schemas:core:2.0:Group
class ScimGroup : ScimResource {
  string            displayName;
  ScimGroupMember[] members;

  // Convenience: check if a user id is a direct member
  bool hasMember(string userId) const nothrow {
    foreach (m; members) {
      if (m.value == userId) return true;
    }
    return false;
  }

  // Add a member if not already present; returns true if added
  bool addMember(ScimGroupMember member) {
    if (hasMember(member.value)) return false;
    members ~= member;
    return true;
  }

  // Remove a member by user id; returns true if removed
  bool removeMember(string userId) {
    foreach (i, m; members) {
      if (m.value == userId) {
        members = members[0 .. i] ~ members[i + 1 .. $];
        return true;
      }
    }
    return false;
  }

  unittest {
    auto g = new ScimGroup();
    g.displayName = "Admins";

    assert(!g.hasMember("u-1"));
    assert(g.addMember(ScimGroupMember("u-1", "/Users/u-1", "Alice", "User")));
    assert(g.hasMember("u-1"));
    assert(!g.addMember(ScimGroupMember("u-1", "/Users/u-1", "Alice", "User"))); // duplicate

    assert(g.removeMember("u-1"));
    assert(!g.hasMember("u-1"));
    assert(!g.removeMember("u-1")); // already gone
  }
}
