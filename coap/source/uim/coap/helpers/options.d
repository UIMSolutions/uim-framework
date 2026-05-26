/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.helpers.options;

import uim.coap.interfaces.message;

@safe:

enum CoAPOptionNumber : ushort {
  ifMatch = 1,
  uriHost = 3,
  eTag = 4,
  ifNoneMatch = 5,
  observe = 6,
  uriPort = 7,
  locationPath = 8,
  uriPath = 11,
  contentFormat = 12,
  maxAge = 14,
  uriQuery = 15,
  accept = 17,
  locationQuery = 20,
  proxyUri = 35,
  proxyScheme = 39,
  size1 = 60
}

ICoAPMessage coapSetUintOption(ICoAPMessage message, ushort number, uint value) {
  return message.addOption(number, coapEncodeUint(value));
}

bool coapTryGetFirstOption(ICoAPMessage message, ushort number, out CoAPOption option) {
  option = CoAPOption.init;
  foreach (opt; message.options()) {
    if (opt.number == number) {
      option = CoAPOption(opt.number, opt.value.dup);
      return true;
    }
  }
  return false;
}

bool coapTryGetUintOption(ICoAPMessage message, ushort number, out uint value) {
  value = 0;
  CoAPOption option;
  if (!coapTryGetFirstOption(message, number, option)) {
    return false;
  }

  value = coapDecodeUint(option.value);
  return true;
}

ubyte[] coapEncodeUint(uint value) {
  if (value == 0) {
    return [cast(ubyte) 0x00];
  }

  ubyte[] tmp;
  uint x = value;
  while (x > 0) {
    tmp = [cast(ubyte)(x & 0xFF)] ~ tmp;
    x >>= 8;
  }
  return tmp;
}

uint coapDecodeUint(const(ubyte)[] value) {
  uint result = 0;
  foreach (b; value) {
    result = (result << 8) | b;
  }
  return result;
}

unittest {
  auto bytes = coapEncodeUint(513);
  assert(bytes.length == 2);
  assert(bytes[0] == 0x02);
  assert(bytes[1] == 0x01);
  assert(coapDecodeUint(bytes) == 513);
}
