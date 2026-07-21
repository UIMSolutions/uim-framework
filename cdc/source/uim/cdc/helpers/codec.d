/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdc.helpers.codec;

import std.algorithm.searching : countUntil, startsWith;
import std.string : replace, strip;

import uim.cdc.interfaces.port;

@safe:

string cdcBytesToString(const(ubyte)[] payload) @trusted {
  return cast(string) payload;
}

ubyte[] cdcStringToBytes(string value) @trusted {
  return cast(ubyte[]) value.dup;
}

bool cdcIsLoopbackPath(string value) {
  auto path = value.strip();
  return path == "loopback" || path.startsWith("loop://") || path.startsWith("mock://");
}

string cdcNormalizeLineEndings(string value) {
  return value.replace("\r\n", "\n").replace("\r", "\n");
}

CDCFrame cdcFrameFromText(string value, string channel = "cdc") {
  CDCFrame frame;
  frame.channel = channel;
  frame.text = value;
  frame.payload = cdcStringToBytes(value);
  return frame;
}

size_t cdcFindFrameEnd(const(ubyte)[] buffer, bool newlineDelimited) {
  if (!newlineDelimited || buffer.length == 0) {
    return buffer.length;
  }

  auto text = cdcBytesToString(buffer);
  auto lf = text.countUntil("\n");
  if (lf < 0) {
    return 0;
  }

  return cast(size_t) lf + 1;
}

CDCResult cdcOk(size_t bytesTransferred, string message = "ok") {
  CDCResult result;
  result.success = true;
  result.bytesTransferred = bytesTransferred;
  result.message = message;
  return result;
}

CDCResult cdcFail(string message) {
  CDCResult result;
  result.success = false;
  result.message = message;
  return result;
}

unittest {
  assert(cdcIsLoopbackPath("loopback"));
  assert(cdcIsLoopbackPath("loop://cdc0"));
  assert(!cdcIsLoopbackPath("/dev/ttyACM0"));

  auto frame = cdcFrameFromText("hello");
  assert(frame.payload.length == 5);
}
