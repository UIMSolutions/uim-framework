/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.pop3.interfaces.mailbox;

@safe:

enum POP3Security : ubyte {
  none = 0,
  startTLS = 1,
  tls = 2
}

struct POP3Config {
  string host;
  ushort port = 110;
  POP3Security security = POP3Security.none;
  string username;
  string password;
  uint connectTimeoutMs = 5_000;
  uint commandTimeoutMs = 5_000;
}

struct POP3Status {
  bool success;
  uint messageCount;
  ulong mailboxSizeBytes;
  string message;
}

struct POP3MessageMeta {
  uint number;
  ulong sizeBytes;
  string uid;
}

struct POP3Message {
  uint number;
  string uid;
  string raw;
  string headers;
  string body;
}

struct POP3Result {
  bool success;
  string message;
}

alias POP3StatusHandler = void delegate(POP3Status status) @safe;
alias POP3MessageHandler = void delegate(POP3Message message) @safe;
alias POP3ResultHandler = void delegate(POP3Result result) @safe;

alias POP3StatDelegate = POP3Status delegate(POP3Config config) @safe;
alias POP3ListDelegate = POP3MessageMeta[] delegate(POP3Config config) @safe;
alias POP3UidlDelegate = POP3MessageMeta[] delegate(POP3Config config) @safe;
alias POP3RetrDelegate = POP3Message delegate(POP3Config config, uint number) @safe;
alias POP3DeleDelegate = POP3Result delegate(POP3Config config, uint number) @safe;

interface IPOP3Service {
  bool configure(POP3Config config);
  POP3Config config() const;

  bool setStatProvider(POP3StatDelegate provider);
  bool setListProvider(POP3ListDelegate provider);
  bool setUidlProvider(POP3UidlDelegate provider);
  bool setRetrProvider(POP3RetrDelegate provider);
  bool setDeleProvider(POP3DeleDelegate provider);

  POP3Status stat();
  POP3MessageMeta[] list();
  POP3MessageMeta[] uidl();
  POP3Message retr(uint number);
  POP3Result dele(uint number);

  bool statAsync(POP3StatusHandler handler);
  bool retrAsync(uint number, POP3MessageHandler handler);
  bool deleAsync(uint number, POP3ResultHandler handler);

  POP3Status parseStatusLine(string line);
  POP3MessageMeta parseListLine(string line);
  POP3MessageMeta parseUidlLine(string line);
  POP3Message parseRetrResponse(uint number, string uid, string raw);
}
