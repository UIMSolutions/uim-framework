/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module statistics.tests.statistics_test;

import uim.statistics;
import std.datetime : Clock, dur;
import std.stdio;

void main() {
    auto stats = new StreamingStats();
    stats.add(Sample(10, Clock.currTime()));
    stats.add(Sample(20, Clock.currTime()));
    assert(stats.mean() == 15);
    assert(stats.count() == 2);

    auto hist = new Histogram();
    hist.configureBins(0, 100, 10);
    hist.add(Sample(50, Clock.currTime()));
    assert(hist.total() == 1);

    auto p2 = new P2Quantile(0.5);
    p2.add(Sample(10, Clock.currTime()));
    p2.add(Sample(20, Clock.currTime()));
    assert(p2.quantile() >= 10 && p2.quantile() <= 20);

    auto window = new TimeWindowAggregator(5.dur!seconds);
    window.add(5, Clock.currTime());
    auto snap = window.snapshot();
    assert(snap.count() == 1);
    writeln("statistics tests passed");
}
