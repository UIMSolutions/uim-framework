/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.store.memory;

import uim.scim;

@safe:

// In-memory SCIM store — stores Users and Groups in associative arrays.
// Suitable for testing and small deployments; not thread-safe.
class UIMScimMemoryStore : UIMObject, IScimUserStore, IScimGroupStore {
  mixin(ShowModule!());

private:
  ScimUser[string]  _users;
  ScimGroup[string] _groups;
  uint              _nextId = 1;

  string generateId() @safe {
    import std.conv : to;
    return "scim-" ~ (_nextId++).to!string;
  }

  // ISO 8601 UTC timestamp (seconds precision)
  static string scimNow() @safe {
    import std.datetime.systime : Clock, SysTime;
    import std.datetime.timezone : UTC;
    import std.format : format;
    auto st = Clock.currTime(UTC());
    return format!"%04d-%02d-%02dT%02d:%02d:%02dZ"(
      st.year, cast(int) st.month, st.day,
      st.hour, st.minute, st.second);
  }

  // ---------- filter helpers -------------------------------------------

  static string getUserAttrText(const ScimUser u, string attr) @safe {
    import std.uni : toLower;
    switch (attr.toLower) {
      case "username":    return u.userName;
      case "displayname": return u.displayName;
      case "nickname":    return u.nickName;
      case "title":       return u.title;
      case "usertype":    return u.userType;
      case "locale":      return u.locale;
      case "timezone":    return u.timezone;
      case "id":          return u.id;
      case "externalid":  return u.externalId;
      default:            return "";
    }
  }

  static string getGroupAttrText(const ScimGroup g, string attr) @safe {
    import std.uni : toLower;
    switch (attr.toLower) {
      case "displayname": return g.displayName;
      case "id":          return g.id;
      case "externalid":  return g.externalId;
      default:            return "";
    }
  }

  static bool filterMatchesUser(const ScimUser u, ScimFilter f) @safe {
    import std.uni : toLower, sicmp;
    import std.algorithm : canFind, startsWith, endsWith;
    import std.string : toLower;

    final switch (f.op) {
      case ScimFilterOp.pr:
        return getUserAttrText(u, f.attrPath).length > 0;
      case ScimFilterOp.eq:
        return sicmp(getUserAttrText(u, f.attrPath), f.value) == 0;
      case ScimFilterOp.ne:
        return sicmp(getUserAttrText(u, f.attrPath), f.value) != 0;
      case ScimFilterOp.co:
        return getUserAttrText(u, f.attrPath).toLower.canFind(f.value.toLower);
      case ScimFilterOp.sw:
        return getUserAttrText(u, f.attrPath).toLower.startsWith(f.value.toLower);
      case ScimFilterOp.ew:
        return getUserAttrText(u, f.attrPath).toLower.endsWith(f.value.toLower);
      case ScimFilterOp.gt:
        return getUserAttrText(u, f.attrPath) > f.value;
      case ScimFilterOp.lt:
        return getUserAttrText(u, f.attrPath) < f.value;
      case ScimFilterOp.ge:
        return getUserAttrText(u, f.attrPath) >= f.value;
      case ScimFilterOp.le:
        return getUserAttrText(u, f.attrPath) <= f.value;
      case ScimFilterOp.not_:
        return f.children.length == 1 ? !filterMatchesUser(u, f.children[0]) : false;
      case ScimFilterOp.and_:
        foreach (c; f.children) { if (!filterMatchesUser(u, c)) return false; }
        return true;
      case ScimFilterOp.or_:
        foreach (c; f.children) { if (filterMatchesUser(u, c)) return true; }
        return false;
    }
  }

