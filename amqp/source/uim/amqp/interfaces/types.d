/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.amqp.interfaces.types;

@safe:

// ---------------------------------------------------------------------------
// AMQP 0-9-1 frame type codes
// ---------------------------------------------------------------------------
enum ubyte AMQP_FRAME_METHOD    = 1;
enum ubyte AMQP_FRAME_HEADER    = 2;
enum ubyte AMQP_FRAME_BODY      = 3;
enum ubyte AMQP_FRAME_HEARTBEAT = 8;
enum ubyte AMQP_FRAME_END       = 0xCE;

// ---------------------------------------------------------------------------
// AMQP 0-9-1 class IDs
// ---------------------------------------------------------------------------
enum ushort AMQP_CLASS_CONNECTION = 10;
enum ushort AMQP_CLASS_CHANNEL    = 20;
enum ushort AMQP_CLASS_EXCHANGE   = 40;
enum ushort AMQP_CLASS_QUEUE      = 50;
enum ushort AMQP_CLASS_BASIC      = 60;
enum ushort AMQP_CLASS_TX         = 90;

// ---------------------------------------------------------------------------
// Connection methods (class 10)
// ---------------------------------------------------------------------------
enum ushort AMQP_METH_CONNECTION_START    = 10;
enum ushort AMQP_METH_CONNECTION_START_OK = 11;
enum ushort AMQP_METH_CONNECTION_TUNE     = 30;
enum ushort AMQP_METH_CONNECTION_TUNE_OK  = 31;
enum ushort AMQP_METH_CONNECTION_OPEN     = 40;
enum ushort AMQP_METH_CONNECTION_OPEN_OK  = 41;
enum ushort AMQP_METH_CONNECTION_CLOSE    = 50;
enum ushort AMQP_METH_CONNECTION_CLOSE_OK = 51;

// ---------------------------------------------------------------------------
// Channel methods (class 20)
// ---------------------------------------------------------------------------
enum ushort AMQP_METH_CHANNEL_OPEN     = 10;
enum ushort AMQP_METH_CHANNEL_OPEN_OK  = 11;
enum ushort AMQP_METH_CHANNEL_CLOSE    = 40;
enum ushort AMQP_METH_CHANNEL_CLOSE_OK = 41;

// ---------------------------------------------------------------------------
// Exchange methods (class 40)
// ---------------------------------------------------------------------------
enum ushort AMQP_METH_EXCHANGE_DECLARE    = 10;
enum ushort AMQP_METH_EXCHANGE_DECLARE_OK = 11;
enum ushort AMQP_METH_EXCHANGE_DELETE     = 20;
enum ushort AMQP_METH_EXCHANGE_DELETE_OK  = 21;

// ---------------------------------------------------------------------------
// Queue methods (class 50)
// ---------------------------------------------------------------------------
enum ushort AMQP_METH_QUEUE_DECLARE    = 10;
enum ushort AMQP_METH_QUEUE_DECLARE_OK = 11;
enum ushort AMQP_METH_QUEUE_BIND       = 20;
enum ushort AMQP_METH_QUEUE_BIND_OK    = 21;
enum ushort AMQP_METH_QUEUE_PURGE      = 30;
enum ushort AMQP_METH_QUEUE_PURGE_OK   = 31;
enum ushort AMQP_METH_QUEUE_DELETE     = 40;
enum ushort AMQP_METH_QUEUE_DELETE_OK  = 41;
enum ushort AMQP_METH_QUEUE_UNBIND     = 50;
enum ushort AMQP_METH_QUEUE_UNBIND_OK  = 51;

// ---------------------------------------------------------------------------
// Basic methods (class 60)
// ---------------------------------------------------------------------------
enum ushort AMQP_METH_BASIC_QOS        = 10;
enum ushort AMQP_METH_BASIC_QOS_OK     = 11;
enum ushort AMQP_METH_BASIC_CONSUME    = 20;
enum ushort AMQP_METH_BASIC_CONSUME_OK = 21;
enum ushort AMQP_METH_BASIC_CANCEL     = 30;
enum ushort AMQP_METH_BASIC_CANCEL_OK  = 31;
enum ushort AMQP_METH_BASIC_PUBLISH    = 40;
enum ushort AMQP_METH_BASIC_RETURN     = 50;
enum ushort AMQP_METH_BASIC_DELIVER    = 60;
enum ushort AMQP_METH_BASIC_GET        = 70;
enum ushort AMQP_METH_BASIC_GET_OK     = 71;
enum ushort AMQP_METH_BASIC_GET_EMPTY  = 72;
enum ushort AMQP_METH_BASIC_ACK        = 80;
enum ushort AMQP_METH_BASIC_REJECT     = 90;
enum ushort AMQP_METH_BASIC_NACK       = 120;

