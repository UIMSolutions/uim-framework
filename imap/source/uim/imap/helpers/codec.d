/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.imap.helpers.codec;

import std.conv : to;
import std.string : indexOf, split, strip;

import uim.imap.interfaces.mailbox;

@safe:

IMAPMailboxInfo imapParseListLine(string line) {
  IMAPMailboxInfo info;
  auto parts = line.strip().split();

  if (parts.length == 0) {
    return info;
  }

  // Minimal parser for common: * LIST (...) "/" "INBOX"
  auto nameToken = parts[$ - 1];
  if (nameToken.length >= 2 && nameToken[0] == '"' && nameToken[$ - 1] == '"') {
    info.name = nameToken[1 .. $ - 1];
  } else {
    info.name = nameToken;
  }

  return info;
}

ulong[] imapParseSearchLine(string line) {
  ulong[] result;
  auto parts = line.strip().split();

  foreach (idx, part; parts) {
    if (idx == 0 && part == "*") {
      continue;
    }

    if (idx == 1 && part == "SEARCH") {
      continue;
    }

    if (part.length == 0) {
      continue;
    }

    if (part.indexOf("UID") >= 0) {
      continue;
    }

    try {
      result ~= part.to!ulong;
    } catch (Exception) {
    }
  }

  return result;
}

IMAPMessage imapParseFetchResponse(ulong uid, string raw) {
  IMAPMessage message;
  message.uid = uid;
  message.raw = raw;

  auto boundary = "\r\n\r\n";
  auto index = raw.indexOf(boundary);
  if (index >= 0) {
    message.headers = raw[0 .. cast(size_t) index];
    message.body = raw[cast(size_t) index + boundary.length .. $];
  } else {
    message.headers = raw;
  }

  return message;
}

unittest {
  auto mailbox = imapParseListLine("* LIST (\\HasNoChildren) \"/\" \"INBOX\"");
  assert(mailbox.name == "INBOX");

  auto ids = imapParseSearchLine("* SEARCH 4 7 9");
  assert(ids.length == 3);
  assert(ids[0] == 4);
}
