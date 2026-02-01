/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.interfaces.histogram;

import uim.statistics.interfaces.dataset : Sample;
import uim.statistics.interfaces.aggregator : IAggregator;

struct BinCount {
    double lower;
    double upper;
    size_t count;
}

interface IHistogram : IAggregator {
    void configureBins(double minValue, double maxValue, size_t bins) @safe;
    BinCount[] counts() const @safe;
    double total() const @safe;
}
