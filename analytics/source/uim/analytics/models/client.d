/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.analytics.models.client;

import uim.analytics;

mixin(ShowModule!());

@safe:

AnalyticsSummary AnalyticsSummaryOk(string metric, ulong count) {
  AnalyticsSummary value;
  value.success = true;
  value.metric = metric;
  value.count = count;
  value.message = "ok";
  return value;
}

AnalyticsSummary AnalyticsSummaryErr(string metric, string message) {
  AnalyticsSummary value;
  value.success = false;
  value.metric = metric;
  value.message = message;
  return value;
}

AnalyticsCorrelation AnalyticsCorrelationOk(
  string leftMetric,
  string rightMetric,
  double pearson
) {
  AnalyticsCorrelation value;
  value.success = true;
  value.leftMetric = leftMetric;
  value.rightMetric = rightMetric;
  value.pearson = pearson;
  value.message = "ok";
  return value;
}

AnalyticsCorrelation AnalyticsCorrelationErr(
  string leftMetric,
  string rightMetric,
  string message
) {
  AnalyticsCorrelation value;
  value.success = false;
  value.leftMetric = leftMetric;
  value.rightMetric = rightMetric;
  value.message = message;
  return value;
}

unittest {
  auto summary = AnalyticsSummaryOk("latency", 10);
  assert(summary.success);
  assert(summary.count == 10);

  auto corr = AnalyticsCorrelationOk("x", "y", 0.7);
  assert(corr.success);
  assert(corr.pearson > 0.0);
}
