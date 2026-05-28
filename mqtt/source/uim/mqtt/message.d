/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.mqtt.message;

import uim.mqtt;

mixin(ShowModule!());

@safe:

class UIMMQTTMessage : UIMObject, IMQTTMessage {
  this() {
    super();
    _qos = MQTTQoS.atMostOnce;
  }

  this(
    string messageTopic,
    string messagePayload,
    MQTTQoS messageQos = MQTTQoS.atMostOnce,
    bool messageRetain = false
  ) {
    this();
    _topic = messageTopic;
    _payload = messagePayload;
    _qos = messageQos;
    _retain = messageRetain;
  }

  private string _topic;
  string topic() {
    return _topic;
  }

  IMQTTMessage topic(string value) {
    _topic = value;
    return this;
  }

  private string _payload;
  string payload() {
    return _payload;
  }

  IMQTTMessage payload(string value) {
    _payload = value;
    return this;
  }

  private MQTTQoS _qos;
  MQTTQoS qos() {
    return _qos;
  }

  IMQTTMessage qos(MQTTQoS value) {
    _qos = value;
    return this;
  }

  private bool _retain;
  bool retain() {
    return _retain;
  }

  IMQTTMessage retain(bool value) {
    _retain = value;
    return this;
  }

  private bool _duplicate;
  bool duplicate() {
    return _duplicate;
  }

  IMQTTMessage duplicate(bool value) {
    _duplicate = value;
    return this;
  }
}

IMQTTMessage MQTTMessage(string topic, string payload, MQTTQoS qos = MQTTQoS.atMostOnce, bool retain = false) {
  return new UIMMQTTMessage(topic, payload, qos, retain);
}

unittest {
  auto message = MQTTMessage("sensors/temp", "21.4", MQTTQoS.atLeastOnce, false);

  assert(message.topic() == "sensors/temp");
  assert(message.payload() == "21.4");
  assert(message.qos() == MQTTQoS.atLeastOnce);
  assert(message.retain() == false);
}
