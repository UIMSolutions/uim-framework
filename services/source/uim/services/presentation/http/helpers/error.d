module uim.services.presentation.http.helpers.error;

import uim.services;

mixin(ShowModule!());

@safe:
/// Write a JSON error response.
void writeError(scope HTTPServerResponse res, int status, string message) {
  auto error = Json.emptyObject;
  error["error"] = Json(message);
  error["status"] = Json(status);
  // j["code"] = Json(code);
  res.writeJsonBody(error, status);
}