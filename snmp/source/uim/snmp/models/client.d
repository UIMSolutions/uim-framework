/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.snmp.models.client;

import uim.snmp;

mixin(ShowModule!());

@safe:

SNMPResult SNMPResultOk(ushort statusCode = 200, string message = "ok") {
  SNMPResult result;
  result.success = true;
  result.statusCode = statusCode;
  result.message = message;
  return result;
}

SNMPResult SNMPResultErr(ushort statusCode = 500, string message = "error") {
  SNMPResult result;
  result.success = false;
  result.statusCode = statusCode;
  result.message = message;
  return result;
}

SNMPOidValue SNMPOidValueEmpty(string oid = "") {
  SNMPOidValue value;
  value.oid = oid;
  value.typeTag = "";
  value.value = "";
  value.timestamp = 0;
  return value;
}

unittest {
  auto ok = SNMPResultOk(200, "done");
  assert(ok.success);

  auto empty = SNMPOidValueEmpty("1.3.6.1.2.1.1.1.0");
  assert(empty.oid.length > 0);
}
