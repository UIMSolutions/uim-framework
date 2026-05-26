/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.mqtt.transport.tcp_adapter;

import std.conv : to;
import std.string : startsWith;

import vibe.core.net : TCPConnection, connectTCP;

import uim.mqtt;

mixin(ShowModule!());

@safe:

struct MQTTBrokerEndpoint {
  string scheme;
  string host;
  ushort port;
}

class UIMMQTTTcpAdapter : UIMObject {
  private MQTTBrokerEndpoint _endpoint;
  private TCPConnection _connection;
  private ushort _nextPacketId = 1;

  bool open(string brokerUrl) {
    try {
      _endpoint = mqttParseBrokerUrl(brokerUrl);
      _connection = connectTCP(_endpoint.host, _endpoint.port);
      return cast(bool) _connection;
    } catch (Exception) {
      return false;
    }
  }

  bool close() {
    if (!_connection) {
      return false;
    }

    _connection.close();
    _connection = TCPConnection.init;
    return true;
  }

  bool isOpen() const {
    return cast(bool) _connection;
  }

  MQTTBrokerEndpoint endpoint() const {
    return _endpoint;
  }

  bool sendConnect(string clientId, bool cleanSession = true, ushort keepAliveSeconds = 30) {
    if (!_connection) {
      return false;
    }

    auto packet = mqttEncodeConnectPacket(clientId, cleanSession, keepAliveSeconds);
    return sendPacket(packet);
  }

  bool sendPublish(IMQTTMessage message) {
    if (!_connection || message is null) {
      return false;
    }

    auto packet = mqttEncodePublishPacket(
      message.topic(),
      message.payload(),
      message.qos(),
      message.retain(),
      message.duplicate(),
      nextPacketId()
    );
    return sendPacket(packet);
  }

  bool sendSubscribe(string topicFilter, MQTTQoS qos = MQTTQoS.atMostOnce) {
    if (!_connection || topicFilter.length == 0) {
      return false;
    }

    auto packet = mqttEncodeSubscribePacket(nextPacketId(), topicFilter, qos);
    return sendPacket(packet);
  }

  bool receivePacket(out ubyte[] packet) {
    packet = null;
    if (!_connection) {
      return false;
    }

    ubyte[1] fixedHeader;
    if (!readExact(_connection, fixedHeader[])) {
      return false;
    }

    auto remainingLengthResult = readRemainingLength(_connection);
    if (!remainingLengthResult.success) {
      return false;
    }

    const totalLength = 1 + remainingLengthResult.encoded.length + remainingLengthResult.value;
    packet.length = totalLength;
    packet[0] = fixedHeader[0];
    packet[1 .. 1 + remainingLengthResult.encoded.length] = remainingLengthResult.encoded[];

    if (remainingLengthResult.value > 0) {
      if (!readExact(_connection, packet[1 + remainingLengthResult.encoded.length .. $])) {
        return false;
      }
    }

    return true;
  }

  private bool sendPacket(const(ubyte)[] packet) {
    if (!_connection || packet.length == 0) {
      return false;
    }

    try {
      _connection.write(packet);
      return true;
    } catch (Exception) {
      return false;
    }
  }

  private ushort nextPacketId() {
    if (_nextPacketId == 0) {
      _nextPacketId = 1;
    }
    return _nextPacketId++;
  }
}

MQTTBrokerEndpoint mqttParseBrokerUrl(string brokerUrl) {
  if (brokerUrl.length == 0) {
    throw new Exception("Broker URL must not be empty");
  }

  MQTTBrokerEndpoint endpoint;

  if (brokerUrl.startsWith("mqtt://")) {
    endpoint.scheme = "mqtt";
    endpoint.port = 1883;
    brokerUrl = brokerUrl[7 .. $];
  } else if (brokerUrl.startsWith("mqtts://")) {
    endpoint.scheme = "mqtts";
    endpoint.port = 8883;
    brokerUrl = brokerUrl[8 .. $];
  } else {
    throw new Exception("Unsupported MQTT broker scheme");
  }

  const slashPos = indexOfOrLength(brokerUrl, '/');
  auto hostPort = brokerUrl[0 .. slashPos];

  if (hostPort.length == 0) {
    throw new Exception("Missing broker host");
  }

  const colonPos = indexOfOrLength(hostPort, ':');
  if (colonPos < hostPort.length) {
    endpoint.host = hostPort[0 .. colonPos];
    auto rawPort = hostPort[colonPos + 1 .. $];
    if (rawPort.length == 0) {
      throw new Exception("Missing broker port");
    }
    endpoint.port = rawPort.to!ushort;
  } else {
    endpoint.host = hostPort;
  }

  if (endpoint.host.length == 0) {
    throw new Exception("Missing broker host");
  }

  return endpoint;
}

private struct RemainingLengthRead {
  bool success;
  uint value;
  ubyte[4] encoded;
  size_t encodedLength;
}

private RemainingLengthRead readRemainingLength(ref TCPConnection connection) {
  RemainingLengthRead result;

  ubyte encodedByte;
  uint multiplier = 1;

  foreach (i; 0 .. 4) {
    ubyte[1] buf;
    if (!readExact(connection, buf[])) {
      return result;
    }

    encodedByte = buf[0];
    result.encoded[i] = encodedByte;
    result.encodedLength = i + 1;
    result.value += (encodedByte & 0x7F) * multiplier;

    if ((encodedByte & 0x80) == 0) {
      result.success = true;
      return result;
    }

    multiplier *= 128;
  }

  return result;
}

private bool readExact(ref TCPConnection connection, scope ubyte[] destination) {
  if (destination.length == 0) {
    return true;
  }

  try {
    connection.read(destination);
    return true;
  } catch (Exception) {
    return false;
  }
}

private size_t indexOfOrLength(string value, dchar needle) {
  foreach (i, ch; value) {
    if (ch == needle) {
      return i;
    }
  }
  return value.length;
}

unittest {
  auto endpoint = mqttParseBrokerUrl("mqtt://localhost");
  assert(endpoint.scheme == "mqtt");
  assert(endpoint.host == "localhost");
  assert(endpoint.port == 1883);
}

unittest {
  auto endpoint = mqttParseBrokerUrl("mqtts://broker.example.com:8884");
  assert(endpoint.scheme == "mqtts");
  assert(endpoint.host == "broker.example.com");
  assert(endpoint.port == 8884);
}

unittest {
  auto adapter = new UIMMQTTTcpAdapter();
  assert(!adapter.isOpen());
  assert(!adapter.sendSubscribe("sensors/#"));
}
