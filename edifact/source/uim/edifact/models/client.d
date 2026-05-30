/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.edifact.models.client;

import uim.edifact;

mixin(ShowModule!());

@safe:

EDIFACTResult EDIFACTResultOk(
  ushort statusCode = 200,
  string message = "ok",
  string controlReference = ""
) {
  EDIFACTResult result;
  result.success = true;
  result.statusCode = statusCode;
  result.message = message;
  result.controlReference = controlReference;
  return result;
}

EDIFACTResult EDIFACTResultErr(
  ushort statusCode = 500,
  string message = "error",
  string controlReference = ""
) {
  EDIFACTResult result;
  result.success = false;
  result.statusCode = statusCode;
  result.message = message;
  result.controlReference = controlReference;
  return result;
}

EDIFACTMessage EDIFACTMessageEmpty() {
  EDIFACTMessage message;
  return message;
}

unittest {
  auto ok = EDIFACTResultOk(200, "accepted", "ref-1");
  assert(ok.success);
  assert(ok.controlReference == "ref-1");
}
