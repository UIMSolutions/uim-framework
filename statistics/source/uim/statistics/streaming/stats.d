/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.streaming.stats;

import uim.statistics.interfaces.aggregator;
import uim.statistics.interfaces.dataset : Sample;
import std.math : sqrt, isNaN;

/// Welford streaming statistics (mean/variance/stddev/min/max/count).
class StreamingStats : IStreamingStats {
    private double _count;
    private double _mean;
    private double _m2; // sum of squares of differences
    private double _min = double.nan;
    private double _max = double.nan;

    this() @safe {}

    void add(Sample s) @safe {
        _count += 1.0;
        double delta = s.value - _mean;
        _mean += delta / _count;
        double delta2 = s.value - _mean;
        _m2 += delta * delta2;

        if (isNaN(_min) || s.value < _min) _min = s.value;
        if (isNaN(_max) || s.value > _max) _max = s.value;
    }

    void reset() @safe {
        _count = 0;
        _mean = 0;
        _m2 = 0;
        _min = double.nan;
        _max = double.nan;
    }

    double count() const @safe { return _count; }
    double mean() const @safe { return _mean; }
    double variance() const @safe { return _count > 1 ? _m2 / (_count - 1) : 0; }
    double stddev() const @safe { return sqrt(variance()); }
    double min() const @safe { return _min; }
    double max() const @safe { return _max; }
}
