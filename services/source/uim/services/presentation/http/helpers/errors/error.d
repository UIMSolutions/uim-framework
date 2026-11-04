/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.http.helpers.errors.error;

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