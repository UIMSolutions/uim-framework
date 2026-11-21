/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Caller context passed from every driving adapter (HTTP, OData, CLI, GUI)
/// into the application. Adapters resolve it; the application only reads it.
module uim.service.ports.services.context;

import uim.service;

mixin(ShowModule!());

@safe:

/// Who calls, for which tenant, and through which channel.
struct RequestContext {
  string tenantId; /// tenant (zone) the call is scoped to
  string userId; /// technical user id ("" = anonymous)
  string userName; /// display name, if known
  string[] scopes; /// granted scopes (e.g. "auditlog.Read")
  string channel = "api"; /// "http", "odata", "cli", "gui", ...
  bool authenticated; /// true if derived from a (decoded) token

  /// True if the caller holds the scope. Scopes are matched exactly or by
  /// their local part, so "Read" matches "xsappname!t1.Read".
  bool hasScope(string scope_) const {
    foreach (s; scopes) {
      if (s == scope_)
        return true;
      auto dot = s.lastIndexOf('.');
      if (dot >= 0 && s[dot + 1 .. $] == scope_)
        return true;
    }
    return false;
  }

  /// The user id, or "anonymous".
  string actor() const {
    return userId.length > 0 ? userId : "anonymous";
  }

  /// A context for local adapters (CLI, GUI) that are trusted by construction.
  static RequestContext local(string tenantId, string channel, string userId = "") {
    RequestContext ctx;
    ctx.tenantId = tenantId;
    ctx.channel = channel;
    ctx.userId = userId;
    return ctx;
  }
}

///
unittest {
  mixin(ShowTest!("RequestContext"));

  RequestContext ctx;
  ctx.scopes = ["app!t1.Read", "Admin"];
  assert(ctx.hasScope("Read"));
  assert(ctx.hasScope("Admin"));
  assert(!ctx.hasScope("Write"));
  assert(ctx.actor == "anonymous");
  assert(RequestContext.local("t1", "cli").channel == "cli");
}
