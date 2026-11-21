/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.helpers.network;

import uim.service;

mixin(ShowModule!());

@safe:

/**
  * Helper to send error responses in a consistent format.
  *
  * @param res The HTTP response object to write to
  * @param message A human-readable error message
  * @param statusCode The HTTP status code to use (e.g. 400, 404, 500)
  */
void respondError(HTTPServerResponse res, string message, int statusCode) {
  Json payload = Json.emptyObject
    .set("success", false)
    .set("message", message)
    .set("statusCode", statusCode);

  res.writeJsonBody(payload, statusCode);
}

/**
  * Helper to normalize URL path segments for easier routing.
  * It trims leading and trailing slashes and splits the path into segments.
  * @param subPath The URL path after the base path (e.g. "/v1/tenants/123")
  * @return An array of path segments (e.g. ["v1", "tenants", "123"]) or null if the path is empty
  */
string[] normalizedSegments(string subPath) {
  auto clean = subPath;
  if (clean.length > 0 && clean[0] == '/') {
    clean = clean[1 .. $];
  }
  if (clean.length > 0 && clean[$ - 1] == '/') {
    clean = clean[0 .. $ - 1];
  }
  if (clean.length == 0) {
    return null;
  }
  return clean.split("/");
}
// private static string[] normalizedSegments(string path) {
//   auto parts = path.split("/");
//   string[] segs;
//   foreach (p; parts)
//     if (p.length > 0)
//       segs ~= p;
//   return segs;
// }

/**
  * Helper to safely parse JSON body from an HTTP request.
  * If parsing fails, it returns an empty JSON object instead of throwing an error.
  * @param req The HTTP request object to read from
  * @return The parsed JSON object, or an empty JSON object if parsing fails
  */
Json parseBody(HTTPServerRequest req) {
  try
  {
    return req.json();
  }
  catch (Exception) {
    return Json.emptyObject;
  }
}
