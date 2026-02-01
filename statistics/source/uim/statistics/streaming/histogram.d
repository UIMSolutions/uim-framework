/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.streaming.histogram;

import uim.statistics.interfaces.histogram;
import uim.statistics.interfaces.dataset : Sample;
import std.algorithm : clamp;
import std.array : array;

class Histogram : IHistogram {
    private double _min;
    private double _max;
    private size_t _bins = 0;
    private size_t[] _counts;
    private double _width;

    this() @safe {}

    void configureBins(double minValue, double maxValue, size_t bins) @safe {
        _min = minValue;
        _max = maxValue;
        _bins = bins;
        _counts = new size_t[_bins];
        _width = (_max - _min) / cast(double)_bins;
    }

    void add(Sample s) @safe {
        if (_bins == 0 || _width == 0) return;
        double clamped = clamp(s.value, _min, _max);
        size_t idx = cast(size_t)((clamped - _min) / _width);
        if (idx >= _bins) idx = _bins - 1;
        _counts[idx] += 1;
    }

    void reset() @safe {
        _counts[] = 0;
    }

    BinCount[] counts() const @safe {
        BinCount[] binsOut;
        binsOut.reserve(_bins);
        foreach (i, c; _counts) {
            double lower = _min + i * _width;
            double upper = lower + _width;
            binsOut ~= BinCount(lower, upper, c);
        }
        return binsOut;
    }

    double total() const @safe {
        size_t sum = 0;
        foreach (c; _counts) sum += c;
        return cast(double)sum;
    }
}
