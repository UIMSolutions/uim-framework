/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.pop3.helpers.codec;

import std.conv : to;
import std.string : indexOf, split, strip;

import uim.pop3.interfaces.mailbox;
import uim.pop3.models.mailbox : POP3StatusErr;

@safe:

POP3Status pop3ParseStatusLine(string line) {
  auto parts = line.strip().split();
  if (parts.length < 3 || parts[0] != "+OK") {
    return POP3StatusErr("invalid STAT response");
  }

  POP3Status status;
  status.success = true;
  status.messageCount = cast(uint) parts[1].to!ulong;
  status.mailboxSizeBytes = parts[2].to!ulong;
  status.message = line.strip();
  return status;
}

POP3MessageMeta pop3ParseListLine(string line) {
  POP3MessageMeta meta;

  auto parts = line.strip().split();
  if (parts.length < 2) {
    return meta;
  }

  meta.number = cast(uint) parts[0].to!ulong;
  meta.sizeBytes = parts[1].to!ulong;
  return meta;
}

POP3MessageMeta pop3ParseUidlLine(string line) {
  POP3MessageMeta meta;

  auto parts = line.strip().split();
  if (parts.length < 2) {
    return meta;
  }

  meta.number = cast(uint) parts[0].to!ulong;
  meta.uid = parts[1];
  return meta;
}

POP3Message pop3ParseRetrResponse(uint number, string uid, string raw) {
  POP3Message message;
  message.number = number;
  message.uid = uid;
  message.raw = raw;

  auto boundary = "\r\n\r\n";
  auto index = raw.indexOf(boundary);
  if (index >= 0) {
    message.headers = raw[0 .. cast(size_t) index];
    message.body = raw[cast(size_t) index + boundary.length .. $];
  } else {
    message.headers = raw;
    message.body = "";
  }

  return message;
}

unittest {
  auto status = pop3ParseStatusLine("+OK 2 320");
  assert(status.success);
  assert(status.messageCount == 2);

  auto listMeta = pop3ParseListLine("1 120");
  assert(listMeta.number == 1);
  assert(listMeta.sizeBytes == 120);

  auto uidMeta = pop3ParseUidlLine("1 abc-uid");
  assert(uidMeta.number == 1);
  assert(uidMeta.uid == "abc-uid");
}
