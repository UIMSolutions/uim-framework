/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdc.interfaces.port;

@safe:

enum CDCParity : ubyte {
  none = 0,
  odd = 1,
  even = 2,
  mark = 3,
  space = 4
}

enum CDCStopBits : ubyte {
  one = 1,
  onePointFive = 2,
  two = 3
}

struct CDCPortConfig {
  string devicePath;
  uint baudRate = 115_200;
  ubyte dataBits = 8;
  CDCParity parity = CDCParity.none;
  CDCStopBits stopBits = CDCStopBits.one;
  uint readTimeoutMs = 500;
  bool newlineDelimited = true;
}

struct CDCFrame {
  string channel;
  string text;
  ubyte[] payload;
}

struct CDCResult {
  bool success;
  size_t bytesTransferred;
  string message;
}

alias CDCFrameHandler = void delegate(CDCFrame frame) @safe;
alias CDCResultHandler = void delegate(CDCResult result) @safe;

interface ICDCService {
  bool open(CDCPortConfig config);
  bool close();

  bool isOpen() const;
  CDCPortConfig config() const;

  bool setLoopback(bool enabled);
  bool clearBuffers();

  CDCResult writeText(string value);
  CDCResult writeBytes(const(ubyte)[] value);

  bool readFrame(out CDCFrame frame);

  bool writeTextAsync(string value, CDCResultHandler handler);
  bool writeBytesAsync(const(ubyte)[] value, CDCResultHandler handler);
  bool pollAsync(CDCFrameHandler handler, uint intervalMs = 100);
}
