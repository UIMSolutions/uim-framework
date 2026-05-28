/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.amqp.message;

import uim.amqp;

mixin(ShowModule!());

@safe:

// ---------------------------------------------------------------------------
// Factory helpers for AMQP message structs
// ---------------------------------------------------------------------------

AmqpProperties AmqpProps(
  string contentType = "",
  string contentEncoding = "",
  string[string] headers = null,
  ubyte deliveryMode = 0,
  ubyte priority = 0,
  string correlationId = "",
  string replyTo = "",
  string expiration = "",
  string messageId = "",
  ulong timestamp = 0,
  string type_ = "",
  string userId = "",
  string appId = ""
) {
  AmqpProperties p;
  p.contentType     = contentType;
  p.contentEncoding = contentEncoding;
  p.headers         = headers.dup;
  p.deliveryMode    = deliveryMode;
  p.priority        = priority;
  p.correlationId   = correlationId;
  p.replyTo         = replyTo;
  p.expiration      = expiration;
  p.messageId       = messageId;
  p.timestamp       = timestamp;
  p.type_           = type_;
  p.userId          = userId;
  p.appId           = appId;
  return p;
}

AmqpMessage AmqpMsg(const(ubyte)[] body_, AmqpProperties props = AmqpProperties.init) {
  AmqpMessage m;
  m.properties = props;
  m.body_      = body_.dup;
  return m;
}

AmqpMessage AmqpText(string text, string contentType = "text/plain", ubyte deliveryMode = 0) {
  auto p = AmqpProps(contentType, "UTF-8");
  p.deliveryMode = deliveryMode;
  return AmqpMsg(cast(const(ubyte)[]) text, p);
}

AmqpMessage AmqpJson(string json, ubyte deliveryMode = AMQP_DELIVERY_PERSISTENT) {
  auto p = AmqpProps("application/json", "UTF-8");
  p.deliveryMode = deliveryMode;
  return AmqpMsg(cast(const(ubyte)[]) json, p);
}

AmqpConfig AmqpDefaultConfig() {
  return AmqpConfig(
    AMQP_DEFAULT_HOST,
    AMQP_DEFAULT_PORT,
    AMQP_DEFAULT_VHOST,
    AMQP_DEFAULT_USER,
    AMQP_DEFAULT_PASS,
    AMQP_DEFAULT_CHANNEL_MAX,
    AMQP_DEFAULT_FRAME_MAX,
    AMQP_DEFAULT_HEARTBEAT,
    false
  );
}

AmqpConfig AmqpsDefaultConfig() {
  return AmqpConfig(
    AMQP_DEFAULT_HOST,
    AMQPS_DEFAULT_PORT,
    AMQP_DEFAULT_VHOST,
    AMQP_DEFAULT_USER,
    AMQP_DEFAULT_PASS,
    AMQP_DEFAULT_CHANNEL_MAX,
    AMQP_DEFAULT_FRAME_MAX,
    AMQP_DEFAULT_HEARTBEAT,
    true
  );
}

// ---------------------------------------------------------------------------
// Unit tests
// ---------------------------------------------------------------------------

unittest {
  auto p = AmqpProps("application/json", "UTF-8", ["x-env": "test"], AMQP_DELIVERY_PERSISTENT);
  assert(p.contentType == "application/json");
  assert(p.headers["x-env"] == "test");

  auto m = AmqpText("hello");
  assert(m.bodyAsString() == "hello");
  assert(m.properties.contentType == "text/plain");

  auto j = AmqpJson(`{"ok":true}`);
  assert(j.properties.contentType == "application/json");
  assert(j.properties.deliveryMode == AMQP_DELIVERY_PERSISTENT);

  auto cfg = AmqpDefaultConfig();
  assert(cfg.host == "localhost");
  assert(cfg.port == 5672);

  auto tcfg = AmqpsDefaultConfig();
  assert(tcfg.port == 5671);
  assert(tcfg.useTLS);
}
