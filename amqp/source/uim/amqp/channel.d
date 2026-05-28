/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.amqp.channel;

import vibe.core.log : logDiagnostic, logWarn;

import uim.amqp;

mixin(ShowModule!());

@safe:

class UIMAmqpChannel : UIMObject, IAmqpChannel {

  private {
    IAmqpConnectionIO _io;
    ushort            _number;
    bool              _open;
  }

  this(IAmqpConnectionIO io, ushort number) @safe {
    _io     = io;
    _number = number;
    _open   = true;

    _sendMethod(AMQP_CLASS_CHANNEL, AMQP_METH_CHANNEL_OPEN, _encodeChannelOpenArgs());
    auto m = _expectMethod(AMQP_CLASS_CHANNEL, AMQP_METH_CHANNEL_OPEN_OK);
    logDiagnostic("AMQP channel %s opened", _number);
  }

  @property ushort number() const @safe { return _number; }
  @property bool isOpen() const @safe { return _open; }

  // -------------------------------------------------------------------------
  // Exchange
  // -------------------------------------------------------------------------

  void exchangeDeclare(string name, string type_, bool durable = false,
                       bool autoDelete = false, bool passive = false) @safe {
    _ensureOpen();
    auto args = _encodeExchangeDeclareArgs(name, type_, durable, autoDelete, passive);
    _sendMethod(AMQP_CLASS_EXCHANGE, AMQP_METH_EXCHANGE_DECLARE, args);
    _expectMethod(AMQP_CLASS_EXCHANGE, AMQP_METH_EXCHANGE_DECLARE_OK);
  }

  void exchangeDelete(string name, bool ifUnused = false) @safe {
    _ensureOpen();
    auto args = _encodeExchangeDeleteArgs(name, ifUnused);
    _sendMethod(AMQP_CLASS_EXCHANGE, AMQP_METH_EXCHANGE_DELETE, args);
    _expectMethod(AMQP_CLASS_EXCHANGE, AMQP_METH_EXCHANGE_DELETE_OK);
  }

  // -------------------------------------------------------------------------
  // Queue
  // -------------------------------------------------------------------------

  AmqpQueueDeclareResult queueDeclare(string name, bool durable = false,
                                      bool exclusive = false, bool autoDelete = false,
                                      bool passive = false) @safe {
    _ensureOpen();
    auto args = _encodeQueueDeclareArgs(name, durable, exclusive, autoDelete, passive);
    _sendMethod(AMQP_CLASS_QUEUE, AMQP_METH_QUEUE_DECLARE, args);
    auto payload = _expectMethod(AMQP_CLASS_QUEUE, AMQP_METH_QUEUE_DECLARE_OK);
    return _decodeQueueDeclareOk(payload);
  }

  void queueDelete(string name, bool ifUnused = false, bool ifEmpty = false) @safe {
    _ensureOpen();
    auto args = _encodeQueueDeleteArgs(name, ifUnused, ifEmpty);
    _sendMethod(AMQP_CLASS_QUEUE, AMQP_METH_QUEUE_DELETE, args);
    _expectMethod(AMQP_CLASS_QUEUE, AMQP_METH_QUEUE_DELETE_OK);
  }

  void queueBind(string queue, string exchange, string routingKey = "") @safe {
    _ensureOpen();
    auto args = _encodeQueueBindArgs(queue, exchange, routingKey);
    _sendMethod(AMQP_CLASS_QUEUE, AMQP_METH_QUEUE_BIND, args);
    _expectMethod(AMQP_CLASS_QUEUE, AMQP_METH_QUEUE_BIND_OK);
  }

  void queueUnbind(string queue, string exchange, string routingKey = "") @safe {
    _ensureOpen();
    auto args = _encodeQueueUnbindArgs(queue, exchange, routingKey);
    _sendMethod(AMQP_CLASS_QUEUE, AMQP_METH_QUEUE_UNBIND, args);
    _expectMethod(AMQP_CLASS_QUEUE, AMQP_METH_QUEUE_UNBIND_OK);
  }

  // -------------------------------------------------------------------------
  // Basic
  // -------------------------------------------------------------------------

