/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opcua.models.client;

import uim.opcua;

mixin(ShowModule!());

@safe:

OPCUAResult OPCUAResultOk(
  ushort statusCode = 200,
  string message = "ok",
  string serviceResponse = ""
) {
  OPCUAResult result;
  result.success = true;
  result.statusCode = statusCode;
  result.message = message;
  result.serviceResponse = serviceResponse;
  return result;
}

OPCUAResult OPCUAResultErr(
  ushort statusCode = 500,
  string message = "error",
  string serviceResponse = ""
) {
  OPCUAResult result;
  result.success = false;
  result.statusCode = statusCode;
  result.message = message;
  result.serviceResponse = serviceResponse;
  return result;
}

OPCUANodeRead OPCUANodeReadEmpty() {
  OPCUANodeRead value;
  return value;
}

unittest {
  auto ok = OPCUAResultOk(200, "accepted", "Good");
  assert(ok.success);
  assert(ok.serviceResponse.length > 0);
}