  static bool filterMatchesGroup(const ScimGroup g, ScimFilter f) @safe {
    import std.uni : toLower, sicmp;
    import std.algorithm : canFind, startsWith, endsWith;
    import std.string : toLower;

    final switch (f.op) {
      case ScimFilterOp.pr:
        return getGroupAttrText(g, f.attrPath).length > 0;
      case ScimFilterOp.eq:
        return sicmp(getGroupAttrText(g, f.attrPath), f.value) == 0;
      case ScimFilterOp.ne:
        return sicmp(getGroupAttrText(g, f.attrPath), f.value) != 0;
      case ScimFilterOp.co:
        return getGroupAttrText(g, f.attrPath).toLower.canFind(f.value.toLower);
      case ScimFilterOp.sw:
        return getGroupAttrText(g, f.attrPath).toLower.startsWith(f.value.toLower);
      case ScimFilterOp.ew:
        return getGroupAttrText(g, f.attrPath).toLower.endsWith(f.value.toLower);
      case ScimFilterOp.gt:
        return getGroupAttrText(g, f.attrPath) > f.value;
      case ScimFilterOp.lt:
        return getGroupAttrText(g, f.attrPath) < f.value;
      case ScimFilterOp.ge:
        return getGroupAttrText(g, f.attrPath) >= f.value;
      case ScimFilterOp.le:
        return getGroupAttrText(g, f.attrPath) <= f.value;
      case ScimFilterOp.not_:
        return f.children.length == 1 ? !filterMatchesGroup(g, f.children[0]) : false;
      case ScimFilterOp.and_:
        foreach (c; f.children) { if (!filterMatchesGroup(g, c)) return false; }
        return true;
      case ScimFilterOp.or_:
        foreach (c; f.children) { if (filterMatchesGroup(g, c)) return true; }
        return false;
    }
  }

  // Return a page slice from a result set (SCIM uses 1-based startIndex)
  static T[] paginate(T)(T[] items, int startIndex, int count) nothrow {
    if (startIndex < 1) startIndex = 1;
    if (count < 0)      count = 0;
    auto from = startIndex - 1;
    if (from >= cast(int) items.length) return [];
    auto to_ = from + count;
    if (to_ > cast(int) items.length) to_ = cast(int) items.length;
    return items[from .. to_];
  }

  // Apply a patch operation to a User (simple attribute writes only)
  static void applyUserPatch(ScimUser u, ScimPatchRequest req) @safe {
    import std.uni : toLower;
    foreach (op; req.operations) {
      if (op.op == ScimPatchOpType.remove) continue; // skip removes for now
      if (op.values.length == 0)           continue;
      auto v = op.values[0];
      switch (op.path.toLower) {
        case "displayname":    u.displayName    = v; break;
        case "nickname":       u.nickName       = v; break;
        case "title":          u.title          = v; break;
        case "usertype":       u.userType       = v; break;
        case "preferredlanguage": u.preferredLanguage = v; break;
        case "locale":         u.locale         = v; break;
        case "timezone":       u.timezone       = v; break;
        case "active":         u.active = (v == "true"); break;
        case "externalid":     u.externalId     = v; break;
        default: break;
      }
    }
  }

  static void applyGroupPatch(ScimGroup g, ScimPatchRequest req) @safe {
    import std.uni : toLower;
    foreach (op; req.operations) {
      if (op.op == ScimPatchOpType.remove) continue;
      if (op.values.length == 0)           continue;
      switch (op.path.toLower) {
        case "displayname": g.displayName = op.values[0]; break;
        default: break;
      }
    }
  }

public:
  // ===== IScimUserStore ================================================

  ScimUser createUser(ScimUser user) @safe {
    import std.exception : enforce;
    enforce(user !is null, "user must not be null");
    enforce(user.userName.length > 0, "userName is required");
    foreach (u; _users) {
      import std.uni : sicmp;
      enforce(sicmp(u.userName, user.userName) != 0, "userName already taken");
    }
    user.id            = generateId();
    user.schemas       = [ScimSchemaUser];
    user.meta.created      = scimNow();
    user.meta.lastModified = user.meta.created;
    user.meta.resourceType = "User";
    user.meta.location     = "/Users/" ~ user.id;
    _users[user.id] = user;
    return user;
  }

  ScimUser getUser(string id) @safe {
    return (id in _users) ? _users[id] : null;
  }

  ScimUser getUserByName(string userName) @safe {
    import std.uni : sicmp;
    foreach (u; _users) {
      if (sicmp(u.userName, userName) == 0) return u;
    }
    return null;
  }

