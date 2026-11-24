/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.datetimes.timestamp;

import uim.core;

mixin(ShowModule!());

@safe:

/// Unix epoch (1970-01-01T00:00:00) as calendar value.
enum startUNIX = DateTime(1970, 1, 1, 0, 0, 0);

/// Unix epoch (1970-01-01T00:00:00Z) in SysTime std time (hnsecs since 0001-01-01T00:00:00Z).
enum long unixEpochStdTime = 621_355_968_000_000_000L;

private enum long hnsecsPerMsec = 10_000;
private enum long hnsecsPerSecond = 10_000_000;
private enum long nsecsPerHnsec = 100;

unittest {
  assert(SysTime(startUNIX, UTC()).stdTime == unixEpochStdTime);
}

// #region Nanosecond timestamps
/**
  * Convert SysTime to timestamp (nanoseconds since the Unix epoch, UTC).
  *
  * Params:
  *   untilTime = The SysTime to convert to timestamp.
  *
  * Returns:
  *   The timestamp as long value (resolution: 100 ns).
  */
long toTimestamp(SysTime untilTime) pure nothrow @nogc {
  return (untilTime.stdTime - unixEpochStdTime) * nsecsPerHnsec;
}
///
unittest {
  mixin(ShowTest!"Testing toTimestamp with SysTime");

  auto n = toTimestamp(now);
  auto n2 = toTimestamp(now);
  assert(n2 >= n);

  assert(toTimestamp(SysTime(startUNIX, UTC())) == 0);
  assert(toTimestamp(SysTime(DateTime(2024, 6, 15, 0, 0, 0), UTC())) == 1_718_409_600L * 1_000_000_000L);
}

/**
  * Convert a timestamp (string value, nanoseconds since the Unix epoch) to SysTime.
  *
  * Params:
  *   aTimestamp = The timestamp as string value.
  *
  * Returns:
  *   The SysTime representation of the timestamp.
  */
SysTime fromTimestamp(string aTimestamp) {
  return fromTimestamp(to!long(aTimestamp));
}

/// Convert a timestamp (nanoseconds since the Unix epoch) to SysTime (local time zone).
SysTime fromTimestamp(long aTimestamp) nothrow {
  return SysTime(unixEpochStdTime + aTimestamp / nsecsPerHnsec);
}
///
unittest {
  mixin(ShowTest!"Testing fromTimestamp roundtrip");

  auto time = now;
  assert(fromTimestamp(toTimestamp(time)) == time);
  assert(fromTimestamp(toTimestamp(time).to!string) == time);
}
///
unittest {
  mixin(ShowTest!"Testing fromTimestamp with long");

  auto sysTime = fromTimestamp(1_718_472_000L * 1_000_000_000L).toUTC;
  assert(sysTime.year == 2024);
  assert(sysTime.month == Month.jun);
  assert(sysTime.day == 15);
  assert(sysTime.hour == 17);
  assert(sysTime.minute == 20);
  assert(sysTime.second == 0);
}
// #endregion Nanosecond timestamps

// #region JavaScript timestamps (milliseconds since the Unix epoch)
/// Normalize a JavaScript timestamp (milliseconds); kept for backward compatibility.
long toJSTimestamp(long jsTimestamp) pure nothrow @nogc {
  return jsTimestamp;
}

/// Convert a SysTime to a JavaScript timestamp (milliseconds since the Unix epoch, UTC).
long toJSTimestamp(SysTime time) pure nothrow @nogc {
  return (time.stdTime - unixEpochStdTime) / hnsecsPerMsec;
}
///
unittest {
  mixin(ShowTest!"Testing toJSTimestamp");

  assert(toJSTimestamp(1_718_472_000_000L) == 1_718_472_000_000L);
  assert(toJSTimestamp(SysTime(DateTime(2024, 6, 15, 17, 20, 0), UTC())) == 1_718_472_000_000L);
}