  void basicPublish(string exchange, string routingKey, AmqpMessage msg,
                    bool mandatory = false, bool immediate_ = false) @safe {
    _ensureOpen();

    // 1) Basic.Publish method frame
    auto methodArgs = _encodeBasicPublishArgs(exchange, routingKey, mandatory, immediate_);
    _sendMethod(AMQP_CLASS_BASIC, AMQP_METH_BASIC_PUBLISH, methodArgs);

    // 2) Content header frame (class-id + weight + body-size + property-flags + property values)
    auto headerPayload = _encodeContentHeaderPayload(AMQP_CLASS_BASIC, msg);
    _sendFrame(AMQP_FRAME_HEADER, headerPayload);

    // 3) Body frame(s)
    uint maxPayload = _io.frameMax();
    if (maxPayload == 0) maxPayload = AMQP_DEFAULT_FRAME_MAX;

    size_t pos = 0;
    while (pos < msg.body_.length) {
      auto chunkLen = cast(size_t) (msg.body_.length - pos > maxPayload ? maxPayload : msg.body_.length - pos);
      _sendFrame(AMQP_FRAME_BODY, msg.body_[pos .. pos + chunkLen]);
      pos += chunkLen;
    }
  }

  void basicAck(ulong deliveryTag, bool multiple = false) @safe {
    _ensureOpen();
    auto args = _encodeBasicAckArgs(deliveryTag, multiple);
    _sendMethod(AMQP_CLASS_BASIC, AMQP_METH_BASIC_ACK, args);
  }

  void basicNack(ulong deliveryTag, bool multiple = false, bool requeue = true) @safe {
    _ensureOpen();
    auto args = _encodeBasicNackArgs(deliveryTag, multiple, requeue);
    _sendMethod(AMQP_CLASS_BASIC, AMQP_METH_BASIC_NACK, args);
  }

  AmqpDelivery basicGet(string queue, bool noAck = false) @safe {
    _ensureOpen();
    auto args = _encodeBasicGetArgs(queue, noAck);
    _sendMethod(AMQP_CLASS_BASIC, AMQP_METH_BASIC_GET, args);

    auto firstPayload = _expectMethodAny(AMQP_CLASS_BASIC, [AMQP_METH_BASIC_GET_OK, AMQP_METH_BASIC_GET_EMPTY]);
    ushort firstMethod = _lastMethodId;

    if (firstMethod == AMQP_METH_BASIC_GET_EMPTY) {
      AmqpDelivery d;
      d.isEmpty = true;
      return d;
    }

    auto del = _decodeBasicGetOk(firstPayload);

    // Then a content header frame and body frames follow.
    auto msg = _readContentMessage();
    del.message = msg;
    return del;
  }

  void basicQos(uint prefetchSize, ushort prefetchCount, bool global_ = false) @safe {
    _ensureOpen();
    auto args = _encodeBasicQosArgs(prefetchSize, prefetchCount, global_);
    _sendMethod(AMQP_CLASS_BASIC, AMQP_METH_BASIC_QOS, args);
    _expectMethod(AMQP_CLASS_BASIC, AMQP_METH_BASIC_QOS_OK);
  }

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------

  void close() @safe {
    if (!_open) return;

    auto args = _encodeChannelCloseArgs(200, "Goodbye", AMQP_CLASS_CHANNEL, 0);
    _sendMethod(AMQP_CLASS_CHANNEL, AMQP_METH_CHANNEL_CLOSE, args);

    // Peer may either send Channel.Close-Ok directly or Channel.Close first.
    auto payload = _expectMethodAny(AMQP_CLASS_CHANNEL, [AMQP_METH_CHANNEL_CLOSE_OK, AMQP_METH_CHANNEL_CLOSE]);
    if (_lastMethodId == AMQP_METH_CHANNEL_CLOSE) {
      _sendMethod(AMQP_CLASS_CHANNEL, AMQP_METH_CHANNEL_CLOSE_OK, []);
    }
    _open = false;
  }

  // -------------------------------------------------------------------------
  // Internal: wire send / receive
  // -------------------------------------------------------------------------

  private ushort _lastMethodId;

  private void _sendMethod(ushort classId, ushort methodId, const(ubyte)[] args) @safe {
    _io.sendMethod(_number, classId, methodId, args);
  }

  private void _sendFrame(ubyte type_, const(ubyte)[] payload) @safe {
    auto frame = amqpBuildFrame(type_, _number, payload, AMQP_FRAME_END);
    _io.sendRaw(frame);
  }

  private ubyte[] _expectMethod(ushort classId, ushort methodId) @safe {
    auto payload = _expectMethodAny(classId, [methodId]);
    return payload;
  }

