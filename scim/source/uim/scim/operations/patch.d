/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.operations.patch;

import uim.scim.schemas.resource : ScimSchemaPatchOp;

@safe:

// SCIM PATCH operation type (RFC 7644 §3.5.2)
enum ScimPatchOpType {
  add,
  remove,
  replace,
}

// A single operation within a PATCH request
struct ScimPatchOperation {
  ScimPatchOpType op;
  string          path;    // attribute path (e.g., "emails[type eq \"work\"].value")
  string[]        values;  // one or more values to set (empty for remove)
}

// SCIM PATCH request body (RFC 7644 §3.5.2)
struct ScimPatchRequest {
  string[]              schemas    = [ScimSchemaPatchOp];
  ScimPatchOperation[]  operations;

  unittest {
    auto req = ScimPatchRequest();
    req.operations ~= ScimPatchOperation(ScimPatchOpType.replace, "displayName", ["Bob Jones"]);
    req.operations ~= ScimPatchOperation(ScimPatchOpType.replace, "active",      ["false"]);
    req.operations ~= ScimPatchOperation(ScimPatchOpType.remove,  "password",    []);

    assert(req.schemas == [ScimSchemaPatchOp]);
    assert(req.operations.length == 3);
    assert(req.operations[0].op == ScimPatchOpType.replace);
    assert(req.operations[0].values[0] == "Bob Jones");
    assert(req.operations[2].op == ScimPatchOpType.remove);
  }
}

// Convenience constructors
ScimPatchOperation scimAdd(string path, string[] values) nothrow {
  return ScimPatchOperation(ScimPatchOpType.add, path, values);
}

ScimPatchOperation scimReplace(string path, string value) nothrow {
  return ScimPatchOperation(ScimPatchOpType.replace, path, [value]);
}

ScimPatchOperation scimRemove(string path) nothrow {
  return ScimPatchOperation(ScimPatchOpType.remove, path, []);
}
