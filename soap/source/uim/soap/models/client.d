/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.soap.models.client;

import uim.soap;

mixin(ShowModule!());

@safe:

SOAPResult SOAPResultOk(
  ushort statusCode = 200,
  string message = "ok",
  string payload = ""
) {
  SOAPResult result;
  result.success = true;
  result.statusCode = statusCode;
  result.message = message;
  result.payload = payload;
  return result;
}

SOAPResult SOAPResultErr(
  ushort statusCode = 500,
  string message = "error",
  string payload = ""
) {
  SOAPResult result;
  result.success = false;
  result.statusCode = statusCode;
  result.message = message;
  result.payload = payload;
  return result;
}

SOAPEnvelope SOAPEnvelopeEmpty() {
  SOAPEnvelope envelope;
  return envelope;
}

unittest {
  auto ok = SOAPResultOk(200, "accepted", "<ok/>");
  assert(ok.success);
  assert(ok.payload.length > 0);
}