  private ubyte[] _expectMethodAny(ushort classId, const(ushort)[] methodIds) @safe {
    while (true) {
      auto frame = _io.readNextFrame();
      if (frame.channel != _number) {
        // Ignore frames from other channels in this lightweight implementation
        continue;
      }

      if (frame.type_ != AMQP_FRAME_METHOD) {
        continue;
      }

      size_t pos = 0;
      ushort cId;
      ushort mId;
      if (!amqpReadU16(frame.payload, pos, cId) || !amqpReadU16(frame.payload, pos, mId)) {
        throw new Exception("AMQP protocol error: malformed method frame");
      }
      if (cId != classId) {
        continue;
      }

      foreach (wanted; methodIds) {
        if (mId == wanted) {
          _lastMethodId = mId;
          return frame.payload[pos .. $].dup;
        }
      }

      // Channel-level close propagated as exception
      if (cId == AMQP_CLASS_CHANNEL && mId == AMQP_METH_CHANNEL_CLOSE) {
        throw new Exception("AMQP channel closed by peer");
      }
    }
    return null;
  }

  private AmqpMessage _readContentMessage() @safe {
    ulong bodySize = 0;
    AmqpProperties props;

    while (true) {
      auto frame = _io.readNextFrame();
      if (frame.channel != _number) continue;

      if (frame.type_ == AMQP_FRAME_HEADER) {
        size_t pos = 0;
        ushort classId;
        ushort weight;
        ushort flags;
        if (!amqpReadU16(frame.payload, pos, classId) ||
            !amqpReadU16(frame.payload, pos, weight) ||
            !amqpReadU64(frame.payload, pos, bodySize) ||
            !amqpReadU16(frame.payload, pos, flags)) {
          throw new Exception("AMQP protocol error: malformed content header");
        }

        // Decode only first 14 basic properties bits (single flags word)
        if ((flags & 0x8000) != 0) amqpReadShortStr(frame.payload, pos, props.contentType);
        if ((flags & 0x4000) != 0) amqpReadShortStr(frame.payload, pos, props.contentEncoding);
        if ((flags & 0x2000) != 0) amqpReadFieldTableStringMap(frame.payload, pos, props.headers);
        if ((flags & 0x1000) != 0) { ubyte v; amqpReadU8(frame.payload, pos, v); props.deliveryMode = v; }
        if ((flags & 0x0800) != 0) { ubyte v; amqpReadU8(frame.payload, pos, v); props.priority = v; }
        if ((flags & 0x0400) != 0) amqpReadShortStr(frame.payload, pos, props.correlationId);
        if ((flags & 0x0200) != 0) amqpReadShortStr(frame.payload, pos, props.replyTo);
        if ((flags & 0x0100) != 0) amqpReadShortStr(frame.payload, pos, props.expiration);
        if ((flags & 0x0080) != 0) amqpReadShortStr(frame.payload, pos, props.messageId);
        if ((flags & 0x0040) != 0) { ulong ts; amqpReadU64(frame.payload, pos, ts); props.timestamp = ts; }
        if ((flags & 0x0020) != 0) amqpReadShortStr(frame.payload, pos, props.type_);
        if ((flags & 0x0010) != 0) amqpReadShortStr(frame.payload, pos, props.userId);
        if ((flags & 0x0008) != 0) amqpReadShortStr(frame.payload, pos, props.appId);

        break;
      }
    }

    ubyte[] body;
    while (body.length < bodySize) {
      auto frame = _io.readNextFrame();
      if (frame.channel != _number) continue;
      if (frame.type_ != AMQP_FRAME_BODY) continue;
      body ~= frame.payload;
    }

    if (body.length > bodySize) body = body[0 .. cast(size_t) bodySize].dup;

    AmqpMessage msg;
    msg.properties = props;
    msg.body_      = body;
    return msg;
  }

  // -------------------------------------------------------------------------
  // Internal: argument encoders
  // -------------------------------------------------------------------------

  private ubyte[] _encodeChannelOpenArgs() @safe {
    // out-of-band field: shortstr, default empty
    ubyte[] args;
    amqpWriteShortStr(args, "");
    return args;
  }

  private ubyte[] _encodeChannelCloseArgs(ushort replyCode, string replyText,
                                          ushort classId, ushort methodId) @safe {
    ubyte[] args;
    amqpWriteU16(args, replyCode);
    amqpWriteShortStr(args, replyText);
    amqpWriteU16(args, classId);
    amqpWriteU16(args, methodId);
    return args;
  }

  private ubyte[] _encodeExchangeDeclareArgs(string name, string type_,
                                             bool durable, bool autoDelete, bool passive) @safe {
    ubyte[] args;
    amqpWriteU16(args, 0);                 // reserved-1
    amqpWriteShortStr(args, name);         // exchange
    amqpWriteShortStr(args, type_);        // type
    ubyte bits = 0;
    if (passive)    bits |= 1 << 0;
    // bit1 = durable
    if (durable)    bits |= 1 << 1;
    // bit2 = auto-delete
    if (autoDelete) bits |= 1 << 2;
    // bit3 = internal (false)
    // bit4 = no-wait (false)
    amqpWriteU8(args, bits);
    amqpWriteFieldTableStringMap(args, null); // arguments table
    return args;
  }

