# Library uim-analytics

Updated on 30. May 2026

uim-analytics is a lightweight D library to work with data analytics workflows using vibe.d runtime patterns. It provides CSV ingestion, descriptive statistics, moving averages, correlation analysis, and asynchronous execution hooks.

## Features

- Typed analytics contracts (`IAnalyticsService`)
- Service configuration model with in-memory and custom engine modes
- CSV parser helper for timestamp/value/dimension data
- Statistical helpers: sum, mean, median, standard deviation, Pearson correlation
- Synchronous APIs for summary, moving average, and correlation workflows
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating external analytics engines

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:analytics" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.analytics;

void main() {
  auto service = AnalyticsService();

  AnalyticsConfig cfg;
  cfg.profileName = "default";
  cfg.maxRows = 100_000;

  assert(service.configure(cfg));

  auto points = service.parseCsvSeries("timestamp,value\n1,10\n2,25\n3,30\n", "sales");
  auto summary = service.summarize("sales", points);

  writeln("mean=", summary.mean, " stddev=", summary.stdDev);

  auto ma = service.movingAverage("sales", [10.0, 25.0, 30.0, 45.0], 2);
  writeln("movingAveragePoints=", ma.length);

  service.summarizeAsync("sales", points, (AnalyticsSummary s) @safe {
    writeln("async count=", s.count);
  });
}
```

## Modules

- `uim.analytics`: package entrypoint and re-exports
- `uim.analytics.interfaces`: contracts, DTOs, config, and delegate types
- `uim.analytics.models`: result helper constructors
- `uim.analytics.helpers`: CSV parser and statistics helper functions
- `uim.analytics.service`: orchestration and async APIs

## Notes

- Default execution is in-memory for fast integration and testing.
- For production usage, inject external providers via `setSummaryProvider` and `setCorrelationProvider`.
