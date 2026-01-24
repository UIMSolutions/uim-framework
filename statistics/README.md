# UIM Statistics

Streaming statistics library for D with vibe.d support. Provides fast, @safe streaming aggregators for mean/variance/stddev, histograms, quantiles, and sliding windows.

## Features

- Streaming stats via Welford (mean, variance, stddev, min, max)
- Online histogram with configurable bins
- Online quantile estimation (P2 algorithm)
- Sliding time-window aggregator
- Dataset and time-series helpers
- @safe throughout; vibe.d compatible

## Installation

Add to your `dub.sdl`:

```
dependency "uim-statistics" version="~master"
```

## Quick Start

```d
import uim.statistics;
import std.datetime : Clock, dur;

void main() {
    auto stats = new StreamingStats();
    stats.add(Sample(10, Clock.currTime()));
    stats.add(Sample(12, Clock.currTime()));
    stats.add(Sample(14, Clock.currTime()));

    writeln("mean=", stats.mean(), " stddev=", stats.stddev());

    auto hist = new Histogram();
    hist.configureBins(0, 100, 10);
    hist.add(Sample(42, Clock.currTime()));

    auto p2 = new P2Quantile(0.95);
    p2.add(Sample(10, Clock.currTime()));
    p2.add(Sample(20, Clock.currTime()));
    writeln("p95=", p2.quantile());

    auto window = new TimeWindowAggregator(5.dur!seconds);
    window.add(5, Clock.currTime());
    auto snap = window.snapshot();
    writeln("window mean=", snap.mean());
}
```

## Modules

- `uim.statistics.interfaces` - contracts (dataset, aggregator, histogram, quantile)
- `uim.statistics.core` - Dataset and TimeSeries
- `uim.statistics.streaming` - StreamingStats, Histogram, P2Quantile, TimeWindowAggregator

## Design

- Strategy pattern for aggregators
- Online algorithms for low memory and latency
- Sliding window recomputes stats after pruning for accuracy

## Testing

```
dub test
```
