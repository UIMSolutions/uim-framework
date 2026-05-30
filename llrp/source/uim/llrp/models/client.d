/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.llrp.models.client;

import uim.llrp;

mixin(ShowModule!());

@safe:

LLRPResult LLRPResultOk(
  ushort statusCode = 200,
  string message = "ok",
  string responseFrame = ""
) {
  LLRPResult result;
  result.success = true;
  result.statusCode = statusCode;
  result.message = message;
  result.responseFrame = responseFrame;
  return result;
}

LLRPResult LLRPResultErr(
  ushort statusCode = 500,
  string message = "error",
  string responseFrame = ""
) {
  LLRPResult result;
  result.success = false;
  result.statusCode = statusCode;
  result.message = message;
  result.responseFrame = responseFrame;
  return result;
}

LLRPMessage LLRPMessageEmpty() {
  LLRPMessage message;
  return message;
}

unittest {
  auto ok = LLRPResultOk(200, "accepted", "ACK");
  assert(ok.success);
  assert(ok.responseFrame.length > 0);
}
