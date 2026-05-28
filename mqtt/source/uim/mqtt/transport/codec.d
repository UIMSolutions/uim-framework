/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.mqtt.transport.codec;

import std.array : appender;
import std.conv : to;

import uim.mqtt;

mixin(ShowModule!());

@safe:

enum MQTTPacketType : ubyte {
  reserved = 0,
  connect = 1,
  connAck = 2,
  publish = 3,
  pubAck = 4,
  pubRec = 5,
  pubRel = 6,
  pubComp = 7,
  subscribe = 8,
  subAck = 9,
  unsubscribe = 10,
  unsubAck = 11,
  pingReq = 12,
  pingResp = 13,
  disconnect = 14,
  auth = 15
}

struct MQTTConnAck {
  bool sessionPresent;
  ubyte returnCode;
}

/// Build MQTT fixed header + payload packet.
ubyte[] mqttBuildPacket(MQTTPacketType packetType, ubyte headerFlags, const(ubyte)[] payload) {
  auto bytesOut = appender!(ubyte[])();
  bytesOut.put(cast(ubyte)((cast(ubyte) packetType << 4) | (headerFlags & 0x0F)));
  bytesOut.put(mqttEncodeRemainingLength(payload.length));
  bytesOut.put(payload);
  return bytesOut.data;
}

ubyte[] mqttEncodeConnectPacket(
  string clientId,
  bool cleanSession = true,
  ushort keepAliveSeconds = 30
) {
  auto payload = appender!(ubyte[])();

  mqttWriteUtf8(payload, "MQTT");
  payload.put(cast(ubyte) 0x04); // MQTT 3.1.1 level

  ubyte connectFlags = 0;
  if (cleanSession) {
    connectFlags |= 0x02;
  }
  payload.put(connectFlags);

  payload.put(cast(ubyte)((keepAliveSeconds >> 8) & 0xFF));
  payload.put(cast(ubyte)(keepAliveSeconds & 0xFF));

  mqttWriteUtf8(payload, clientId);
  return mqttBuildPacket(MQTTPacketType.connect, 0, payload.data);
}

ubyte[] mqttEncodePublishPacket(
  string topic,
  string messagePayload,
  MQTTQoS qos = MQTTQoS.atMostOnce,
  bool retain = false,
  bool duplicate = false,
  ushort packetId = 1
) {
  auto payload = appender!(ubyte[])();

  mqttWriteUtf8(payload, topic);
  if (qos != MQTTQoS.atMostOnce) {
    payload.put(cast(ubyte)((packetId >> 8) & 0xFF));
    payload.put(cast(ubyte)(packetId & 0xFF));
  }

  payload.put(cast(const(ubyte)[]) messagePayload);

  ubyte flags = 0;
  if (retain) {
    flags |= 0x01;
  }
  flags |= (cast(ubyte) qos << 1);
  if (duplicate) {
    flags |= 0x08;
  }

  return mqttBuildPacket(MQTTPacketType.publish, flags, payload.data);
}

ubyte[] mqttEncodeSubscribePacket(
  ushort packetId,
  string topicFilter,
  MQTTQoS qos = MQTTQoS.atMostOnce
) {
  auto payload = appender!(ubyte[])();
  payload.put(cast(ubyte)((packetId >> 8) & 0xFF));
  payload.put(cast(ubyte)(packetId & 0xFF));
  mqttWriteUtf8(payload, topicFilter);
  payload.put(cast(ubyte) qos);

  // MQTT v3.1.1 subscribe must use header flags 0x2.
  return mqttBuildPacket(MQTTPacketType.subscribe, 0x02, payload.data);
}

bool mqttTryDecodeConnAck(const(ubyte)[] packet, out MQTTConnAck connAck) {
  connAck = MQTTConnAck.init;
  if (packet.length < 4) {
    return false;
  }

  auto packetType = cast(MQTTPacketType) (packet[0] >> 4);
  if (packetType != MQTTPacketType.connAck) {
    return false;
  }

  size_t consumed = 0;
  uint remainingLen = 0;
  if (!mqttTryDecodeRemainingLength(packet[1 .. $], consumed, remainingLen)) {
    return false;
  }

  if (remainingLen != 2 || packet.length < 1 + consumed + 2) {
    return false;
  }

  const payloadStart = 1 + consumed;
  connAck.sessionPresent = (packet[payloadStart] & 0x01) == 0x01;
  connAck.returnCode = packet[payloadStart + 1];
  return true;
}

bool mqttTryDecodeRemainingLength(
  const(ubyte)[] encoded,
  out size_t consumed,
  out uint value
) {
  consumed = 0;
  value = 0;

  uint multiplier = 1;
  foreach (i, b; encoded) {
    consumed = i + 1;
    value += (b & 0x7F) * multiplier;

    if ((b & 0x80) == 0) {
      return true;
    }

    if (consumed >= 4) {
      return false;
    }
    multiplier *= 128;
  }

  return false;
}

ubyte[] mqttEncodeRemainingLength(size_t length) {
  auto bytesOut = appender!(ubyte[])();
  size_t x = length;

  do {
    ubyte encodedByte = cast(ubyte) (x % 128);
    x /= 128;
    if (x > 0) {
      encodedByte |= 0x80;
    }
    bytesOut.put(encodedByte);
  } while (x > 0);

  return bytesOut.data;
}

void mqttWriteUtf8(ref Appender!(ubyte[]) sink, string value) {
  enforceMqttUtf8Length(value);
  ushort len = cast(ushort) value.length;
  sink.put(cast(ubyte)((len >> 8) & 0xFF));
  sink.put(cast(ubyte)(len & 0xFF));
  sink.put(cast(const(ubyte)[]) value);
}

void enforceMqttUtf8Length(string value) {
  if (value.length > ushort.max) {
    throw new Exception("MQTT UTF-8 string too long: " ~ value.length.to!string);
  }
}

unittest {
  auto remaining = mqttEncodeRemainingLength(321);
  size_t consumed;
  uint value;
  assert(mqttTryDecodeRemainingLength(remaining, consumed, value));
  assert(consumed == remaining.length);
  assert(value == 321);
}

unittest {
  auto packet = mqttEncodeConnectPacket("client-A", true, 45);
  assert(packet.length >= 14);
  assert((packet[0] >> 4) == cast(ubyte) MQTTPacketType.connect);
}

unittest {
  auto packet = mqttEncodePublishPacket(
    "devices/a/temp",
    "22.1",
    MQTTQoS.atLeastOnce,
    false,
    false,
    42
  );
  assert((packet[0] >> 4) == cast(ubyte) MQTTPacketType.publish);
}

unittest {
  auto packet = mqttEncodeSubscribePacket(3, "devices/+/temp", MQTTQoS.atMostOnce);
  assert((packet[0] >> 4) == cast(ubyte) MQTTPacketType.subscribe);
  assert((packet[0] & 0x0F) == 0x02);
}

unittest {
  // CONNACK: fixed header 0x20, remaining length 0x02, flags 0x00, return code 0x00.
  const packet = cast(ubyte[]) [0x20, 0x02, 0x00, 0x00];
  MQTTConnAck ack;
  assert(mqttTryDecodeConnAck(packet, ack));
  assert(!ack.sessionPresent);
  assert(ack.returnCode == 0);
}
