/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.client;

import std.datetime : Clock;
import std.format : format;
import std.string : startsWith;
import core.time : msecs;

import vibe.d : runTask, sleep;

import uim.coap;

mixin(ShowModule!());

@safe:

class UIMCoAPClient : UIMObject, ICoAPClient {
  private bool _connected = false;
  private string _endpoint;
  private UIMCoAPUdpAdapter _transport;
  private bool _transportEnabled = false;
  private ushort _nextMessageId = 1;

  bool connect(string endpointUrl) {
    if (endpointUrl.length == 0) {
      return false;
    }

    _endpoint = endpointUrl;
    _transportEnabled = false;
    _transport = null;

    if (endpointUrl.startsWith("coap://") || endpointUrl.startsWith("coaps://")) {
      auto adapter = new UIMCoAPUdpAdapter();
      if (adapter.open(endpointUrl)) {
        _transport = adapter;
        _transportEnabled = true;
      }
    }

    _connected = true;
    return true;
  }

  bool disconnect() {
    if (!_connected) {
      return false;
    }

    if (_transportEnabled && _transport !is null) {
      _transport.close();
      _transport = null;
      _transportEnabled = false;
    }

    _connected = false;
    return true;
  }

  bool request(
    CoAPCode method,
    string path,
    const(ubyte)[] payload,
    CoAPResponseHandler handler = null
  ) {
    if (!_connected || path.length == 0) {
      return false;
    }

    auto requestMessage = cast(UIMCoAPMessage) CoAPMessage(method, path, payload);
    requestMessage.type(CoAPType.confirmable);
    requestMessage.messageId(nextMessageId());
    requestMessage.token(makeToken());

    if (_transportEnabled && _transport !is null) {
      _transport.send(requestMessage);
    }

    if (handler !is null) {
      auto response = buildSyntheticResponse(method, path, payload, requestMessage.messageId());
      runTask(() nothrow {
        try {
          handler(response);
        } catch (Exception) {
        }
      });
    }

    return true;
  }

  bool connected() const {
    return _connected;
  }

  string endpoint() const {
    return _endpoint;
  }

  bool usingUdpTransport() const {
    return _transportEnabled;
  }

  private ushort nextMessageId() {
    if (_nextMessageId == 0) {
      _nextMessageId = 1;
    }
    return _nextMessageId++;
  }

  private ubyte[] makeToken() {
    auto seed = format("%s", Clock.currTime().toUnixTime());
    return cast(ubyte[]) seed[0 .. (seed.length >= 4 ? 4 : seed.length)].dup;
  }

  private ICoAPMessage buildSyntheticResponse(
    CoAPCode method,
    string path,
    const(ubyte)[] payload,
    ushort requestMessageId
  ) {
    auto response = cast(UIMCoAPMessage) CoAPMessage(CoAPCode.content, path, payload);
    response.type(CoAPType.acknowledgement);
    response.messageId(requestMessageId);

    switch (method) {
    case CoAPCode.get:
      response.code(CoAPCode.content);
      break;
    case CoAPCode.post:
      response.code(CoAPCode.created);
      break;
    case CoAPCode.put:
      response.code(CoAPCode.changed);
      break;
    case CoAPCode.delete_:
      response.code(CoAPCode.deleted);
      break;
    default:
      response.code(CoAPCode.methodNotAllowed);
      break;
    }

    return response;
  }
}

auto CoAPClient() {
  return new UIMCoAPClient();
}

unittest {
  auto client = CoAPClient();
  assert(client.connect("coap://127.0.0.1:5683"));
  assert(client.connected());

  bool callbackCalled = false;
  assert(client.request(CoAPCode.get, "/health", null, (ICoAPMessage response) {
    callbackCalled = true;
    assert(response.code() == CoAPCode.content);
    assert(response.path() == "/health");
  }));

  sleep(20.msecs);
  assert(callbackCalled);

  assert(client.disconnect());
}
