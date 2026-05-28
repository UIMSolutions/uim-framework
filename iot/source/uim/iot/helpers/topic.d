/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.iot.helpers.topic;

import std.string : split, strip;

@safe:

string iotNormalizeTopic(string topic) {
  auto value = topic.strip();
  if (value.length == 0) {
    return value;
  }

  while (value.length > 1 && value[$ - 1] == '/') {
    value = value[0 .. $ - 1];
  }

  return value;
}

bool iotTopicMatches(string filter, string topic) {
  auto normalizedFilter = iotNormalizeTopic(filter);
  auto normalizedTopic = iotNormalizeTopic(topic);

  if (normalizedFilter.length == 0 || normalizedTopic.length == 0) {
    return false;
  }

  if (normalizedFilter == "#") {
    return true;
  }

  auto filterParts = normalizedFilter.split('/');
  auto topicParts = normalizedTopic.split('/');

  size_t i = 0;
  for (; i < filterParts.length; ++i) {
    if (i >= topicParts.length) {
      return filterParts[i] == "#" && i == filterParts.length - 1;
    }

    if (filterParts[i] == "#") {
      return i == filterParts.length - 1;
    }

    if (filterParts[i] == "+") {
      continue;
    }

    if (filterParts[i] != topicParts[i]) {
      return false;
    }
  }

  return i == topicParts.length;
}

unittest {
  assert(iotNormalizeTopic(" sensors/temp/ ") == "sensors/temp");
  assert(iotTopicMatches("sensors/+/temp", "sensors/a/temp"));
  assert(iotTopicMatches("sensors/#", "sensors/a/temp"));
  assert(!iotTopicMatches("devices/+/state", "devices/a/state/extra"));
}