  ScimUser replaceUser(string id, ScimUser user) @safe {
    if (id !in _users) return null;
    user.id                = id;
    user.schemas           = [ScimSchemaUser];
    user.meta.created      = _users[id].meta.created;
    user.meta.lastModified = scimNow();
    user.meta.resourceType = "User";
    user.meta.location     = "/Users/" ~ id;
    _users[id] = user;
    return user;
  }

  bool patchUser(string id, ScimPatchRequest req) @safe {
    if (id !in _users) return false;
    applyUserPatch(_users[id], req);
    _users[id].meta.lastModified = scimNow();
    return true;
  }

  bool deleteUser(string id) @safe {
    if (id !in _users) return false;
    _users.remove(id);
    return true;
  }

  ScimListResponse!ScimUser listUsers(ScimListRequest req) @safe {
    ScimUser[] all;
    foreach (u; _users) all ~= u;

    if (req.hasFilter) {
      ScimUser[] filtered;
      foreach (u; all) {
        if (filterMatchesUser(u, req.filter)) filtered ~= u;
      }
      all = filtered;
    }

    // Optional sort
    if (req.sortBy.length > 0) {
      import std.algorithm : sort;
      bool asc = req.sortOrder != "descending";
      all.sort!((a, b) {
        auto va = getUserAttrText(a, req.sortBy);
        auto vb = getUserAttrText(b, req.sortBy);
        return asc ? (va < vb) : (va > vb);
      })();
    }

    auto page = paginate(all, req.startIndex, req.count);
    ScimListResponse!ScimUser resp;
    resp.totalResults = cast(int) all.length;
    resp.startIndex   = req.startIndex;
    resp.itemsPerPage = cast(int) page.length;
    resp.resources    = page;
    return resp;
  }

  // ===== IScimGroupStore ===============================================

  ScimGroup createGroup(ScimGroup group) @safe {
    import std.exception : enforce;
    enforce(group !is null, "group must not be null");
    enforce(group.displayName.length > 0, "displayName is required");
    group.id               = generateId();
    group.schemas          = [ScimSchemaGroup];
    group.meta.created     = scimNow();
    group.meta.lastModified = group.meta.created;
    group.meta.resourceType = "Group";
    group.meta.location    = "/Groups/" ~ group.id;
    _groups[group.id] = group;
    return group;
  }

  ScimGroup getGroup(string id) @safe {
    return (id in _groups) ? _groups[id] : null;
  }

  ScimGroup replaceGroup(string id, ScimGroup group) @safe {
    if (id !in _groups) return null;
    group.id                = id;
    group.schemas           = [ScimSchemaGroup];
    group.meta.created      = _groups[id].meta.created;
    group.meta.lastModified = scimNow();
    group.meta.resourceType = "Group";
    group.meta.location     = "/Groups/" ~ id;
    _groups[id] = group;
    return group;
  }

  bool patchGroup(string id, ScimPatchRequest req) @safe {
    if (id !in _groups) return false;
    applyGroupPatch(_groups[id], req);
    _groups[id].meta.lastModified = scimNow();
    return true;
  }

  bool deleteGroup(string id) @safe {
    if (id !in _groups) return false;
    _groups.remove(id);
    return true;
  }

  ScimListResponse!ScimGroup listGroups(ScimListRequest req) @safe {
    ScimGroup[] all;
    foreach (g; _groups) all ~= g;

    if (req.hasFilter) {
      ScimGroup[] filtered;
      foreach (g; all) {
        if (filterMatchesGroup(g, req.filter)) filtered ~= g;
      }
      all = filtered;
    }

    if (req.sortBy.length > 0) {
      import std.algorithm : sort;
      bool asc = req.sortOrder != "descending";
      all.sort!((a, b) {
        auto va = getGroupAttrText(a, req.sortBy);
        auto vb = getGroupAttrText(b, req.sortBy);
        return asc ? (va < vb) : (va > vb);
      })();
    }

    auto page = paginate(all, req.startIndex, req.count);
    ScimListResponse!ScimGroup resp;
    resp.totalResults = cast(int) all.length;
    resp.startIndex   = req.startIndex;
    resp.itemsPerPage = cast(int) page.length;
    resp.resources    = page;
    return resp;
  }

  // ===== unittest ======================================================

