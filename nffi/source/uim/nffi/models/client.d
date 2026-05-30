/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.nffi.models.client;

import uim.nffi;

mixin(ShowModule!());

@safe:

NFFIResult NFFIResultOk(
  ushort statusCode = 200,
  string message = "ok",
  string referenceId = ""
) {
  NFFIResult result;
  result.success = true;
  result.statusCode = statusCode;
  result.message = message;
  result.referenceId = referenceId;
  return result;
}

NFFIResult NFFIResultErr(
  ushort statusCode = 500,
  string message = "error",
  string referenceId = ""
) {
  NFFIResult result;
  result.success = false;
  result.statusCode = statusCode;
  result.message = message;
  result.referenceId = referenceId;
  return result;
}

NFFITrack NFFITrackEmpty(string unitId = "") {
  NFFITrack track;
  track.unitId = unitId;
  return track;
}

unittest {
  auto ok = NFFIResultOk(200, "published", "nffi-001");
  assert(ok.success);
  assert(ok.referenceId.length > 0);
}
