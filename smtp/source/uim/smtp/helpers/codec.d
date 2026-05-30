/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.smtp.helpers.codec;

import std.array : appender;
import std.conv : to;
import std.datetime : Clock, UTC;
import std.format : format;
import std.regex : matchFirst;
import std.string : replace, split, strip;

import uim.smtp.interfaces.message;

@safe:

bool smtpIsValidEmail(string value) {
  auto email = value.strip();
  if (email.length == 0) {
    return false;
  }

  auto m = matchFirst(email, `^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$`);
  return !m.empty;
}

string smtpFormatAddress(SMTPAddress address) {
  auto email = address.email.strip();
  if (address.displayName.strip().length == 0) {
    return format("<%s>", email);
  }

  return format("\"%s\" <%s>", address.displayName.strip(), email);
}

string smtpJoinAddresses(const(SMTPAddress)[] addresses) {
  auto buffer = appender!string();

  foreach (idx, address; addresses) {
    if (idx > 0) {
      buffer.put(", ");
    }

    buffer.put(smtpFormatAddress(address));
  }

  return buffer.data;
}

string smtpNormalizeTextBody(string value) {
  auto normalized = value.replace("\r\n", "\n").replace("\r", "\n");
  auto lines = normalized.split("\n");

  auto buffer = appender!string();
  foreach (idx, line; lines) {
    if (idx > 0) {
      buffer.put("\r\n");
    }

    // SMTP DATA requires dot-stuffing for lines that start with '.'.
    if (line.length > 0 && line[0] == '.') {
      buffer.put('.');
    }

    buffer.put(line);
  }

  return buffer.data;
}

string smtpGenerateBoundary() {
  auto stamp = Clock.currTime(UTC()).toISOExtString();
  return "uim-smtp-" ~ stamp.replace(":", "").replace("-", "");
}

SMTPResponse smtpParseResponseLine(string line) {
  SMTPResponse response;
  auto trimmed = line.strip();

  if (trimmed.length < 3) {
    response.code = 0;
    response.continued = false;
    response.text = trimmed;
    return response;
  }

  auto codePart = trimmed[0 .. 3];
  if (matchFirst(codePart, `^\d{3}$`).empty) {
    response.code = 0;
    response.continued = false;
    response.text = trimmed;
    return response;
  }

  response.code = cast(ushort) codePart.to!int;
  response.continued = trimmed.length > 3 && trimmed[3] == '-';

  if (trimmed.length > 4) {
    response.text = trimmed[4 .. $];
  }

  return response;
}

string smtpMakeTransactionId() {
  return format("smtp-%s", Clock.currTime(UTC()).toUnixTime());
}

unittest {
  assert(smtpIsValidEmail("team@example.org"));
  assert(!smtpIsValidEmail("not-an-email"));

  auto response = smtpParseResponseLine("250 Ok");
  assert(response.code == 250);
  assert(!response.continued);
}
