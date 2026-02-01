/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.interfaces.dataset;

import std.datetime : SysTime, Duration;

struct Sample {
    double value;
    SysTime timestamp;
}

interface IValueset {
    void add(Sample s) @safe;
    size_t length() const @safe;
    double[] values() const @safe;
    Sample[] samples() const @safe;
}
