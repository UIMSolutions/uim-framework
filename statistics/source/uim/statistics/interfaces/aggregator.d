/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.interfaces.aggregator;

import uim.statistics.interfaces.dataset : Sample;

interface IAggregator {
    void add(Sample s) @safe;
    void reset() @safe;
}

interface IStreamingStats : IAggregator {
    double count() const @safe;
    double mean() const @safe;
    double variance() const @safe;
    double stddev() const @safe;
    double min() const @safe;
    double max() const @safe;
}
