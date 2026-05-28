/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.schemas.resource;

@safe:

// SCIM 2.0 well-known schema URNs (RFC 7643 §7)
enum string ScimSchemaUser            = "urn:ietf:params:scim:schemas:core:2.0:User";
enum string ScimSchemaGroup           = "urn:ietf:params:scim:schemas:core:2.0:Group";
enum string ScimSchemaEnterpriseUser  = "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User";
enum string ScimSchemaListResponse    = "urn:ietf:params:scim:api:messages:2.0:ListResponse";
enum string ScimSchemaError           = "urn:ietf:params:scim:api:messages:2.0:Error";
enum string ScimSchemaPatchOp         = "urn:ietf:params:scim:api:messages:2.0:PatchOp";
enum string ScimSchemaServiceProvider = "urn:ietf:params:scim:schemas:core:2.0:ServiceProviderConfig";
enum string ScimSchemaResourceType    = "urn:ietf:params:scim:schemas:core:2.0:ResourceType";
enum string ScimSchemaSchema          = "urn:ietf:params:scim:schemas:core:2.0:Schema";

// Resource metadata (RFC 7643 §3.1)
struct ScimMeta {
  string resourceType;
  string created;       // ISO 8601 datetime
  string lastModified;  // ISO 8601 datetime
  string location;      // canonical URI of the resource
  string version_;      // ETag / opaque version token
}

// Base class for all SCIM resources
class ScimResource {
  string   id;
  string   externalId;
  string[] schemas;
  ScimMeta meta;
}

// SCIM error response body (RFC 7644 §3.12)
struct ScimError {
  string[] schemas    = [ScimSchemaError];
  string   detail;
  int      status;

  unittest {
    auto e = ScimError([ScimSchemaError], "Resource not found", 404);
    assert(e.status == 404);
    assert(e.schemas[0] == ScimSchemaError);
  }
}