/// Convert a JavaScript timestamp (milliseconds since the Unix epoch) to SysTime (local time zone).
SysTime fromJSTimestamp(long jsTimestamp) nothrow {
  return SysTime(unixEpochStdTime + jsTimestamp * hnsecsPerMsec);
}
///
unittest {
  mixin(ShowTest!"Testing fromJSTimestamp");

  auto sysTime = fromJSTimestamp(1_718_472_000_000L).toUTC;
  assert(sysTime.year == 2024);
  assert(sysTime.month == Month.jun);
  assert(sysTime.day == 15);
  assert(sysTime.hour == 17);
  assert(sysTime.minute == 20);
  assert(sysTime.second == 0);

  auto time = now;
  assert(fromJSTimestamp(toJSTimestamp(time)).toJSTimestamp == time.toJSTimestamp);
}

/// Current time as JavaScript timestamp (milliseconds since the Unix epoch, UTC).
long nowForJs() nothrow @nogc {
  return (Clock.currStdTime - unixEpochStdTime) / hnsecsPerMsec;
}
///
unittest {
  mixin(ShowTest!"Testing nowForJs");

  auto before = toJSTimestamp(now);
  auto js = nowForJs();
  auto after = toJSTimestamp(now);
  assert(before <= js && js <= after);
}

/// Convert an ISO extended string (e.g. "2024-06-15T17:20:00Z") to a JavaScript timestamp.
/// Strings without a time zone suffix are interpreted as local time.
long datetimeForJs(string dt) {
  return toJSTimestamp(SysTime.fromISOExtString(dt));
}
///
unittest {
  mixin(ShowTest!"Testing datetimeForJs");

  assert(datetimeForJs("2024-06-15T17:20:00Z") == 1_718_472_000_000L);
  assert(datetimeForJs("1970-01-01T00:00:00Z") == 0);
}

/// Convert a JavaScript timestamp to a DateTime (UTC calendar value).
DateTime jsToDatetime(long jsTime) pure nothrow {
  return startUNIX + msecs(jsTime);
}
///
unittest {
  mixin(ShowTest!"Testing jsToDatetime");

  assert(jsToDatetime(0) == startUNIX);
  assert(jsToDatetime(1_718_472_000_000L) == DateTime(2024, 6, 15, 17, 20, 0));
}
// #endregion JavaScript timestamps

// #region Current time
/// Current SysTime based on system clock (local time zone).
SysTime now() {
  return Clock.currTime();
}
///
unittest {
  mixin(ShowTest!"Testing now function");

  auto time1 = now;
  auto time2 = now;
  assert(time2 >= time1);
}

/// Current Unix time in seconds.
long nowTimestamp() nothrow @nogc {
  return (Clock.currStdTime - unixEpochStdTime) / hnsecsPerSecond;
}
///
unittest {
  mixin(ShowTest!"Testing nowTimestamp function");

  auto before = now.toUnixTime;
  auto ts = nowTimestamp();
  auto after = now.toUnixTime;
  assert(before <= ts && ts <= after);
}

/// Current DateTime based on system clock (local time zone).
DateTime nowDateTime() {
  return cast(DateTime)now;
}
///
unittest {
  mixin(ShowTest!"Testing nowDateTime function");

  auto dt1 = nowDateTime();
  auto dt2 = nowDateTime();
  assert(dt2 >= dt1);
}
// #endregion Current time

// #region Formatting
/**
  * Format a SysTime std time (hnsecs since 0001-01-01T00:00:00Z) in a regional style.
  *
  * Params:
  *   time = SysTime std time.
  *   regionFormat = "DE" (default): "d. m. yyyy - h:m:s", "UK": "d/m/yyyy - h:m:s", "US": "m/d/yyyy - h:m:s".
  */
string timeToDateString(size_t time, string regionFormat = "DE") {
  return timeToDateString(SysTime(cast(long)time), regionFormat);
}