  unittest {
    auto store = new UIMScimMemoryStore();

    // --- User create/get -------------------------------------------------
    auto u = new ScimUser();
    u.userName    = "alice";
    u.displayName = "Alice Smith";
    u.active      = true;
    u.emails      = [ScimMultiValue("alice@example.com", "work", true, "Work", "")];

    auto created = store.createUser(u);
    assert(created.id.length > 0);
    assert(created.schemas == [ScimSchemaUser]);
    assert(created.meta.resourceType == "User");

    auto fetched = store.getUser(created.id);
    assert(fetched !is null);
    assert(fetched.userName == "alice");
    assert(fetched.primaryEmail == "alice@example.com");

    auto byName = store.getUserByName("alice");
    assert(byName !is null);
    assert(byName.id == created.id);

    // null for unknown
    assert(store.getUser("no-such-id") is null);
    assert(store.getUserByName("ghost") is null);

    // --- Duplicate userName ----------------------------------------------
    auto u2 = new ScimUser();
    u2.userName = "alice";
    bool threw = false;
    try { store.createUser(u2); }
    catch (Exception) { threw = true; }
    assert(threw, "expected duplicate-userName exception");

    // --- Replace ---------------------------------------------------------
    auto replacement = new ScimUser();
    replacement.userName    = "alice";
    replacement.displayName = "Alice Jones";
    replacement.active      = false;
    auto replaced = store.replaceUser(created.id, replacement);
    assert(replaced !is null);
    assert(replaced.displayName == "Alice Jones");
    assert(!replaced.active);

    // --- Patch -----------------------------------------------------------
    auto patchReq = ScimPatchRequest();
    patchReq.operations ~= scimReplace("displayName", "Alice Z");
    patchReq.operations ~= scimReplace("active", "true");
    assert(store.patchUser(created.id, patchReq));
    assert(store.getUser(created.id).displayName == "Alice Z");
    assert(store.getUser(created.id).active);

    // --- Second user for list tests --------------------------------------
    auto u3 = new ScimUser();
    u3.userName    = "bob";
    u3.displayName = "Bob Builder";
    u3.active      = true;
    store.createUser(u3);

    // list all
    auto all = store.listUsers(scimListRequest());
    assert(all.totalResults == 2);

    // filter by userName eq
    auto req = scimListFiltered(ScimFilter.eq("userName", "bob"));
    auto res = store.listUsers(req);
    assert(res.totalResults == 1);
    assert(res.resources[0].userName == "bob");

    // filter co
    auto req2 = scimListFiltered(ScimFilter.co("displayName", "Alice"));
    auto res2 = store.listUsers(req2);
    assert(res2.totalResults == 1);

    // --- Delete ----------------------------------------------------------
    assert(store.deleteUser(created.id));
    assert(store.getUser(created.id) is null);
    assert(!store.deleteUser(created.id)); // already gone

    // --- Group create/get ------------------------------------------------
    auto g = new ScimGroup();
    g.displayName = "Admins";

    auto cg = store.createGroup(g);
    assert(cg.id.length > 0);
    assert(cg.schemas == [ScimSchemaGroup]);

    auto fetchedG = store.getGroup(cg.id);
    assert(fetchedG !is null);
    assert(fetchedG.displayName == "Admins");

    // add member
    fetchedG.members ~= ScimGroupMember(u3.id, "/Users/" ~ u3.id, "Bob Builder", "User");
    store.replaceGroup(cg.id, fetchedG);
    assert(store.getGroup(cg.id).members.length == 1);

    // patch group name
    auto gp = ScimPatchRequest();
    gp.operations ~= scimReplace("displayName", "Administrators");
    assert(store.patchGroup(cg.id, gp));
    assert(store.getGroup(cg.id).displayName == "Administrators");

    // list groups
    auto allG = store.listGroups(scimListRequest());
    assert(allG.totalResults == 1);

    // filter group
    auto gf = store.listGroups(scimListFiltered(ScimFilter.co("displayName", "Admin")));
    assert(gf.totalResults == 1);

    // delete group
    assert(store.deleteGroup(cg.id));
    assert(store.getGroup(cg.id) is null);
  }
}
