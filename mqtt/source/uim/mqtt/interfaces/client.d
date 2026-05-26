/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.mqtt.interfaces.client;

import uim.mqtt;

mixin(ShowModule!());

@safe:

alias MQTTMessageHandler = void delegate(IMQTTMessage message) @safe;

interface IMQTTClient {
  bool connect(string brokerUrl, string clientId = "");
  bool disconnect();

  bool publish(string topic, string payload, MQTTQoS qos = MQTTQoS.atMostOnce, bool retain = false);
  bool subscribe(string topicFilter, MQTTMessageHandler handler);
  bool unsubscribe(string topicFilter);

  bool connected() const;
  string clientId() const;
}
