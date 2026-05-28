/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.grpc.helpers.framing;

@safe:

enum uint GRPC_FRAME_HEADER_SIZE = 5;

enum uint GRPC_MAX_PAYLOAD_SIZE = uint.max;

ubyte[] grpcFrameMessage(const(ubyte)[] payload, bool compressed = false) {
  const uint payloadLength = cast(uint) payload.length;

  ubyte[] frame;
  frame.length = GRPC_FRAME_HEADER_SIZE + payloadLength;

  frame[0] = compressed ? cast(ubyte) 1 : cast(ubyte) 0;
  frame[1] = cast(ubyte) ((payloadLength >> 24) & 0xFF);
  frame[2] = cast(ubyte) ((payloadLength >> 16) & 0xFF);
  frame[3] = cast(ubyte) ((payloadLength >> 8) & 0xFF);
  frame[4] = cast(ubyte) (payloadLength & 0xFF);

  foreach (index, b; payload) {
    frame[GRPC_FRAME_HEADER_SIZE + index] = b;
  }

  return frame;
}

uint grpcPayloadLength(const(ubyte)[] frame) {
  if (frame.length < GRPC_FRAME_HEADER_SIZE) {
    return 0;
  }

  return
    (cast(uint) frame[1] << 24) |
    (cast(uint) frame[2] << 16) |
    (cast(uint) frame[3] << 8) |
    cast(uint) frame[4];
}

bool grpcTryUnframeMessage(const(ubyte)[] frame, out bool compressed, out ubyte[] payload) {
  compressed = false;
  payload = null;

  if (frame.length < GRPC_FRAME_HEADER_SIZE) {
    return false;
  }

  compressed = frame[0] != 0;
  auto length = grpcPayloadLength(frame);
  if (frame.length != GRPC_FRAME_HEADER_SIZE + length) {
    return false;
  }

  payload.length = length;
  foreach (i; 0 .. length) {
    payload[i] = frame[GRPC_FRAME_HEADER_SIZE + i];
  }

  return true;
}

unittest {
  ubyte[] payload = [1, 2, 3, 9, 42];
  auto frame = grpcFrameMessage(payload, true);

  bool compressed;
  ubyte[] decoded;
  assert(grpcTryUnframeMessage(frame, compressed, decoded));
  assert(compressed);
  assert(decoded == payload);

  ubyte[] invalid = [0, 0, 0, 0, 5, 1, 2];
  assert(!grpcTryUnframeMessage(invalid, compressed, decoded));
}
