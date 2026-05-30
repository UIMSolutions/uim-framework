/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.webdav.models.client;

import uim.webdav;

mixin(ShowModule!());

@safe:

WebDAVResult WebDAVResultOk(ushort statusCode = 200, string message = "ok") {
  WebDAVResult result;
  result.success = true;
  result.statusCode = statusCode;
  result.message = message;
  return result;
}

WebDAVResult WebDAVResultErr(ushort statusCode = 500, string message = "error") {
  WebDAVResult result;
  result.success = false;
  result.statusCode = statusCode;
  result.message = message;
  return result;
}

unittest {
  auto ok = WebDAVResultOk(201, "created");
  assert(ok.success);
  assert(ok.statusCode == 201);
}
