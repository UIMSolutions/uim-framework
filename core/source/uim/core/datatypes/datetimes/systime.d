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
