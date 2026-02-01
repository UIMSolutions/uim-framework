/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.streaming.window;

import std.datetime : SysTime, Duration, Clock;
import uim.statistics.interfaces.dataset : Sample;
import uim.statistics.streaming.stats : StreamingStats;

/// Sliding time-window aggregator that prunes expired samples.
class TimeWindowAggregator {
    private Duration _window;
    private Sample[] _samples;
    private StreamingStats _stats;

    this(Duration window) @safe {
        _window = window;
        _stats = new StreamingStats();
    }

    void add(double value, SysTime ts = Clock.currTime()) @safe {
        _samples ~= Sample(value, ts);
        _stats.add(Sample(value, ts));
        _prune(ts);
    }

    StreamingStats snapshot(SysTime now = Clock.currTime()) @safe {
        _prune(now);
        return _stats;
    }

    private void _prune(SysTime now) @safe {
        if (_window == Duration.zero) return;
        auto cutoff = now - _window;
        // Keep only samples newer than cutoff
        Sample[] filtered;
        foreach (s; _samples) {
            if (s.timestamp >= cutoff) {
                filtered ~= s;
            }
        }
        if (filtered.length != _samples.length) {
            _samples = filtered;
            _stats.reset();
            foreach (s; _samples) {
                _stats.add(s);
            }
        }
    }
}
