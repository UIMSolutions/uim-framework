/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.iot.models.device;

import uim.iot;

mixin(ShowModule!());

@safe:

class UIMIoTDevice : UIMObject, IIoTDevice {
  private string _id;
  private string _name;
  private IoTProtocol _protocol = IoTProtocol.mqtt;
  private IoTConnectionState _state = IoTConnectionState.disconnected;
  private string _endpoint;
  private string[string] _metadata;

  this(string id, string name, IoTProtocol protocol = IoTProtocol.mqtt, string endpoint = "") {
    _id = id;
    _name = name;
    _protocol = protocol;
    _endpoint = endpoint;
  }

  string id() {
    return _id;
  }

  IIoTDevice id(string value) {
    _id = value;
    return this;
  }

  string name() {
    return _name;
  }

  IIoTDevice name(string value) {
    _name = value;
    return this;
  }

  IoTProtocol protocol() {
    return _protocol;
  }

  IIoTDevice protocol(IoTProtocol value) {
    _protocol = value;
    return this;
  }

  IoTConnectionState state() {
    return _state;
  }

  IIoTDevice state(IoTConnectionState value) {
    _state = value;
    return this;
  }

  string endpoint() {
    return _endpoint;
  }

  IIoTDevice endpoint(string value) {
    _endpoint = value;
    return this;
  }

  string[string] metadata() {
    return _metadata.dup;
  }

  IIoTDevice metadata(string[string] value) {
    _metadata = value.dup;
    return this;
  }

  IIoTDevice setMetadata(string key, string value) {
    if (key.length) {
      _metadata[key] = value;
    }
    return this;
  }
}

IIoTDevice IoTDevice(string id, string name, IoTProtocol protocol = IoTProtocol.mqtt, string endpoint = "") {
  return new UIMIoTDevice(id, name, protocol, endpoint);
}

unittest {
  auto d = IoTDevice("dev-1", "Sensor A", IoTProtocol.coap, "coap://gw.local");
  d.setMetadata("room", "A-101");

  assert(d.id() == "dev-1");
  assert(d.protocol() == IoTProtocol.coap);
  assert(d.metadata()["room"] == "A-101");
}
