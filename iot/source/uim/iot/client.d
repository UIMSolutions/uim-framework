/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.iot.client;

import std.datetime : Clock;

import vibe.d : runTask;

import uim.iot;

mixin(ShowModule!());

@safe:

class UIMIoTClient : UIMObject, IIoTClient {
  private bool _connected;
  private string _broker;
  private IIoTDevice[string] _devices;
  private IoTTelemetryHandler[][string] _subscriptions;

  this(string broker = "mqtt://localhost:1883") {
    _broker = broker;
  }

  bool connect() {
    if (_connected) {
      return true;
    }

    _connected = true;
    foreach (id, d; _devices) {
      _devices[id] = d.state(IoTConnectionState.connected);
    }
    return true;
  }

  bool disconnect() {
    if (!_connected) {
      return false;
    }

    _connected = false;
    foreach (id, d; _devices) {
      _devices[id] = d.state(IoTConnectionState.disconnected);
    }
    return true;
  }

  bool connected() const {
    return _connected;
  }

  string broker() const {
    return _broker;
  }

  IIoTClient registerDevice(IIoTDevice device) {
    if (device is null || device.id().length == 0) {
      return this;
    }

    auto state = _connected ? IoTConnectionState.connected : IoTConnectionState.disconnected;
    _devices[device.id()] = device.state(state);
    return this;
  }

  IIoTDevice deviceById(string deviceId) {
    if (auto found = deviceId in _devices) {
      return *found;
    }
    return null;
  }

  IIoTDevice[] devices() {
    IIoTDevice[] result;
    foreach (_id, d; _devices) {
      result ~= d;
    }
    return result;
  }

  bool subscribe(string filter, IoTTelemetryHandler handler) {
    auto normalized = iotNormalizeTopic(filter);
    if (normalized.length == 0 || handler is null) {
      return false;
    }

    _subscriptions[normalized] ~= handler;
    return true;
  }

  bool unsubscribe(string filter) {
    auto normalized = iotNormalizeTopic(filter);
    if (normalized.length == 0 || normalized !in _subscriptions) {
      return false;
    }

    _subscriptions.remove(normalized);
    return true;
  }

  bool publish(string deviceId, string topic, string payload, string[string] tags = null) {
    if (!_connected) {
      return false;
    }

    auto d = deviceById(deviceId);
    if (d is null) {
      return false;
    }

    auto normalizedTopic = iotNormalizeTopic(topic);
    if (normalizedTopic.length == 0) {
      return false;
    }

    IoTTelemetry t;
    t.topic = normalizedTopic;
    t.payload = payload;
    t.timestamp = Clock.currTime();
    t.tags = tags.dup;

    foreach (filter, handlers; _subscriptions) {
      if (!iotTopicMatches(filter, normalizedTopic)) {
        continue;
      }

      foreach (h; handlers) {
        auto copyDevice = d;
        auto copyTelemetry = t;
        auto localHandler = h;

        (() @trusted {
          runTask(() nothrow {
            try {
              localHandler(copyDevice, copyTelemetry);
            } catch (Exception) {
            }
          });
        })();
      }
    }

    return true;
  }
}

IIoTClient IoTClient(string broker = "mqtt://localhost:1883") {
  return new UIMIoTClient(broker);
}

unittest {
  auto client = IoTClient();
  auto device = IoTDevice("dev-1", "Sensor A");

  client.registerDevice(device);
  assert(client.connect());
  assert(client.deviceById("dev-1") !is null);
  assert(client.subscribe("sensors/#", null) == false);
  assert(client.unsubscribe("sensors/#") == false);
  assert(client.connected());
  assert(client.disconnect());
  assert(!client.connected());
}
