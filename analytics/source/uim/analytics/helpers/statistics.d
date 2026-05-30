/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.analytics.helpers.statistics;

import std.algorithm.sorting : sort;
import std.math : sqrt;

@safe:

double analyticsSum(const(double)[] values) {
  double total = 0;
  foreach (value; values) {
    total += value;
  }
  return total;
}

double analyticsMean(const(double)[] values) {
  if (values.length == 0) {
    return 0;
  }

  return analyticsSum(values) / cast(double) values.length;
}

double analyticsMedian(const(double)[] values) {
  if (values.length == 0) {
    return 0;
  }

  auto copy = values.dup;
  sort(copy);

  auto middle = copy.length / 2;
  if ((copy.length % 2) == 1) {
    return copy[middle];
  }

  return (copy[middle - 1] + copy[middle]) / 2.0;
}

double analyticsStdDev(const(double)[] values) {
  if (values.length == 0) {
    return 0;
  }

  auto mean = analyticsMean(values);
  double variance = 0;

  foreach (value; values) {
    auto delta = value - mean;
    variance += delta * delta;
  }

  variance /= cast(double) values.length;
  return sqrt(variance);
}

double[] analyticsMovingAverage(const(double)[] values, size_t windowSize) {
  double[] result;

  if (values.length == 0 || windowSize == 0) {
    return result;
  }

  if (windowSize > values.length) {
    windowSize = values.length;
  }

  foreach (idx; 0 .. values.length - windowSize + 1) {
    auto chunk = values[idx .. idx + windowSize];
    result ~= analyticsMean(chunk);
  }

  return result;
}

double analyticsPearson(const(double)[] leftValues, const(double)[] rightValues) {
  if (leftValues.length == 0 || leftValues.length != rightValues.length) {
    return 0;
  }

  auto leftMean = analyticsMean(leftValues);
  auto rightMean = analyticsMean(rightValues);

  double numerator = 0;
  double leftVar = 0;
  double rightVar = 0;

  foreach (idx; 0 .. leftValues.length) {
    auto leftDelta = leftValues[idx] - leftMean;
    auto rightDelta = rightValues[idx] - rightMean;

    numerator += leftDelta * rightDelta;
    leftVar += leftDelta * leftDelta;
    rightVar += rightDelta * rightDelta;
  }

  auto denominator = sqrt(leftVar * rightVar);
  if (denominator == 0) {
    return 0;
  }

  return numerator / denominator;
}

unittest {
  double[] values = [1.0, 2.0, 3.0, 4.0];
  assert(analyticsSum(values) == 10.0);
  assert(analyticsMean(values) == 2.5);
  assert(analyticsMedian(values) == 2.5);

  auto moving = analyticsMovingAverage(values, 2);
  assert(moving.length == 3);
  assert(moving[0] == 1.5);

  auto corr = analyticsPearson([1.0, 2.0, 3.0], [2.0, 4.0, 6.0]);
  assert(corr > 0.99);
}
