/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdc.service;

import core.time : msecs;
import std.file : exists, isFile;
import std.stdio : File;

import vibe.d : runTask, sleep;

import uim.cdc;

mixin(ShowModule!());

@safe:

size_t cdcTryWriteDevice(string filePath, const(ubyte)[] payload) {
  if (filePath.length == 0 || payload.length == 0) {
    return 0;
  }

  if (!(exists(filePath) && isFile(filePath))) {
    return 0;
  }

  try {
    auto fp = File(filePath, "ab");
    fp.rawWrite(payload);
    fp.close();
    return payload.length;
  } catch (Exception) {
    return 0;
  }
}

ubyte[] cdcTryReadDevice(string filePath, uint timeoutMs, bool newlineDelimited) {
  if (filePath.length == 0) {
    return null;
  }

  if (!(exists(filePath) && isFile(filePath))) {
    return null;
  }

  auto effectiveTimeout = timeoutMs == 0 ? 1 : timeoutMs;
  auto timeoutTick = cast(size_t) effectiveTimeout;

  foreach (_; 0 .. timeoutTick) {
    try {
      auto fp = File(filePath, "rb");
      ubyte[2048] buffer;
      auto chunk = fp.rawRead(buffer[]);
      fp.close();

      if (chunk.length > 0) {
        auto payload = chunk.dup;
        if (newlineDelimited) {
          auto endPos = cdcFindFrameEnd(payload, true);
          if (endPos > 0 && endPos <= payload.length) {
            return payload[0 .. endPos].dup;
          }
        }

        return payload;
      }
    } catch (Exception) {
      return null;
    }

    sleep(1.msecs);
  }

  return null;
}
