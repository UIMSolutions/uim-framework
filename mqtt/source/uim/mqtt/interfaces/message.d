/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.mqtt.interfaces.message;

import uim.mqtt;

mixin(ShowModule!());

@safe:

enum MQTTQoS : ubyte {
  atMostOnce = 0,
  atLeastOnce = 1,
  exactlyOnce = 2
}

interface IMQTTMessage {
  string topic();
  IMQTTMessage topic(string value);

  string payload();
  IMQTTMessage payload(string value);

  MQTTQoS qos();
  IMQTTMessage qos(MQTTQoS value);

  bool retain();
  IMQTTMessage retain(bool value);

  bool duplicate();
  IMQTTMessage duplicate(bool value);
}
