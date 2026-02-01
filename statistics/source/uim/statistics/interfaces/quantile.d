/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.interfaces.quantile;

import uim.statistics.interfaces.dataset : Sample;
import uim.statistics.interfaces.aggregator : IAggregator;

interface IQuantileEstimator : IAggregator {
    /// Configure the target quantile in range (0,1], e.g., 0.5 for median.
    void target(double q) @safe;
    double quantile() const @safe;
}
