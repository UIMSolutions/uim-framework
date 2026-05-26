/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.mqtt.client;

import std.datetime : Clock;
import std.format : format;
import core.time : msecs;
import vibe.d : runTask, sleep;

import uim.mqtt;

mixin(ShowModule!());

@safe:

class UIMMQTTClient : UIMObject, IMQTTClient {
  private bool _connected = false;
  private string _brokerUrl;
  private string _clientId;
  private MQTTMessageHandler[][string] _subscriptions;

  bool connect(string brokerUrl, string clientId = "") {
    if (brokerUrl.length == 0) {
      return false;
    }

    _brokerUrl = brokerUrl;
    _clientId = clientId.length > 0 ? clientId : format("uim-mqtt-%s", Clock.currTime().toUnixTime());
    _connected = true;
    return true;
  }

  bool disconnect() {
    if (!_connected) {
      return false;
    }

    _subscriptions.clear();
    _connected = false;
    return true;
  }

  bool publish(string topic, string payload, MQTTQoS qos = MQTTQoS.atMostOnce, bool retain = false) {
    if (!_connected || topic.length == 0) {
      return false;
    }

    auto message = MQTTMessage(topic, payload, qos, retain);
    handleMessage(message);
    return true;
  }

  bool subscribe(string topicFilter, MQTTMessageHandler handler) {
    if (!_connected || topicFilter.length == 0 || handler is null) {
      return false;
    }

    _subscriptions[topicFilter] ~= handler;
    return true;
  }

  bool unsubscribe(string topicFilter) {
    if (!_connected || topicFilter.length == 0) {
      return false;
    }

    _subscriptions.remove(topicFilter);
    return true;
  }

  bool connected() const {
    return _connected;
  }

  string clientId() const {
    return _clientId;
  }

  string brokerUrl() const {
    return _brokerUrl;
  }

  /// Delivers messages asynchronously to all matching subscriptions.
  protected void handleMessage(IMQTTMessage message) @trusted {
    foreach (topicFilter, handlers; _subscriptions) {
      if (!topicMatches(topicFilter, message.topic())) {
        continue;
      }

      foreach (handler; handlers) {
        auto localHandler = handler;
        auto localMessage = message;
        runTask(() nothrow {
          try {
            localHandler(localMessage);
          } catch (Exception) {
          }
        });
      }
    }
  }
}

auto MQTTClient() {
  return new UIMMQTTClient();
}

unittest {
  auto client = MQTTClient();
  assert(client.connect("mqtt://localhost:1883", "test-client"));
  assert(client.connected());
  assert(client.clientId() == "test-client");
}

unittest {
  auto client = MQTTClient();
  assert(client.connect("mqtt://localhost:1883"));

  int hitCount = 0;

  assert(client.subscribe("sensors/+/temperature", (IMQTTMessage message) {
    assert(message.topic() == "sensors/kitchen/temperature");
    assert(message.payload() == "22.7");
    hitCount++;
  }));

  assert(client.publish("sensors/kitchen/temperature", "22.7"));
  sleep(20.msecs);
  assert(hitCount == 1);

  assert(client.unsubscribe("sensors/+/temperature"));
  assert(client.disconnect());
}
