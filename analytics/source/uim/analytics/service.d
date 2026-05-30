/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.analytics.service;

import vibe.d : runTask;

import uim.analytics;

mixin(ShowModule!());

@safe:

class UIMAnalyticsService : UIMObject, IAnalyticsService {
  private AnalyticsConfig _config;
  private bool _configured;

  private AnalyticsSummaryDelegate _summaryProvider;
  private AnalyticsCorrelationDelegate _correlationProvider;

  bool configure(AnalyticsConfig config) {
    if (config.maxRows == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  AnalyticsConfig config() const {
    return _config;
  }

  bool setSummaryProvider(AnalyticsSummaryDelegate provider) {
    _summaryProvider = provider;
    return true;
  }

  bool setCorrelationProvider(AnalyticsCorrelationDelegate provider) {
    _correlationProvider = provider;
    return true;
  }

  AnalyticsSummary summarize(string metric, const(AnalyticsPoint)[] points) {
    if (!_configured) {
      return AnalyticsSummaryErr(metric, "Analytics service is not configured.");
    }

    if (metric.length == 0) {
      return AnalyticsSummaryErr(metric, "metric is required");
    }

    if (_summaryProvider !is null) {
      try {
        return _summaryProvider(_config, metric, points);
      } catch (Exception ex) {
        return AnalyticsSummaryErr(metric, ex.msg);
      }
    }

    double[] values;
    foreach (point; points) {
      if (point.metric == metric) {
        values ~= point.value;
      }
    }

    if (values.length == 0) {
      return AnalyticsSummaryErr(metric, "no datapoints for metric");
    }

    auto summary = AnalyticsSummaryOk(metric, cast(ulong) values.length);
    summary.sum = analyticsSum(values);
    summary.mean = analyticsMean(values);
    summary.median = analyticsMedian(values);
    summary.stdDev = analyticsStdDev(values);
    summary.min = values[0];
    summary.max = values[0];

    foreach (value; values) {
      if (value < summary.min) {
        summary.min = value;
      }

      if (value > summary.max) {
        summary.max = value;
      }
    }

    return summary;
  }

  double[] movingAverage(string metric, const(double)[] values, size_t windowSize = 5) {
    if (!_configured || metric.length == 0) {
      return [];
    }

    return analyticsMovingAverage(values, windowSize);
  }

  AnalyticsCorrelation correlation(
    string leftMetric,
    string rightMetric,
    const(double)[] leftValues,
    const(double)[] rightValues
  ) {
    if (!_configured) {
      return AnalyticsCorrelationErr(
        leftMetric,
        rightMetric,
        "Analytics service is not configured."
      );
    }

    if (leftMetric.length == 0 || rightMetric.length == 0) {
      return AnalyticsCorrelationErr(leftMetric, rightMetric, "metrics are required");
    }

    if (_correlationProvider !is null) {
      try {
        return _correlationProvider(_config, leftMetric, rightMetric, leftValues, rightValues);
      } catch (Exception ex) {
        return AnalyticsCorrelationErr(leftMetric, rightMetric, ex.msg);
      }
    }

    if (leftValues.length == 0 || leftValues.length != rightValues.length) {
      return AnalyticsCorrelationErr(
        leftMetric,
        rightMetric,
        "value series must have same non-zero length"
      );
    }

    auto pearson = analyticsPearson(leftValues, rightValues);
    return AnalyticsCorrelationOk(leftMetric, rightMetric, pearson);
  }

  bool summarizeAsync(string metric, AnalyticsPoint[] points, AnalyticsSummaryHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localMetric = metric;
    auto localPoints = points;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(summarize(localMetric, localPoints));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool movingAverageAsync(
    string metric,
    double[] values,
    size_t windowSize,
    AnalyticsSeriesHandler handler
  ) {
    if (handler is null) {
      return false;
    }

    auto localMetric = metric;
    auto localValues = values;
    auto localWindowSize = windowSize;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(movingAverage(localMetric, localValues, localWindowSize));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  AnalyticsPoint[] parseCsvSeries(string csvContent, string metric, char separator = ',') {
    return analyticsParseCsvSeries(csvContent, metric, separator);
  }
}

IAnalyticsService AnalyticsService() {
  return new UIMAnalyticsService();
}

unittest {
  auto service = AnalyticsService();

  AnalyticsConfig cfg;
  cfg.profileName = "default";
  cfg.maxRows = 1000;
  assert(service.configure(cfg));

  auto points = service.parseCsvSeries("timestamp,value\n1,10\n2,20\n3,30\n", "sales");
  assert(points.length == 3);

  auto summary = service.summarize("sales", points);
  assert(summary.success);
  assert(summary.count == 3);
  assert(summary.mean == 20);

  auto series = service.movingAverage("sales", [10.0, 20.0, 30.0, 40.0], 2);
  assert(series.length == 3);

  auto corr = service.correlation("x", "y", [1.0, 2.0, 3.0], [2.0, 4.0, 6.0]);
  assert(corr.success);
}