// ---------------------------------------------------------------------------
// Tx methods (class 90)
// ---------------------------------------------------------------------------
enum ushort AMQP_METH_TX_SELECT     = 10;
enum ushort AMQP_METH_TX_SELECT_OK  = 11;
enum ushort AMQP_METH_TX_COMMIT     = 20;
enum ushort AMQP_METH_TX_COMMIT_OK  = 21;
enum ushort AMQP_METH_TX_ROLLBACK   = 30;
enum ushort AMQP_METH_TX_ROLLBACK_OK = 31;

// ---------------------------------------------------------------------------
// Exchange type name constants
// ---------------------------------------------------------------------------
immutable AMQP_EXCHANGE_DIRECT  = "direct";
immutable AMQP_EXCHANGE_FANOUT  = "fanout";
immutable AMQP_EXCHANGE_TOPIC   = "topic";
immutable AMQP_EXCHANGE_HEADERS = "headers";

// ---------------------------------------------------------------------------
// Delivery mode constants (Basic.Properties.delivery-mode)
// ---------------------------------------------------------------------------
enum ubyte AMQP_DELIVERY_NON_PERSISTENT = 1;
enum ubyte AMQP_DELIVERY_PERSISTENT     = 2;

// ---------------------------------------------------------------------------
// Default connection parameters
// ---------------------------------------------------------------------------
immutable AMQP_DEFAULT_HOST   = "localhost";
enum ushort AMQP_DEFAULT_PORT  = 5672;
enum ushort AMQPS_DEFAULT_PORT = 5671;
immutable AMQP_DEFAULT_VHOST  = "/";
immutable AMQP_DEFAULT_USER   = "guest";
immutable AMQP_DEFAULT_PASS   = "guest";

enum ushort AMQP_DEFAULT_CHANNEL_MAX = 2047;
enum uint   AMQP_DEFAULT_FRAME_MAX   = 131_072;
enum ushort AMQP_DEFAULT_HEARTBEAT   = 60;

// AMQP 0-9-1 protocol header (8 bytes): 'A','M','Q','P', 0, 0, 9, 1
immutable ubyte[8] AMQP_PROTOCOL_HEADER = [
  cast(ubyte) 'A', cast(ubyte) 'M', cast(ubyte) 'Q', cast(ubyte) 'P',
  cast(ubyte) 0,   cast(ubyte) 0,   cast(ubyte) 9,   cast(ubyte) 1
];

// ---------------------------------------------------------------------------
// Exchange type enum
// ---------------------------------------------------------------------------
enum AmqpExchangeType {
  direct,
  fanout,
  topic,
  headers
}

/// Return the AMQP exchange type name string
string amqpExchangeTypeName(AmqpExchangeType t) pure nothrow @safe {
  final switch (t) {
    case AmqpExchangeType.direct:  return AMQP_EXCHANGE_DIRECT;
    case AmqpExchangeType.fanout:  return AMQP_EXCHANGE_FANOUT;
    case AmqpExchangeType.topic:   return AMQP_EXCHANGE_TOPIC;
    case AmqpExchangeType.headers: return AMQP_EXCHANGE_HEADERS;
  }
}

// ---------------------------------------------------------------------------
// Basic message properties (content header)
// ---------------------------------------------------------------------------
struct AmqpProperties {
  string      contentType;      /// e.g. "application/json"
  string      contentEncoding;  /// e.g. "UTF-8"
  string[string] headers;       /// user-defined headers
  ubyte       deliveryMode;     /// 1=transient, 2=persistent
  ubyte       priority;         /// 0-9
  string      correlationId;    /// for RPC correlation
  string      replyTo;          /// reply-to queue name
  string      expiration;       /// message TTL in milliseconds as string
  string      messageId;
  ulong       timestamp;        /// Unix epoch seconds
  string      type_;            /// application-defined message type hint
  string      userId;
  string      appId;
}

