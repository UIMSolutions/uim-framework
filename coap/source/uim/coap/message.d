/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.message;

import uim.coap;

mixin(ShowModule!());

@safe:

class UIMCoAPMessage : UIMObject, ICoAPMessage {
  this() {
    super();
    _type = CoAPType.confirmable;
    _code = CoAPCode.empty;
  }

  this(CoAPCode requestCode, string requestPath, const(ubyte)[] requestPayload = null) {
    this();
    _code = requestCode;
    _path = requestPath;
    _payload = requestPayload.dup;
  }

  private CoAPType _type;
  CoAPType type() {
    return _type;
  }

  ICoAPMessage type(CoAPType value) {
    _type = value;
    return this;
  }

  private CoAPCode _code;
  CoAPCode code() {
    return _code;
  }

  ICoAPMessage code(CoAPCode value) {
    _code = value;
    return this;
  }

  private ushort _messageId;
  ushort messageId() {
    return _messageId;
  }

  ICoAPMessage messageId(ushort value) {
    _messageId = value;
    return this;
  }

  private ubyte[] _token;
  ubyte[] token() {
    return _token.dup;
  }

  ICoAPMessage token(const(ubyte)[] value) {
    _token = value.dup;
    return this;
  }

  private string _path;
  string path() {
    return _path;
  }

  ICoAPMessage path(string value) {
    _path = value;
    return this;
  }

  private ubyte[] _payload;
  ubyte[] payload() {
    return _payload.dup;
  }

  ICoAPMessage payload(const(ubyte)[] value) {
    _payload = value.dup;
    return this;
  }

  private CoAPOption[] _options;
  CoAPOption[] options() {
    return _options.dup;
  }

  ICoAPMessage options(CoAPOption[] value) {
    _options = value.dup;
    return this;
  }

  ICoAPMessage addOption(ushort number, const(ubyte)[] value) {
    _options ~= CoAPOption(number, value.dup);
    return this;
  }
}

ICoAPMessage CoAPMessage(CoAPCode code, string path, const(ubyte)[] payload = null) {
  return new UIMCoAPMessage(code, path, payload);
}

unittest {
  auto message = CoAPMessage(CoAPCode.get, "/sensors/temp");
  assert(message.code() == CoAPCode.get);
  assert(message.path() == "/sensors/temp");
}
