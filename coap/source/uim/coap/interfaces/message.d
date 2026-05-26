/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.interfaces.message;

@safe:

enum CoAPType : ubyte {
  confirmable = 0,
  nonConfirmable = 1,
  acknowledgement = 2,
  reset = 3
}

enum CoAPCode : ubyte {
  empty = 0,

  get = 1,
  post = 2,
  put = 3,
  delete_ = 4,

  created = 65,
  deleted = 66,
  valid = 67,
  changed = 68,
  content = 69,

  badRequest = 128,
  unauthorized = 129,
  notFound = 132,
  methodNotAllowed = 133,

  internalServerError = 160,
  notImplemented = 161,
  badGateway = 162
}

struct CoAPOption {
  ushort number;
  ubyte[] value;
}

interface ICoAPMessage {
  CoAPType type();
  ICoAPMessage type(CoAPType value);

  CoAPCode code();
  ICoAPMessage code(CoAPCode value);

  ushort messageId();
  ICoAPMessage messageId(ushort value);

  ubyte[] token();
  ICoAPMessage token(const(ubyte)[] value);

  string path();
  ICoAPMessage path(string value);

  ubyte[] payload();
  ICoAPMessage payload(const(ubyte)[] value);

  CoAPOption[] options();
  ICoAPMessage options(CoAPOption[] value);
  ICoAPMessage addOption(ushort number, const(ubyte)[] value);
}
