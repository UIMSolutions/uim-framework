/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.saml.helpers.time;

import std.datetime.systime : SysTime, Clock;
import std.datetime.timezone : UTC;
import std.format : format;
import core.time : seconds;

@safe:

/// Return the current UTC time formatted as a SAML ISO 8601 instant string
/// e.g. "2026-05-28T12:00:00Z"
string samlNow() {
  auto t = Clock.currTime(UTC());
  return samlFormatDateTime(t);
}

/// Format a SysTime as a SAML instant string (UTC, second precision, trailing Z)
string samlFormatDateTime(SysTime t) {
  return format!"%04d-%02d-%02dT%02d:%02d:%02dZ"(
    t.year, cast(int) t.month, t.day,
    t.hour, t.minute, t.second
  );
}

/// Return a SAML instant string for now + secondsFromNow seconds
string samlFutureDateTime(int secondsFromNow) {
  auto t = Clock.currTime(UTC()) + secondsFromNow.seconds;
  return samlFormatDateTime(t);
}

/// Return a SAML instant for the typical assertion validity window (5 minutes)
string samlDefaultNotOnOrAfter() {
  return samlFutureDateTime(300);
}

/// Return a SAML instant for a tight clock-skew window starting 30 s ago
string samlDefaultNotBefore() {
  return samlFutureDateTime(-30);
}

/// Return true if the given SAML instant string is in the future (with
/// toleranceSeconds clock-skew tolerance, default 60 s)
bool samlInstantInFuture(string instant, int toleranceSeconds = 60) {
  import std.datetime.systime : SysTime;
  import std.conv : to;
  try {
    // Parse "2026-05-28T12:00:00Z" as SysTime
    auto t = SysTime.fromISOExtString(instant);
    auto now = Clock.currTime(UTC());
    return t > now - toleranceSeconds.seconds;
  } catch (Exception) {
    return false;
  }
}

/// Return true if now is within the [notBefore, notOnOrAfter] window (with
/// toleranceSeconds clock-skew tolerance, default 60 s)
bool samlWithinWindow(string notBefore, string notOnOrAfter, int toleranceSeconds = 60) {
  import std.datetime.systime : SysTime;
  try {
    auto now = Clock.currTime(UTC());
    auto tol = toleranceSeconds.seconds;

    if (notBefore.length > 0) {
      auto nb = SysTime.fromISOExtString(notBefore);
      if (now < nb - tol) return false;
    }

    if (notOnOrAfter.length > 0) {
      auto noa = SysTime.fromISOExtString(notOnOrAfter);
      if (now >= noa + tol) return false;
    }

    return true;
  } catch (Exception) {
    return false;
  }
}

unittest {
  import std.string : endsWith;
  auto now = samlNow();
  assert(now.length == 20);
  assert(now[$ - 1] == 'Z');
  assert(now[4] == '-' && now[7] == '-' && now[10] == 'T');

  // Future instant should be in the future
  auto future = samlFutureDateTime(3600);
  assert(future > now);

  // Past instant should fail future check
  assert(!samlInstantInFuture("2000-01-01T00:00:00Z", 0));
  assert(samlInstantInFuture(samlFutureDateTime(3600)));
}