  private ubyte[] _encodeExchangeDeleteArgs(string name, bool ifUnused) @safe {
    ubyte[] args;
    amqpWriteU16(args, 0);
    amqpWriteShortStr(args, name);
    ubyte bits = 0;
    if (ifUnused) bits |= 1 << 0;
    // no-wait false
    amqpWriteU8(args, bits);
    return args;
  }

  private ubyte[] _encodeQueueDeclareArgs(string name, bool durable,
                                          bool exclusive, bool autoDelete,
                                          bool passive) @safe {
    ubyte[] args;
    amqpWriteU16(args, 0);        // reserved-1
    amqpWriteShortStr(args, name);
    ubyte bits = 0;
    if (passive)    bits |= 1 << 0;
    if (durable)    bits |= 1 << 1;
    if (exclusive)  bits |= 1 << 2;
    if (autoDelete) bits |= 1 << 3;
    // bit4 = no-wait
    amqpWriteU8(args, bits);
    amqpWriteFieldTableStringMap(args, null);
    return args;
  }

  private ubyte[] _encodeQueueDeleteArgs(string name, bool ifUnused, bool ifEmpty) @safe {
    ubyte[] args;
    amqpWriteU16(args, 0);
    amqpWriteShortStr(args, name);
    ubyte bits = 0;
    if (ifUnused) bits |= 1 << 0;
    if (ifEmpty)  bits |= 1 << 1;
    amqpWriteU8(args, bits);
    return args;
  }

  private ubyte[] _encodeQueueBindArgs(string queue, string exchange, string routingKey) @safe {
    ubyte[] args;
    amqpWriteU16(args, 0);
    amqpWriteShortStr(args, queue);
    amqpWriteShortStr(args, exchange);
    amqpWriteShortStr(args, routingKey);
    amqpWriteU8(args, 0); // no-wait false
    amqpWriteFieldTableStringMap(args, null);
    return args;
  }

  private ubyte[] _encodeQueueUnbindArgs(string queue, string exchange, string routingKey) @safe {
    ubyte[] args;
    amqpWriteU16(args, 0);
    amqpWriteShortStr(args, queue);
    amqpWriteShortStr(args, exchange);
    amqpWriteShortStr(args, routingKey);
    amqpWriteFieldTableStringMap(args, null);
    return args;
  }

  private ubyte[] _encodeBasicPublishArgs(string exchange, string routingKey,
                                          bool mandatory, bool immediate_) @safe {
    ubyte[] args;
    amqpWriteU16(args, 0);  // reserved-1
    amqpWriteShortStr(args, exchange);
    amqpWriteShortStr(args, routingKey);
    ubyte bits = 0;
    if (mandatory) bits |= 1 << 0;
    if (immediate_) bits |= 1 << 1;
    amqpWriteU8(args, bits);
    return args;
  }

  private ubyte[] _encodeBasicAckArgs(ulong deliveryTag, bool multiple) @safe {
    ubyte[] args;
    amqpWriteU64(args, deliveryTag);
    amqpWriteU8(args, multiple ? 1 : 0);
    return args;
  }

  private ubyte[] _encodeBasicNackArgs(ulong deliveryTag, bool multiple, bool requeue) @safe {
    ubyte[] args;
    amqpWriteU64(args, deliveryTag);
    ubyte bits = 0;
    if (multiple) bits |= 1 << 0;
    if (requeue)  bits |= 1 << 1;
    amqpWriteU8(args, bits);
    return args;
  }

  private ubyte[] _encodeBasicGetArgs(string queue, bool noAck) @safe {
    ubyte[] args;
    amqpWriteU16(args, 0); // reserved-1
    amqpWriteShortStr(args, queue);
    amqpWriteU8(args, noAck ? 1 : 0);
    return args;
  }

  private ubyte[] _encodeBasicQosArgs(uint prefetchSize, ushort prefetchCount, bool global_) @safe {
    ubyte[] args;
    amqpWriteU32(args, prefetchSize);
    amqpWriteU16(args, prefetchCount);
    amqpWriteU8(args, global_ ? 1 : 0);
    return args;
  }

