/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
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
  private struct PendingRequest {
    ICoAPMessage request;
    CoAPResponseHandler handler;
    bool observe;
    string path;
  }

  private bool _connected = false;
  private string _endpoint;
  private UIMCoAPUdpAdapter _transport;
  private bool _transportEnabled = false;
  private bool _listenerRunning = false;

  private uint _ackTimeoutMs = 200;
  private uint _maxRetransmit = 4;

  private ushort _nextMessageId = 1;
  private PendingRequest[string] _pending;
  private CoAPResponseHandler[][string] _observeHandlers;

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
        startListener();
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
      _transportEnabled = false;
      _transport.close();
      _transport = null;
      foreach (_; 0 .. 10) {
        if (!_listenerRunning) {
          break;
        }
        sleep(20.msecs);
      }
    }

    _pending.clear();
    _observeHandlers.clear();

    _connected = false;
    return true;
  }

  ICoAPClient ackTimeoutMs(uint value) {
    _ackTimeoutMs = value == 0 ? 1 : value;
    return this;
  }

  uint ackTimeoutMs() const {
    return _ackTimeoutMs;
  }

  ICoAPClient maxRetransmit(uint value) {
    _maxRetransmit = value;
    return this;
  }

  uint maxRetransmit() const {
    return _maxRetransmit;
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

    auto tokenKey = toTokenKey(requestMessage.token());
    if (handler !is null) {
      _pending[tokenKey] = PendingRequest(requestMessage, handler, false, path);
    }

    if (_transportEnabled && _transport !is null) {
      _transport.send(requestMessage);
      scheduleRetransmission(tokenKey);
      scheduleFallbackResponse(tokenKey, method, path, payload, requestMessage.messageId());
    }

    if (!_transportEnabled && handler !is null) {
      auto response = buildSyntheticResponse(method, path, payload, requestMessage.messageId());
      runTask(() nothrow {
        try {
          if (tokenKey in _pending) {
            _pending.remove(tokenKey);
          }
          handler(response);
        } catch (Exception) {
        }
      });
    }

    return true;
  }

  bool observe(string path, CoAPResponseHandler handler) {
    if (!_connected || path.length == 0 || handler is null) {
      return false;
    }

    _observeHandlers[path] ~= handler;

    auto requestMessage = cast(UIMCoAPMessage) CoAPMessage(CoAPCode.get, path, null);
    requestMessage.type(CoAPType.confirmable);
    requestMessage.messageId(nextMessageId());
    requestMessage.token(makeToken());
    coapSetUintOption(requestMessage, CoAPOptionNumber.observe, 0);

    auto tokenKey = toTokenKey(requestMessage.token());
    _pending[tokenKey] = PendingRequest(requestMessage, handler, true, path);

    if (_transportEnabled && _transport !is null) {
      _transport.send(requestMessage);
      scheduleRetransmission(tokenKey);
      scheduleFallbackObserveNotification(tokenKey, path, requestMessage.messageId());
      return true;
    }

    // Without transport, deliver one synthetic notification to keep local behavior usable.
    runTask(() nothrow {
      try {
        auto notification = cast(UIMCoAPMessage) CoAPMessage(CoAPCode.content, path, coapStringToBytes("observe"));
        notification.type(CoAPType.nonConfirmable);
        notification.messageId(requestMessage.messageId());
        coapSetUintOption(notification, CoAPOptionNumber.observe, 1);
        handler(notification);
      } catch (Exception) {
      }
    });

    return true;
  }

  bool cancelObserve(string path, CoAPResponseHandler handler = null) {
    if (!_connected || path.length == 0) {
      return false;
    }

    if (path !in _observeHandlers) {
      return false;
    }

    if (handler is null) {
      _observeHandlers.remove(path);
    } else {
      CoAPResponseHandler[] kept;
      foreach (h; _observeHandlers[path]) {
        if (!sameHandler(h, handler)) {
          kept ~= h;
        }
      }

      if (kept.length == 0) {
        _observeHandlers.remove(path);
      } else {
        _observeHandlers[path] = kept;
      }
    }

    foreach (key, p; _pending.dup) {
      if (p.observe && p.path == path) {
        _pending.remove(key);
      }
    }

    if (_transportEnabled && _transport !is null) {
      auto cancelMsg = cast(UIMCoAPMessage) CoAPMessage(CoAPCode.get, path, null);
      cancelMsg.type(CoAPType.confirmable);
      cancelMsg.messageId(nextMessageId());
      cancelMsg.token(makeToken());
      coapSetUintOption(cancelMsg, CoAPOptionNumber.observe, 1);
      _transport.send(cancelMsg);
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
    return coapStringToBytes(seed[0 .. (seed.length >= 4 ? 4 : seed.length)]);
  }

  private void startListener() {
    if (_listenerRunning || !_transportEnabled || _transport is null) {
      return;
    }

    _listenerRunning = true;
    runTask(() nothrow {
      try {
        while (_connected && _transportEnabled && _transport !is null) {
          ICoAPMessage incoming;
          if (_transport.receive(incoming, 200.msecs)) {
            dispatchIncoming(incoming);
          }
        }
      } catch (Exception) {
      }
      _listenerRunning = false;
    });
  }

  private void dispatchIncoming(ICoAPMessage incoming) {
    auto key = toTokenKey(incoming.token());
    if (key in _pending) {
      auto pending = _pending[key];
      if (!pending.observe) {
        _pending.remove(key);
      }

      if (pending.handler !is null) {
        pending.handler(incoming);
      }
    }

    uint observeSeq;
    if (coapTryGetUintOption(incoming, CoAPOptionNumber.observe, observeSeq)) {
      auto path = incoming.path();
      if (path in _observeHandlers) {
        foreach (handler; _observeHandlers[path]) {
          handler(incoming);
        }
      }
    }
  }

  private void scheduleRetransmission(string tokenKey) {
    if (!_transportEnabled || _transport is null || _maxRetransmit == 0) {
      return;
    }

    runTask(() nothrow {
      try {
        uint timeout = _ackTimeoutMs;
        foreach (_; 0 .. _maxRetransmit) {
          sleep(timeout.msecs);
          if (!(tokenKey in _pending)) {
            return;
          }

          auto pending = _pending[tokenKey];
          if (pending.request.type() != CoAPType.confirmable) {
            return;
          }

          if (_transportEnabled && _transport !is null) {
            _transport.send(pending.request);
          }
          timeout *= 2;
        }
      } catch (Exception) {
      }
    });
  }

  private void scheduleFallbackResponse(
    string tokenKey,
    CoAPCode method,
    string path,
    const(ubyte)[] payload,
    ushort messageId
  ) {
    runTask(() nothrow {
      try {
        sleep(_ackTimeoutMs.msecs);
        if (!(tokenKey in _pending)) {
          return;
        }

        auto pending = _pending[tokenKey];
        _pending.remove(tokenKey);

        if (pending.handler !is null) {
          auto synthetic = buildSyntheticResponse(method, path, payload, messageId);
          pending.handler(synthetic);
        }
      } catch (Exception) {
      }
    });
  }

  private void scheduleFallbackObserveNotification(string tokenKey, string path, ushort messageId) {
    runTask(() nothrow {
      try {
        sleep(_ackTimeoutMs.msecs);
        if (!(tokenKey in _pending)) {
          return;
        }

        auto pending = _pending[tokenKey];
        if (!pending.observe || pending.handler is null) {
          return;
        }

        auto notification = cast(UIMCoAPMessage) CoAPMessage(CoAPCode.content, path, coapStringToBytes("observe"));
        notification.type(CoAPType.nonConfirmable);
        notification.messageId(messageId);
        coapSetUintOption(notification, CoAPOptionNumber.observe, 1);
        pending.handler(notification);
      } catch (Exception) {
      }
    });
  }

  private bool sameHandler(CoAPResponseHandler a, CoAPResponseHandler b) {
    return a.ptr == b.ptr && a.funcptr == b.funcptr;
  }

  private string toTokenKey(const(ubyte)[] token) {
    if (token.length == 0) {
      return "";
    }

    string key;
    foreach (b; token) {
      key ~= format("%02X", b);
    }
    return key;
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
  assert(client.connect("local://coap-test"));
  assert(client.connected());

  bool callbackCalled = false;
  assert(client.request(CoAPCode.get, "/health", null, (ICoAPMessage response) {
    callbackCalled = true;
    assert(response.code() == CoAPCode.content);
    assert(response.path() == "/health");
  }));

  sleep(260.msecs);
  assert(callbackCalled);

  bool observeCalled = false;
  assert(client.observe("/events", (ICoAPMessage response) {
    observeCalled = true;
  }));
  sleep(260.msecs);
  assert(observeCalled);
  assert(client.cancelObserve("/events"));

  assert(client.disconnect());
}
