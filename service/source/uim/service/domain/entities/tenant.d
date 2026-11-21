/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.entities.tenant;

import uim.service;

mixin(ShowModule!());

@safe:
/// Represents a tenant in the system, which is an organizational unit that can have multiple users and resources.
struct Tenant {
  TenantId id;
  string name;
  string subdomain;
  SsoProtocol defaultSsoProtocol = SsoProtocol.oidc;
  AuthMethod[] allowedAuthMethods;
  bool mfaEnforced;
  string[] trustedIdpIds;
  long createdAt;
  long updatedAt;

  Json toJson() const {
    return Json.emptyObject
      .set("id", id)
      .set("name", name)
      .set("subdomain", subdomain)
      .set("defaultSsoProtocol", defaultSsoProtocol.to!string)
      .set("allowedAuthMethods", allowedAuthMethods.map!(a => a.to!string)
          .array.toJson)
      .set("mfaEnforced", mfaEnforced)
      .set("trustedIdpIds", trustedIdpIds.toJson)
      .set("createdAt", createdAt)
      .set("updatedAt", updatedAt);
  }
}
///
unittest {
  import uim.service.ports.repositories.tenant;
  import uim.service.domain.entities.tenant;

  Tenant tenant;
  tenant.id = TenantId("tenant-123");
  tenant.name = "Example Tenant";
  tenant.subdomain = "example";
  tenant.defaultSsoProtocol = SsoProtocol.saml;
  tenant.allowedAuthMethods = [AuthMethod.spnego, AuthMethod.form];
  tenant.mfaEnforced = true;
  tenant.trustedIdpIds = ["idp-1", "idp-2"];
  tenant.createdAt = 1620000000;
  tenant.updatedAt = 1625000000;

  Json json = tenant.toJson();
  assert(json["id"] == "tenant-123".toJson);
  assert(json["name"] == "Example Tenant".toJson);
  assert(json["subdomain"] == "example".toJson);
  assert(json["defaultSsoProtocol"] == "saml".toJson);
  assert(json["allowedAuthMethods"].toArray[0] == "spnego".toJson);
  assert(json["allowedAuthMethods"].toArray[1] == "form".toJson);
  assert(json["mfaEnforced"] == true.toJson);
  assert(json["trustedIdpIds"].toArray[0] == "idp-1".toJson);
  assert(json["trustedIdpIds"].toArray[1] == "idp-2".toJson);
  assert(json["createdAt"] == 1620000000.toJson);
  assert(json["updatedAt"] == 1625000000.toJson);
}
