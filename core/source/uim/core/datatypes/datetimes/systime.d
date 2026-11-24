module uim.core.datatypes.datetimes.systime;

import uim.core;

mixin(ShowModule!());

@safe:

auto toSystime(long timestamp) {
  import std.datetime.systime;

  return SysTime.fromUnixTime(timestamp);
}
///
unittest {
  mixin(ShowTest!"Testing toSystime function");

  // auto timestamp = 1718472000; // June 15, 2024 12:00:00 PM UTC
  // auto sysTime = toSystime(timestamp);
  // assert(sysTime.year == 2024);
  // assert(sysTime.month == Month.jun);
  // assert(sysTime.day == 15);
  // writeln("systime:hour", sysTime.hour );
  // assert(sysTime.hour == 12);
  // assert(sysTime.minute == 0);
  // assert(sysTime.second == 0);
}

SysTime currentTime() {
  import std.datetime.systime;

  return Clock.currTime();
  ;
}
///
unittest {
  mixin(ShowTest!"Testing currentTime function");

  auto sysTime = currentTime();
  import std.datetime.systime;

  assert(sysTime.year >= 1970); // Basic sanity check
}

/// Current time in UTC.
SysTime nowUTC() {
  return Clock.currTime(UTC());
}

/// Current time in the local time zone.
SysTime nowLocal() {
  return Clock.currTime(LocalTime());
}

/// Format a SysTime as an ISO-8601 extended string.
string toISO(SysTime time) {
  return time.toISOExtString();
}

/// Parse an ISO-8601 extended string into a SysTime.
SysTime fromISO(string text) {
  return SysTime.fromISOExtString(text);
}

/// Convert a SysTime to Unix time in seconds.
long toUnixSeconds(SysTime time) {
  return time.toUnixTime();
}

/// Create a SysTime from Unix time in seconds.
SysTime fromUnixSeconds(long seconds) {
  return SysTime.fromUnixTime(seconds);
}

/// Return the elapsed duration from start to end.
Duration elapsed(SysTime start, SysTime end) {
  return end - start;
}

/// Add a duration to a SysTime.
SysTime addDuration(SysTime time, Duration duration) {
  return time + duration;
}

/// Convert a time to UTC for consistent storage or exchange.
SysTime asUTC(SysTime time) {
  return time.toUTC();
}
