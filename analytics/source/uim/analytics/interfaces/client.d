/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.analytics.interfaces.client;

@safe:

enum AnalyticsEngine : ubyte {
  inMemory = 0,
  custom = 1
}

struct AnalyticsConfig {
  string profileName;
  AnalyticsEngine engine = AnalyticsEngine.inMemory;
  uint maxRows = 100_000;
  bool strictMode;
}

struct AnalyticsPoint {
  string metric;
  long timestamp;
  double value;
  string dimension;
}

struct AnalyticsSummary {
  bool success;
  string metric;
  ulong count;
  double min;
  double max;
  double mean;
  double median;
  double stdDev;
  double sum;
  string message;
}

struct AnalyticsCorrelation {
  bool success;
  string leftMetric;
  string rightMetric;
  double pearson;
  string message;
}

alias AnalyticsSummaryHandler = void delegate(AnalyticsSummary summary) @safe;
alias AnalyticsSeriesHandler = void delegate(double[] values) @safe;
alias AnalyticsCorrelationHandler = void delegate(AnalyticsCorrelation value) @safe;

alias AnalyticsSummaryDelegate = AnalyticsSummary delegate(
  AnalyticsConfig config,
  string metric,
  const(AnalyticsPoint)[] points
) @safe;

alias AnalyticsCorrelationDelegate = AnalyticsCorrelation delegate(
  AnalyticsConfig config,
  string leftMetric,
  string rightMetric,
  const(double)[] leftValues,
  const(double)[] rightValues
) @safe;

interface IAnalyticsService {
  bool configure(AnalyticsConfig config);
  AnalyticsConfig config() const;

  bool setSummaryProvider(AnalyticsSummaryDelegate provider);
  bool setCorrelationProvider(AnalyticsCorrelationDelegate provider);

  AnalyticsSummary summarize(string metric, const(AnalyticsPoint)[] points);
  double[] movingAverage(string metric, const(double)[] values, size_t windowSize = 5);
  AnalyticsCorrelation correlation(
    string leftMetric,
    string rightMetric,
    const(double)[] leftValues,
    const(double)[] rightValues
  );

  bool summarizeAsync(string metric, AnalyticsPoint[] points, AnalyticsSummaryHandler handler);
  bool movingAverageAsync(
    string metric,
    double[] values,
    size_t windowSize,
    AnalyticsSeriesHandler handler
  );

  AnalyticsPoint[] parseCsvSeries(string csvContent, string metric, char separator = ',');
}
