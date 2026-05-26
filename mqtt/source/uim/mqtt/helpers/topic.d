/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.mqtt.helpers.topic;

import std.string : split;

@safe:

/// MQTT topic filter matcher supporting + and # wildcards.
bool topicMatches(string filter, string topic) {
  if (filter.length == 0 || topic.length == 0) {
    return false;
  }

  if (filter == "#") {
    return true;
  }

  auto filterParts = filter.split("/");
  auto topicParts = topic.split("/");

  size_t i = 0;
  for (; i < filterParts.length; i++) {
    auto fp = filterParts[i];

    if (fp == "#") {
      return true;
    }

    if (i >= topicParts.length) {
      return false;
    }

    if (fp == "+") {
      continue;
    }

    if (fp != topicParts[i]) {
      return false;
    }
  }

  return i == topicParts.length;
}

unittest {
  assert(topicMatches("sensors/+/temperature", "sensors/kitchen/temperature"));
  assert(topicMatches("sensors/#", "sensors/floor1/room2/humidity"));
  assert(topicMatches("#", "anything/goes/here"));

  assert(!topicMatches("sensors/+/temperature", "sensors/temperature"));
  assert(!topicMatches("sensors/room1", "sensors/room1/humidity"));
}
