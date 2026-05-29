# Library uim-unixconnect

Updated on 28. May 2026

uim-unixconnect is a lightweight D library for UNIX-CONNECT style IPC workflows using vibe.d runtime patterns. It provides typed UNIX socket session models, channel-based messaging, and asynchronous publish/subscribe handling.

## Features

* Typed session contract (`IUnixConnectSession`)
* Session and channel message model (`UnixConnectMessage`)
* Stream/datagram socket type enum (`UnixConnectSocketType`)
* In-memory session registry with connect/disconnect tracking
* Channel-based async message dispatch using vibe.d `runTask`

## Installation

Add this dependency to your dub.sdl:

```d
dependency "uim-framework:unixconnect" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.unixconnect;

void main() {
  auto service = UnixConnectService();
  auto session = service.connect("/tmp/uim-unixconnect.sock", UnixConnectSocketType.stream);

  service.subscribe("events/logistics", (UnixConnectMessage msg) @safe {
    writeln("channel=", msg.channel, " payload=", msg.payload);
  });

  UnixConnectMessage m;
  m.sessionId = session.id();
  m.channel = "events/logistics";
  m.payload = "order-updated";

  service.send(m);
  service.disconnect(session.id());
}
```

## Modules

* `uim.unixconnect`: package entrypoint and re-exports
* `uim.unixconnect.interfaces`: session and service contracts
* `uim.unixconnect.models`: concrete session implementation
* `uim.unixconnect.helpers`: channel normalization helpers
* `uim.unixconnect.service`: connect/disconnect and async channel orchestration

## Notes

* The default implementation is integration-oriented and in-memory.
* For production UNIX domain sockets, keep the same interfaces and plug in concrete socket transport operations.
