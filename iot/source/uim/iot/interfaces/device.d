/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.iot.interfaces.device;

import std.datetime : SysTime;

@safe:

enum IoTProtocol : ubyte {
  mqtt = 0,
  coap = 1,
  http = 2,
  websocket = 3,
  custom = 4
}

enum IoTConnectionState : ubyte {
  disconnected = 0,
  connecting = 1,
  connected = 2,
  error = 3
}

struct IoTTelemetry {
  string topic;
  string payload;
  SysTime timestamp;
  string[string] tags;
}

interface IIoTDevice {
  string id();
  IIoTDevice id(string value);

  string name();
  IIoTDevice name(string value);

  IoTProtocol protocol();
  IIoTDevice protocol(IoTProtocol value);

  IoTConnectionState state();
  IIoTDevice state(IoTConnectionState value);

  string endpoint();
  IIoTDevice endpoint(string value);

  string[string] metadata();
  IIoTDevice metadata(string[string] value);
  IIoTDevice setMetadata(string key, string value);
}

alias IoTTelemetryHandler = void delegate(IIoTDevice device, IoTTelemetry telemetry) @safe;

interface IIoTClient {
  bool connect();
  bool disconnect();

  bool connected() const;
  string broker() const;

  IIoTClient registerDevice(IIoTDevice device);
  IIoTDevice deviceById(string deviceId);
  IIoTDevice[] devices();

  bool subscribe(string filter, IoTTelemetryHandler handler);
  bool unsubscribe(string filter);
  bool publish(string deviceId, string topic, string payload, string[string] tags = null);
}
