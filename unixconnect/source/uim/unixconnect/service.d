/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.unixconnect.service;

import std.conv : to;

import vibe.d : runTask;

import uim.unixconnect;

mixin(ShowModule!());

@safe:

class UIMUnixConnectService : UIMObject, IUnixConnectService {
  private ulong _nextSession = 1;
  private IUnixConnectSession[string] _sessions;
  private UnixConnectMessageHandler[][string] _subscriptions;

  IUnixConnectSession connect(string socketPath, UnixConnectSocketType socketType = UnixConnectSocketType.stream) {
    if (socketPath.length == 0) {
      return null;
    }

    auto sessionId = "uxc-" ~ _nextSession.to!string;
    _nextSession++;

    auto s = UnixConnectSession(sessionId, socketPath, socketType).connected(true);
    _sessions[sessionId] = s;
    return s;
  }

  bool disconnect(string sessionId) {
    if (sessionId.length == 0 || sessionId !in _sessions) {
      return false;
    }

    _sessions[sessionId].connected(false);
    _sessions.remove(sessionId);
    return true;
  }

  bool connected(string sessionId) {
    if (auto s = sessionId in _sessions) {
      return (*s).connected();
    }

    return false;
  }

  IUnixConnectSession sessionById(string sessionId) {
    if (auto s = sessionId in _sessions) {
      return *s;
    }

    return null;
  }

  IUnixConnectSession[] sessions() {
    IUnixConnectSession[] result;
    foreach (_id, s; _sessions) {
      result ~= s;
    }

    return result;
  }

  bool send(UnixConnectMessage message) {
    if (!connected(message.sessionId)) {
      return false;
    }

    auto channel = unixconnectNormalizeChannel(message.channel);
    if (channel.length == 0 || channel !in _subscriptions) {
      return false;
    }

    foreach (handler; _subscriptions[channel]) {
      auto localMessage = message;
      auto localHandler = handler;

      (() @trusted {
        runTask(() nothrow {
          try {
            localHandler(localMessage);
          } catch (Exception) {
          }
        });
      })();
    }

    return true;
  }

  bool subscribe(string channel, UnixConnectMessageHandler handler) {
    auto normalized = unixconnectNormalizeChannel(channel);
    if (normalized.length == 0 || handler is null) {
      return false;
    }

    _subscriptions[normalized] ~= handler;
    return true;
  }

  bool unsubscribe(string channel) {
    auto normalized = unixconnectNormalizeChannel(channel);
    if (normalized.length == 0 || normalized !in _subscriptions) {
      return false;
    }

    _subscriptions.remove(normalized);
    return true;
  }
}

IUnixConnectService UnixConnectService() {
  return new UIMUnixConnectService();
}

unittest {
  auto service = UnixConnectService();
  auto session = service.connect("/tmp/uim.sock");
  assert(session !is null);
  assert(service.connected(session.id()));

  assert(service.subscribe("events/logistics", null) == false);
  assert(service.unsubscribe("events/logistics") == false);

  assert(service.disconnect(session.id()));
}
