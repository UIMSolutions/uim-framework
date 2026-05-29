/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.unixconnect.models.session;

import uim.unixconnect;

mixin(ShowModule!());

@safe:

class UIMUnixConnectSession : UIMObject, IUnixConnectSession {
  private string _id;
  private string _socketPath;
  private UnixConnectSocketType _socketType = UnixConnectSocketType.stream;
  private bool _connected;
  private string[string] _metadata;

  this(string id = "", string socketPath = "", UnixConnectSocketType socketType = UnixConnectSocketType.stream) {
    _id = id;
    _socketPath = socketPath;
    _socketType = socketType;
  }

  string id() {
    return _id;
  }

  IUnixConnectSession id(string value) {
    _id = value;
    return this;
  }

  string socketPath() {
    return _socketPath;
  }

  IUnixConnectSession socketPath(string value) {
    _socketPath = value;
    return this;
  }

  UnixConnectSocketType socketType() {
    return _socketType;
  }

  IUnixConnectSession socketType(UnixConnectSocketType value) {
    _socketType = value;
    return this;
  }

  bool connected() {
    return _connected;
  }

  IUnixConnectSession connected(bool value) {
    _connected = value;
    return this;
  }

  string[string] metadata() {
    return _metadata.dup;
  }

  IUnixConnectSession metadata(string[string] value) {
    _metadata = value.dup;
    return this;
  }

  IUnixConnectSession setMetadata(string key, string value) {
    if (key.length > 0) {
      _metadata[key] = value;
    }

    return this;
  }

  bool isValid() {
    return _id.length > 0 && _socketPath.length > 0;
  }
}

IUnixConnectSession UnixConnectSession(
  string id = "",
  string socketPath = "",
  UnixConnectSocketType socketType = UnixConnectSocketType.stream
) {
  return new UIMUnixConnectSession(id, socketPath, socketType);
}

unittest {
  auto s = UnixConnectSession("s1", "/tmp/uim.sock", UnixConnectSocketType.stream)
    .connected(true)
    .setMetadata("role", "publisher");

  assert(s.isValid());
  assert(s.connected());
  assert(s.metadata()["role"] == "publisher");
}
