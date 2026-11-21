module uim.service.helpers.time;

import uim.service;

mixin(ShowModule!());

@safe:

string formatTimestamp(long timestamp) {
    if (timestamp == 0) return "—";
    auto st = SysTime(unixTimeToStdTime(timestamp));
    return format!"%04d-%02d-%02d"(st.year, cast(int) st.month, st.day);
}
///
unittest {
    import std.datetime : SysTime, unixTimeToStdTime;
    import std.format  : format;
    assert(formatTimestamp(0) == "—");
    auto now = Clock.currTime();
    auto ts = now.toUnixTime;
    
    // writeln("Formatted current time: ", formatTimestamp(ts));
    assert(formatTimestamp(ts) == format!"%04d-%02d-%02d"(now.year, cast(int) now.month, now.day));
}   