/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.helpers.validate;

import uim.service;

mixin(ShowModule!());

@safe:

bool validateTenant(TenantId tenantId) {
  if (tenantId.isEmpty) {
    throw new UIMValidationException("Tenant ID cannot be empty");
  }

  return validateTenant(tenantId.value);
}

bool validateTenant(string tenantId) {
  return validateId(tenantId, "Tenant ID");
}

bool validateId(string value, string fieldName) {
  if (value.length == 0) {
    throw new UIMValidationException(fieldName ~ " cannot be empty");
  }
  return true;
}

bool validateId(UUID value, string fieldName) {
  if (value == NULLUUID) {
    throw new UIMValidationException(fieldName ~ " should be a valid UUID");
  }
  return true;
}
/**
  * Validates the Authorization header in the request against the expected token in the config.
  * If the config does not require an auth token, this function does nothing.
  * Throws UIMAuthorizationException if validation fails.
  */
bool validateAuth(HTTPServerRequest req, IUIMConfig cfg) {
  if (!cfg.requireAuthToken) {
    return true; // No auth required, allow all requests
  }

  if (!("Authorization" in req.headers)) { // Missing header
    throw new UIMAuthorizationException("Missing Authorization header");
  }

  auto expected = "Bearer " ~ cfg.authToken;
  if (req.headers["Authorization"] != expected) { // Invalid token
    throw new UIMAuthorizationException("Invalid Authorization token");
  }

  // Auth is valid
  return true;
}
// private void validateAuth(HTTPServerRequest req) {
//   if (!_service.config.requireAuthToken)
//     return;
//   auto authHeader = req.headers.get("Authorization", "");
//   if (!authHeader.startsWith("Bearer "))
//     throw new PDMAuthorizationException("Missing bearer token");
//   auto token = authHeader[7 .. $];
//   if (token != _service.config.authToken)
//     throw new PDMAuthorizationException("Invalid bearer token");
// }

string[] segments(string path) {
  return path.split("/").filter!(p => p.length > 0).array;
}
///
unittest {
  assert(segments("/v1/tenants/123") == ["v1", "tenants", "123"]);
  assert(segments("") == []);
  assert(segments("/") == []);
  assert(segments("foo") == ["foo"]);
}

bool validateString(string value, string fieldName) {
  if (value.length == 0) {
    throw new UIMValidationException(fieldName ~ " cannot be empty");
  }
  return true;
}