// ---------------------------------------------------------------------------
// An AMQP message (properties + body)
// ---------------------------------------------------------------------------
struct AmqpMessage {
  AmqpProperties properties;
  ubyte[]        body_;

  /// Convenience: interpret body as a UTF-8 string
  string bodyAsString() const @trusted {
    return cast(string) body_.idup;
  }
}

// ---------------------------------------------------------------------------
// Delivery info for a received message
// ---------------------------------------------------------------------------
struct AmqpDelivery {
  string      consumerTag;
  ulong       deliveryTag;
  bool        redelivered;
  string      exchange;
  string      routingKey;
  AmqpMessage message;
  bool        isEmpty;   /// true when basicGet found no message (Get-Empty)
}

// ---------------------------------------------------------------------------
// Result of Queue.Declare-Ok
// ---------------------------------------------------------------------------
struct AmqpQueueDeclareResult {
  string queue;
  uint   messageCount;
  uint   consumerCount;
}

// ---------------------------------------------------------------------------
// Connection configuration
// ---------------------------------------------------------------------------
struct AmqpConfig {
  string host        = "localhost";
  ushort port        = 5672;
  string virtualHost = "/";
  string username    = "guest";
  string password    = "guest";
  ushort channelMax  = 2047;
  uint   frameMax    = 131_072;
  ushort heartbeat   = 60;
  bool   useTLS      = false;
}

// ---------------------------------------------------------------------------
// Raw frame as read from the wire (internal exchange between connection + channel)
// ---------------------------------------------------------------------------
struct RawAmqpFrame {
  ubyte   type_;
  ushort  channel;
  ubyte[] payload;
}

// ---------------------------------------------------------------------------
// Internal connection I/O interface (implemented by UIMAmqpConnection;
// used by UIMAmqpChannel to avoid a circular module import)
// ---------------------------------------------------------------------------
interface IAmqpConnectionIO {
  /// Send a pre-built frame buffer
  void sendRaw(const(ubyte)[] data) @safe;

  /// Read the next frame from the broker (blocks until a complete frame arrives).
  /// Heartbeats are consumed transparently; all other frames are returned.
  RawAmqpFrame readNextFrame() @safe;

  /// Convenience: send a METHOD frame
  void sendMethod(ushort channel, ushort classId, ushort methodId,
                  const(ubyte)[] args) @safe;

  /// Negotiated maximum frame payload size
  @property uint frameMax() const @safe;
}

// ---------------------------------------------------------------------------
// IAmqpChannel — public channel API
// ---------------------------------------------------------------------------
interface IAmqpChannel {
  // -- Exchange --
  void exchangeDeclare(string name, string type_,
                       bool durable = false, bool autoDelete = false,
                       bool passive = false) @safe;
  void exchangeDelete(string name, bool ifUnused = false) @safe;

  // -- Queue --
  AmqpQueueDeclareResult queueDeclare(string name,
                                       bool durable    = false,
                                       bool exclusive  = false,
                                       bool autoDelete = false,
                                       bool passive    = false) @safe;
  void queueDelete(string name, bool ifUnused = false, bool ifEmpty = false) @safe;
  void queueBind(string queue, string exchange, string routingKey = "") @safe;
  void queueUnbind(string queue, string exchange, string routingKey = "") @safe;

  // -- Basic --
  void basicPublish(string exchange, string routingKey,
                    AmqpMessage msg,
                    bool mandatory = false, bool immediate_ = false) @safe;
  void basicAck(ulong deliveryTag, bool multiple = false) @safe;
  void basicNack(ulong deliveryTag, bool multiple = false, bool requeue = true) @safe;
  AmqpDelivery basicGet(string queue, bool noAck = false) @safe;
  void basicQos(uint prefetchSize, ushort prefetchCount, bool global_ = false) @safe;

  // -- Lifecycle --
  void close() @safe;
  @property ushort number() const @safe;
  @property bool   isOpen()  const @safe;
}

// ---------------------------------------------------------------------------
// IAmqpConnection — public connection API
// ---------------------------------------------------------------------------
interface IAmqpConnection {
  IAmqpChannel openChannel() @safe;
  void close() @safe;
  @property bool isOpen()   const @safe;
  @property uint frameMax() const @safe;
}
