/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.core.series;

import std.datetime : SysTime, Duration, dur;
import uim.statistics.interfaces.dataset : Sample;

/// Simple time series buffer with optional retention window.
class TimeSeries {
    private Sample[] _samples;
    private Duration _retention = Duration.zero;

    this(Duration retention = Duration.zero) @safe {
        _retention = retention;
    }

    void add(double value, SysTime ts) @safe {
        _samples ~= Sample(value, ts);
        _prune(ts);
    }

    Sample[] window(SysTime now) @safe {
        _prune(now);
        return _samples.dup;
    }

    private void _prune(SysTime now) @safe {
        if (_retention == Duration.zero) return;
        auto cutoff = now - _retention;
        size_t idx = 0;
        foreach (i, s; _samples) {
            if (s.timestamp >= cutoff) { idx = i; break; }
        }
        if (idx > 0 && idx < _samples.length) {
            _samples = _samples[idx .. $];
        }
    }
}
