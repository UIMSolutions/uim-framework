/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.statistics;

import std.math;
import std.algorithm;
import std.array;
import std.numeric;
import uim.core;

/**
 * Collection of statistical functions
 */
class Statistics {

  /// Calculate sample mean
  static double mean(double[] values) pure {
    if (values.length == 0) return double.nan;
    return cast(double)sum(values) / values.length;
  }

  /// Calculate sample variance
  static double variance(double[] values) pure {
    if (values.length < 2) return double.nan;
    double m = mean(values);
    double sumSq = 0.0;
    foreach(v; values) {
      double diff = v - m;
      sumSq += diff * diff;
    }
    return sumSq / (values.length - 1);
  }

  /// Calculate sample standard deviation
  static double stddev(double[] values) pure {
    return sqrt(variance(values));
  }

  /// Calculate population variance
  static double populationVariance(double[] values) pure {
    if (values.length == 0) return double.nan;
    double m = mean(values);
    double sumSq = 0.0;
    foreach(v; values) {
      double diff = v - m;
      sumSq += diff * diff;
    }
    return sumSq / values.length;
  }

  /// Calculate covariance between two samples
  static double covariance(double[] x, double[] y) pure {
    assert(x.length == y.length);
    if (x.length < 2) return double.nan;

    double mean_x = mean(x);
    double mean_y = mean(y);
    double cov = 0.0;
    foreach(i; 0 .. x.length) {
      cov += (x[i] - mean_x) * (y[i] - mean_y);
    }
    return cov / (x.length - 1);
  }

  /// Calculate Pearson correlation coefficient
  static double correlation(double[] x, double[] y) pure {
    assert(x.length == y.length);
    double cov = covariance(x, y);
    double std_x = stddev(x);
    double std_y = stddev(y);
    if (std_x == 0.0 || std_y == 0.0) return double.nan;
    return cov / (std_x * std_y);
  }

  /// Calculate median
  static double median(double[] values) pure {
    if (values.length == 0) return double.nan;
    auto sorted = values.dup.sort();
    if (sorted.length % 2 == 0) {
      return (sorted[sorted.length/2 - 1] + sorted[sorted.length/2]) / 2.0;
    } else {
      return sorted[sorted.length/2];
    }
  }

  /// Calculate mode (most frequent value)
  static double mode(double[] values) pure {
    if (values.length == 0) return double.nan;
    
    size_t[double] counts;
    foreach(v; values) {
      counts[v]++;
    }

    double maxVal = 0;
    size_t maxCount = 0;
    foreach(v, count; counts) {
      if (count > maxCount) {
        maxCount = count;
        maxVal = v;
      }
    }
    return maxVal;
  }

  /// Calculate quantile
  static double quantile(double[] values, double q) pure {
    assert(q >= 0 && q <= 1, "Quantile must be between 0 and 1");
    if (values.length == 0) return double.nan;
    auto sorted = values.dup.sort();
    size_t idx = cast(size_t)(q * (sorted.length - 1));
    return sorted[idx];
  }

  /// Calculate skewness (Fisher-Pearson coefficient)
  static double skewness(double[] values) pure {
    if (values.length < 3) return double.nan;
    double m = mean(values);
    double sd = stddev(values);
    double skew = 0.0;
    foreach(v; values) {
      double diff = v - m;
      skew += (diff / sd) ^^ 3;
    }
    return skew / values.length;
  }

  /// Calculate excess kurtosis
  static double kurtosis(double[] values) pure {
    if (values.length < 4) return double.nan;
    double m = mean(values);
    double sd = stddev(values);
    double kurt = 0.0;
    foreach(v; values) {
      double diff = v - m;
      kurt += (diff / sd) ^^ 4;
    }
    return (kurt / values.length) - 3.0;
  }

  /// Standardize values (z-score normalization)
  static double[] standardize(double[] values) pure {
    double m = mean(values);
    double sd = stddev(values);
    double[] result = new double[values.length];
    foreach(i, v; values) {
      result[i] = (v - m) / sd;
    }
    return result;
  }

  /// Min-max normalization to [0, 1]
  static double[] normalize(double[] values) pure {
    if (values.length == 0) return [];
    double minVal = values.minElement;
    double maxVal = values.maxElement;
    double range = maxVal - minVal;
    
    if (range == 0.0) return new double[values.length];
    
    double[] result = new double[values.length];
    foreach(i, v; values) {
      result[i] = (v - minVal) / range;
    }
    return result;
  }

  /// Calculate sum of squared errors
  static double sumSquaredError(double[] actual, double[] predicted) pure {
    assert(actual.length == predicted.length);
    double sse = 0.0;
    foreach(i; 0 .. actual.length) {
      double diff = actual[i] - predicted[i];
      sse += diff * diff;
    }
    return sse;
  }

  /// Calculate R-squared (coefficient of determination)
  static double rSquared(double[] actual, double[] predicted) pure {
    assert(actual.length == predicted.length);
    double mean_actual = mean(actual);
    double ss_tot = 0.0;
    double ss_res = 0.0;
    
    foreach(i; 0 .. actual.length) {
      double tot = actual[i] - mean_actual;
      double res = actual[i] - predicted[i];
      ss_tot += tot * tot;
      ss_res += res * res;
    }

    if (ss_tot == 0.0) return double.nan;
    return 1.0 - (ss_res / ss_tot);
  }

  /// Calculate mean absolute error
  static double meanAbsoluteError(double[] actual, double[] predicted) pure {
    assert(actual.length == predicted.length);
    if (actual.length == 0) return double.nan;
    double mae = 0.0;
    foreach(i; 0 .. actual.length) {
      mae += abs(actual[i] - predicted[i]);
    }
    return mae / actual.length;
  }

  /// Calculate root mean squared error
  static double rootMeanSquaredError(double[] actual, double[] predicted) pure {
    return sqrt(sumSquaredError(actual, predicted) / actual.length);
  }

  private static double sum(double[] values) pure {
    double result = 0.0;
    foreach(v; values) result += v;
    return result;
  }
}
