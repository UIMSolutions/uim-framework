/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.datetimes.timestamp;

import uim.core;

mixin(ShowModule!());

@safe:

enum startUNIX = DateTime(1970, 1, 1, 0, 0, 0);

/**
  * Convert SysTime to timestamp (long value)
  *
  * Params:
  *   untilTime = The SysTime to convert to timestamp.
  *
  * Returns:
  *   The timestamp as long value.
  */
long toTimestamp(SysTime untilTime) {
  return (untilTime - cast(SysTime)startUNIX).total!"nsecs"();
}
///
unittest {
  mixin(ShowTest!"Testing toTimestamp with SysTime");

  auto n = toTimestamp(now);
  auto n2 = toTimestamp(now);
  assert((n2 - n) >= 0);
}

/** 
  * Convert a timestamp (string value) to SysTime
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

// Convert a timestamp (long value) to SysTime
SysTime fromTimestamp(long aTimestamp) {
  return (cast(SysTime)startUNIX + aTimestamp.nsecs);
}
///
unittest {
  mixin(ShowTest!"Testing fromTimestamp with string");

  auto time = now;
  auto timestamp = toTimestamp(time);
  assert(fromTimestamp(timestamp) == time);
}
///
unittest {
  mixin(ShowTest!"Testing fromTimestamp with long");

  /*
  auto timestamp = 1718472000000000;
  auto sysTime = fromTimestamp(timestamp);
  assert(sysTime.year == 2024);
  assert(sysTime.month == Month.June);
  assert(sysTime.day == 15);
  assert(sysTime.hour == 12);
  assert(sysTime.minute == 0);
  assert(sysTime.second == 0); */
}

long toJSTimestamp(long jsTimestamp) {
  return (fromJSTimestamp(jsTimestamp) - cast(SysTime)startUNIX).total!"msecs"();
}
///
unittest {
  mixin(ShowTest!"Testing toJSTimestamp");

  auto jsTimestamp = 1718472000000;
  auto timestamp = toJSTimestamp(jsTimestamp);
  assert(timestamp == 1718472000000);
}

SysTime fromJSTimestamp(long jsTimestamp) {
  return (cast(SysTime)startUNIX + jsTimestamp.msecs);
}
///
unittest {
  mixin(ShowTest!"Testing fromJSTimestamp");

  /* auto jsTimestamp = 1718472000000;
  auto sysTime = fromJSTimestamp(jsTimestamp);
  assert(sysTime.year == 2024);
  assert(sysTime.month == Month.June);
  assert(sysTime.day == 15);
  assert(sysTime.hour == 12);
  assert(sysTime.minute == 0);
  assert(sysTime.second == 0); */
}

// Current SysTime based on System Clock
auto now() {
  return Clock.currTime();
}
///
unittest {
  mixin(ShowTest!"Testing now function");

  auto time1 = now;
  auto time2 = now;
  assert(time2 >= time1);
}

auto nowTimestamp() {
  return now.toUnixTime();
}

// Current DateTime based on System Clock
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

/// convert time to region format using SysTime
string timeToDateString(size_t time, string regionFormat = "DE") {
  auto sysTime = SysTime(time);
  auto day = to!string(sysTime.day);
  auto mon = to!string(cast(int)sysTime.month);
  auto year = to!string(sysTime.year);
  auto hour = to!string(sysTime.hour);
  auto min = to!string(sysTime.minute);
  auto sec = to!string(sysTime.second);

  switch (regionFormat) {
  case "UK":
    return "%s/%s/%s - %s:%s:%s".format(day, mon, year, hour, min, sec);
  case "US":
    return "%s/%s/%s - %s:%s:%s".format(mon, day, year, hour, min, sec);
  default:
    return "%s. %s. %s - %s:%s:%s".format(day, mon, year, hour, min, sec);
  }
}
///
unittest {
  mixin(ShowTest!"Testing timeToDateString function");

  /* 
  auto timestamp = toTimestamp(SysTime(2024, 6, 15, 12, 30, 45));
  assert(timeToDateString(timestamp, "DE") == "15. 6. 2024 - 12:30:45");
  assert(timeToDateString(timestamp, "UK") == "15/6/2024 - 12:30:45");
  assert(timeToDateString(timestamp, "US") == "6/15/2024 - 12:30:45"); */
}