/// ditto
string timeToDateString(SysTime sysTime, string regionFormat = "DE") {
  const day = sysTime.day;
  const mon = cast(int)sysTime.month;
  const year = sysTime.year;

  switch (regionFormat) {
  case "UK":
    return format("%d/%d/%d - %d:%d:%d", day, mon, year, sysTime.hour, sysTime.minute, sysTime.second);
  case "US":
    return format("%d/%d/%d - %d:%d:%d", mon, day, year, sysTime.hour, sysTime.minute, sysTime.second);
  default:
    return format("%d. %d. %d - %d:%d:%d", day, mon, year, sysTime.hour, sysTime.minute, sysTime.second);
  }
}
///
unittest {
  mixin(ShowTest!"Testing timeToDateString function");

  auto time = SysTime(DateTime(2024, 6, 15, 12, 30, 45));
  assert(timeToDateString(time, "DE") == "15. 6. 2024 - 12:30:45");
  assert(timeToDateString(time, "UK") == "15/6/2024 - 12:30:45");
  assert(timeToDateString(time, "US") == "6/15/2024 - 12:30:45");
  assert(timeToDateString(cast(size_t)time.stdTime) == "15. 6. 2024 - 12:30:45");
}

/// Format a SysTime std time (hnsecs since 0001-01-01T00:00:00Z) as "YYYY-MM-DD hh:mm:ss" (local time).
string timestampToDateTimeDE(string timeStamp) {
  return timestampToDateTimeDE(to!size_t(timeStamp));
}

/// ditto
string timestampToDateTimeDE(size_t timeStamp) {
  const dt = cast(DateTime)SysTime(cast(long)timeStamp);
  return format("%04d-%02d-%02d %02d:%02d:%02d",
    dt.year, cast(int)dt.month, dt.day, dt.hour, dt.minute, dt.second);
}
///
unittest {
  mixin(ShowTest!"Testing timestampToDateTimeDE function");

  auto stdTime = SysTime(DateTime(2024, 6, 5, 7, 8, 9)).stdTime;
  assert(timestampToDateTimeDE(cast(size_t)stdTime) == "2024-06-05 07:08:09");
  assert(timestampToDateTimeDE(stdTime.to!string) == "2024-06-05 07:08:09");
}

/// Format a nanosecond timestamp (see `toTimestamp`) as German date "DD.MM.YYYY" (local time).
string germanDate(long timestamp) {
  return germanDate(cast(DateTime)fromTimestamp(timestamp));
}

/// Format a DateTime as German date "DD.MM.YYYY".
string germanDate(DateTime dt) {
  return format("%02d.%02d.%04d", dt.day, cast(int)dt.month, dt.year);
}
///
unittest {
  mixin(ShowTest!"Testing germanDate function");

  assert(germanDate(DateTime(2024, 6, 5)) == "05.06.2024");
  assert(germanDate(DateTime(1999, 12, 31)) == "31.12.1999");

  auto time = SysTime(DateTime(2024, 6, 5, 12, 0, 0));
  assert(germanDate(toTimestamp(time)) == "05.06.2024");
}

/// Format a DateTime as ISO date "YYYY-MM-DD".
string isoDate(DateTime dt) {
  return toYYYYMMDD(dt, "-");
}
///
unittest {
  mixin(ShowTest!"Testing isoDate function");

  assert(isoDate(DateTime(2024, 6, 5)) == "2024-06-05");
  assert(isoDate(DateTime(1999, 12, 31)) == "1999-12-31");
}

/// Format a SysTime as "YYYY<sep>MM<sep>DD".
string toYYYYMMDD(SysTime datetime, string separator = "") {
  return toYYYYMMDD(cast(DateTime)datetime, separator);
}

/// Format a DateTime as "YYYY<sep>MM<sep>DD".
string toYYYYMMDD(DateTime datetime, string separator = "") {
  return format("%04d%s%02d%s%02d", datetime.year, separator, cast(int)datetime.month, separator, datetime.day);
}
///
unittest {
  mixin(ShowTest!"Testing toYYYYMMDD function");

  assert(DateTime(Date(1999, 7, 6)).toYYYYMMDD("-") == "1999-07-06");
  assert(DateTime(Date(1999, 7, 6)).toYYYYMMDD == "19990706");
  assert(SysTime(DateTime(2024, 12, 31)).toYYYYMMDD("/") == "2024/12/31");
}