  private ubyte[] _encodeContentHeaderPayload(ushort classId, const(AmqpMessage) msg) @safe {
    ubyte[] payload;

    amqpWriteU16(payload, classId);
    amqpWriteU16(payload, 0); // weight
    amqpWriteU64(payload, cast(ulong) msg.body_.length);

    ushort flags = 0;
    if (msg.properties.contentType.length)     flags |= 0x8000;
    if (msg.properties.contentEncoding.length) flags |= 0x4000;
    if (msg.properties.headers.length)         flags |= 0x2000;
    if (msg.properties.deliveryMode)           flags |= 0x1000;
    if (msg.properties.priority)               flags |= 0x0800;
    if (msg.properties.correlationId.length)   flags |= 0x0400;
    if (msg.properties.replyTo.length)         flags |= 0x0200;
    if (msg.properties.expiration.length)      flags |= 0x0100;
    if (msg.properties.messageId.length)       flags |= 0x0080;
    if (msg.properties.timestamp)              flags |= 0x0040;
    if (msg.properties.type_.length)           flags |= 0x0020;
    if (msg.properties.userId.length)          flags |= 0x0010;
    if (msg.properties.appId.length)           flags |= 0x0008;

    amqpWriteU16(payload, flags);

    if (msg.properties.contentType.length)     amqpWriteShortStr(payload, msg.properties.contentType);
    if (msg.properties.contentEncoding.length) amqpWriteShortStr(payload, msg.properties.contentEncoding);
    if (msg.properties.headers.length)         amqpWriteFieldTableStringMap(payload, msg.properties.headers);
    if (msg.properties.deliveryMode)           amqpWriteU8(payload, msg.properties.deliveryMode);
    if (msg.properties.priority)               amqpWriteU8(payload, msg.properties.priority);
    if (msg.properties.correlationId.length)   amqpWriteShortStr(payload, msg.properties.correlationId);
    if (msg.properties.replyTo.length)         amqpWriteShortStr(payload, msg.properties.replyTo);
    if (msg.properties.expiration.length)      amqpWriteShortStr(payload, msg.properties.expiration);
    if (msg.properties.messageId.length)       amqpWriteShortStr(payload, msg.properties.messageId);
    if (msg.properties.timestamp)              amqpWriteU64(payload, msg.properties.timestamp);
    if (msg.properties.type_.length)           amqpWriteShortStr(payload, msg.properties.type_);
    if (msg.properties.userId.length)          amqpWriteShortStr(payload, msg.properties.userId);
    if (msg.properties.appId.length)           amqpWriteShortStr(payload, msg.properties.appId);

    return payload;
  }

  // -------------------------------------------------------------------------
  // Internal: method decoders
  // -------------------------------------------------------------------------

  private AmqpQueueDeclareResult _decodeQueueDeclareOk(const(ubyte)[] payload) @safe {
    size_t pos = 0;
    AmqpQueueDeclareResult out_;

    if (!amqpReadShortStr(payload, pos, out_.queue)) {
      throw new Exception("AMQP protocol error: malformed Queue.Declare-Ok queue");
    }
    if (!amqpReadU32(payload, pos, out_.messageCount)) {
      throw new Exception("AMQP protocol error: malformed Queue.Declare-Ok message-count");
    }
    if (!amqpReadU32(payload, pos, out_.consumerCount)) {
      throw new Exception("AMQP protocol error: malformed Queue.Declare-Ok consumer-count");
    }

    return out_;
  }

  private AmqpDelivery _decodeBasicGetOk(const(ubyte)[] payload) @safe {
    size_t pos = 0;
    AmqpDelivery d;

    if (!amqpReadU64(payload, pos, d.deliveryTag)) {
      throw new Exception("AMQP protocol error: malformed Basic.Get-Ok delivery-tag");
    }

    ubyte redelivered;
    if (!amqpReadU8(payload, pos, redelivered)) {
      throw new Exception("AMQP protocol error: malformed Basic.Get-Ok redelivered");
    }
    d.redelivered = redelivered != 0;

    if (!amqpReadShortStr(payload, pos, d.exchange) ||
        !amqpReadShortStr(payload, pos, d.routingKey)) {
      throw new Exception("AMQP protocol error: malformed Basic.Get-Ok routing info");
    }

    uint msgCount;
    if (!amqpReadU32(payload, pos, msgCount)) {
      throw new Exception("AMQP protocol error: malformed Basic.Get-Ok message-count");
    }

    d.isEmpty = false;
    return d;
  }

  // -------------------------------------------------------------------------
  // Internal guards
  // -------------------------------------------------------------------------

  private void _ensureOpen() @safe {
    if (!_open) {
      throw new Exception("AMQP channel is closed");
    }
  }
}