/// Convert timestamp to DateTime 
string timestampToDateTimeDE(string timeStamp) {
  return timestampToDateTimeDE(to!size_t(timeStamp));
}

string timestampToDateTimeDE(size_t timeStamp) {
  return SysTime(timeStamp).toISOExtString.split(".")[0].replace("T", " ");
}

unittest {
  /// TODO Add Tests
}

/// Convert now to Javascript  
long nowForJs() {
  auto jsTime = DateTime(1970, 1, 1, 0, 0, 0);
  auto dTime = cast(DateTime)now();
  return (dTime - jsTime).total!"msecs";
}

unittest {
  /// TODO Add Tests
}

/// Convert DateTime to Javascript
long datetimeForJs(string dt) {
  auto jsTime = DateTime(1970, 1, 1, 0, 0, 0);
  auto dTime = cast(DateTime)SysTime.fromISOExtString(dt);
  return (dTime - jsTime).total!"msecs";
}

unittest {
  /// TODO Add Tests
}

/// Convert Javascript to dateTime
DateTime jsToDatetime(long jsTime) {
  auto result = DateTime(1970, 1, 1, 0, 0, 0) + msecs(jsTime);
  return cast(DateTime)result;
}

unittest {
  /// TODO Add Tests
}

/// Convert dateTime to german Date string 
string germanDate(long timestamp) {
  return germanDate(cast(DateTime)fromTimestamp(timestamp));
}

string germanDate(DateTime dt) {
  auto strDay = to!string(dt.day);
  if (strDay.length < 2)
    strDay = "0" ~ strDay;

  auto strMonth = to!string(cast(int)dt.month);
  if (strMonth.length < 2)
    strMonth = "0" ~ strMonth;

  auto strYear = to!string(dt.year);
  return "%s.%s.%s".format(strDay, strMonth, strYear);
}

unittest {
  /// TODO Add Tests
}

// Convert dateTime to ISO string
string isoDate(DateTime dt) {
  auto m = (cast(int)dt.month < 10 ? "0" ~ to!string(
      cast(int)dt.month) : to!string(cast(int)dt.month));
  auto d = (dt.day < 10 ? "0" ~ to!string(dt.day) : to!string(dt.day));
  return "%s-%s-%s".format(dt.year, m, d);
}

unittest {
  /// TODO Add Tests
}

/// Convert dateTiem to german Date string 
string toYYYYMMDD(SysTime datetime, string separator = "") {
  return toYYYYMMDD(cast(DateTime)datetime, separator);
}

string toYYYYMMDD(DateTime datetime, string separator = "") {
  string[] results;
  results ~= to!string(datetime.year);
  results ~= (datetime.month < 10 ? "0" : "") ~ to!string(to!int(datetime.month));
  results ~= (datetime.day < 10 ? "0" : "") ~ to!string(datetime.day);
  return results.join(separator);
}

unittest {
  assert(DateTime(Date(1999, 7, 6)).toYYYYMMDD("-") == "1999-07-06");
}

string toString(DateTime datetime, string dateFormat = "YYYYMMD") {
  auto sysTime = SysTime(datetime);
  int iDay = sysTime.day;
  string sDay = to!string(iDay);
  auto tMon = sysTime.month;
  auto iMonth = cast(int)sysTime.month;
  auto sMonth = to!string(iMonth);
  int iYear = sysTime.year;
  string sYear = (iYear < 10 ? "0" : "") ~ to!string(iYear);
  string hour = to!string(sysTime.hour);
  string min = to!string(sysTime.minute);
  string sec = to!string(sysTime.second);

  dateFormat = dateFormat.replace("YYYY", sYear);
  dateFormat = dateFormat.replace("YY", sYear[2 - $ .. $]);
  dateFormat = dateFormat.replace("Y", sYear[1 - $ .. $]);

  dateFormat = dateFormat.replace("MM", sMonth);
  dateFormat = dateFormat.replace("M", sMonth[1 - $ .. $]);

  dateFormat = dateFormat.replace("DD", sDay);
  dateFormat = dateFormat.replace("D", sDay[1 - $ .. $]);

  return dateFormat;
}