/**
  * Format a DateTime using a simple pattern.
  *
  * Tokens (case-sensitive, longest match first; everything else is copied verbatim):
  *   YYYY = 4-digit year, YY = 2-digit year, Y = last digit of year,
  *   MM = 2-digit month, M = month,
  *   DD = 2-digit day, D = day,
  *   hh = 2-digit hour, mm = 2-digit minute, ss = 2-digit second.
  */
string toString(DateTime datetime, string dateFormat = "YYYYMMD") {
  import std.array : appender;
  import std.format : formattedWrite;

  const year = datetime.year;
  const month = cast(int)datetime.month;
  const day = datetime.day;

  auto result = appender!string;
  result.reserve(dateFormat.length + 8);

  size_t i = 0;
  while (i < dateFormat.length) {
    auto rest = dateFormat[i .. $];
    if (rest.startsWith("YYYY")) {
      result.formattedWrite("%04d", year);
      i += 4;
    } else if (rest.startsWith("YY")) {
      result.formattedWrite("%02d", year % 100);
      i += 2;
    } else if (rest.startsWith("Y")) {
      result.formattedWrite("%d", year % 10);
      i += 1;
    } else if (rest.startsWith("MM")) {
      result.formattedWrite("%02d", month);
      i += 2;
    } else if (rest.startsWith("M")) {
      result.formattedWrite("%d", month);
      i += 1;
    } else if (rest.startsWith("DD")) {
      result.formattedWrite("%02d", day);
      i += 2;
    } else if (rest.startsWith("D")) {
      result.formattedWrite("%d", day);
      i += 1;
    } else if (rest.startsWith("hh")) {
      result.formattedWrite("%02d", datetime.hour);
      i += 2;
    } else if (rest.startsWith("mm")) {
      result.formattedWrite("%02d", datetime.minute);
      i += 2;
    } else if (rest.startsWith("ss")) {
      result.formattedWrite("%02d", datetime.second);
      i += 2;
    } else {
      result.put(dateFormat[i]);
      i += 1;
    }
  }
  return result.data;
}
///
unittest {
  mixin(ShowTest!"Testing toString with DateTime");

  auto dt = DateTime(2024, 6, 5, 7, 8, 9);
  assert(toString(dt) == "2024065");
  assert(toString(dt, "YYYY-MM-DD") == "2024-06-05");
  assert(toString(dt, "DD.MM.YY") == "05.06.24");
  assert(toString(dt, "D.M.Y") == "5.6.4");
  assert(toString(dt, "YYYY-MM-DD hh:mm:ss") == "2024-06-05 07:08:09");
}
// #endregion Formatting

// #region Unix second timestamps
/// Unix timestamp in seconds.
alias Timestamp = ulong;

/// Add seconds to a timestamp.
/// Throws if the result would overflow.
Timestamp addSeconds(Timestamp timestamp, ulong seconds) pure {
  if (seconds > Timestamp.max - timestamp)
    throw new Exception("Timestamp overflow");

  return timestamp + seconds;
}

/// Subtract seconds from a timestamp.
/// Throws if the result would be before the Unix epoch.
Timestamp subtractSeconds(Timestamp timestamp, ulong seconds) pure {
  if (seconds > timestamp)
    throw new Exception("Timestamp cannot be negative");

  return timestamp - seconds;
}

/// Return the number of seconds between two timestamps.
/// Throws if end is earlier than start.
ulong secondsBetween(Timestamp start, Timestamp end) pure {
  if (end < start)
    throw new Exception("End timestamp is earlier than start");

  return end - start;
}
///
unittest {
  mixin(ShowTest!"Testing Timestamp arithmetic");

  import std.exception : assertThrown;

  Timestamp ts = 1_000;
  assert(addSeconds(ts, 500) == 1_500);
  assert(subtractSeconds(ts, 1_000) == 0);
  assert(secondsBetween(ts, 1_500) == 500);

  assertThrown(addSeconds(Timestamp.max, 1));
  assertThrown(subtractSeconds(ts, 1_001));
  assertThrown(secondsBetween(1_500, ts));
}
// #endregion Unix second timestamps
