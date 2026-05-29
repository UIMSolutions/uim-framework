/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.unixconnect.interfaces.session;

@safe:

enum UnixConnectSocketType : ubyte {
  stream = 0,
  datagram = 1
}

struct UnixConnectMessage {
  string sessionId;
  string channel;
  string payload;
  string[string] headers;
}

interface IUnixConnectSession {
  string id();
  IUnixConnectSession id(string value);

  string socketPath();
  IUnixConnectSession socketPath(string value);

  UnixConnectSocketType socketType();
  IUnixConnectSession socketType(UnixConnectSocketType value);

  bool connected();
  IUnixConnectSession connected(bool value);

  string[string] metadata();
  IUnixConnectSession metadata(string[string] value);
  IUnixConnectSession setMetadata(string key, string value);

  bool isValid();
}

alias UnixConnectMessageHandler = void delegate(UnixConnectMessage message) @safe;

interface IUnixConnectService {
  IUnixConnectSession connect(string socketPath, UnixConnectSocketType socketType = UnixConnectSocketType.stream);
  bool disconnect(string sessionId);
  bool connected(string sessionId);

  IUnixConnectSession sessionById(string sessionId);
  IUnixConnectSession[] sessions();

  bool send(UnixConnectMessage message);
  bool subscribe(string channel, UnixConnectMessageHandler handler);
  bool unsubscribe(string channel);
}
