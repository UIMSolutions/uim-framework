/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.series;

import std.traits;
import std.algorithm;
import std.array;
import std.math;
import std.numeric;
import uim.core;

/**
 * A one-dimensional labeled array, similar to a pandas Series
 */
class Series(T) if (isNumeric!T || is(T == string)) {
  private {
    T[] _values;
    string[] _index;
  }

  /// Create a series from values
  this(T[] values, string[] index = []) {
    _values = values.dup;
    if (index.length > 0) {
      assert(index.length == values.length, "Index length must match values length");
      _index = index.dup;
    } else {
      _index = new string[values.length];
      foreach(i; 0 .. values.length) {
        _index[i] = i.to!string;
      }
    }
  }

  /// Get values
  @property T[] values() const { return _values.dup; }

  /// Get index
  @property string[] index() const { return _index.dup; }

  /// Get length
  @property size_t length() const { return _values.length; }

  /// Access value at index
  T opIndex(size_t i) const {
    assert(i < _values.length);
    return _values[i];
  }

  /// Set value at index
  void opIndexAssign(T value, size_t i) {
    assert(i < _values.length);
    _values[i] = value;
  }

  /// Get value by label
  T get(string label) const {
    auto idx = _index.countUntil(label);
    assert(idx >= 0, "Label not found: " ~ label);
    return _values[idx];
  }

  // Statistical methods
  
  /// Calculate mean
  static if (isNumeric!T) {
    double mean() const {
      if (_values.length == 0) return double.nan;
      return cast(double)sum(_values) / _values.length;
    }

    /// Calculate standard deviation
    double stddev() const {
      if (_values.length < 2) return double.nan;
      double m = mean();
      double sumSq = 0.0;
      foreach(v; _values) {
        double diff = v - m;
        sumSq += diff * diff;
      }
      return sqrt(sumSq / (_values.length - 1));
    }

    /// Calculate variance
    double variance() const {
      double sd = stddev();
      return sd * sd;
    }

    /// Get minimum value
    T min() const {
      assert(_values.length > 0);
      return _values[].minElement();
    }

    /// Get maximum value
    T max() const {
      assert(_values.length > 0);
      return _values[].maxElement();
    }

    /// Calculate sum
    T sum() const {
      T result = 0;
      foreach(v; _values) result += v;
      return result;
    }

    /// Calculate median
    double median() const {
      if (_values.length == 0) return double.nan;
      auto sorted = _values.dup.sort;
      if (sorted.length % 2 == 0) {
        return (sorted[sorted.length/2 - 1] + sorted[sorted.length/2]) / 2.0;
      } else {
        return sorted[sorted.length/2];
      }
    }

    /// Calculate quantile
    double quantile(double q) const {
      assert(q >= 0 && q <= 1, "Quantile must be between 0 and 1");
      if (_values.length == 0) return double.nan;
      auto sorted = _values.dup.sort;
      size_t idx = cast(size_t)(q * (sorted.length - 1));
      return sorted[idx];
    }
  }

  /// Get slice of series
  Series!T opSlice(size_t start, size_t end) const {
    return new Series!T(_values[start..end], _index[start..end]);
  }

  /// Filter series by condition
  Series!T filter(bool delegate(T) predicate) const {
    T[] newValues;
    string[] newIndex;
    foreach(i, v; _values) {
      if (predicate(v)) {
        newValues ~= v;
        newIndex ~= _index[i];
      }
    }
    return new Series!T(newValues, newIndex);
  }

  /// Map series values
  Series!U map(U)(U delegate(T) fn) const {
    U[] newValues;
    foreach(v; _values) {
      newValues ~= fn(v);
    }
    return new Series!U(newValues, _index.dup);
  }

  /// Apply function to each value
  void apply(void delegate(T) fn) {
    foreach(ref v; _values) {
      fn(v);
    }
  }

  /// Fill missing values
  static if (isNumeric!T) {
    void fillNaN(T fillValue) {
      foreach(ref v; _values) {
        if (isNaN(v)) v = fillValue;
      }
    }
  }

  /// Get descriptive statistics
  static if (isNumeric!T) {
    struct DescriptiveStats {
      T count;
      double mean;
      double stddev;
      T min;
      double q25;
      double median;
      double q75;
      T max;
    }

    DescriptiveStats describe() const {
      return DescriptiveStats(
        cast(T)_values.length,
        this.mean(),
        this.stddev(),
        this.min(),
        this.quantile(0.25),
        this.median(),
        this.quantile(0.75),
        this.max()
      );
    }
  }

  /// Convert to string for debugging
  override string toString() const {
    return "Series[" ~ _values.length.to!string ~ "]";
  }
}
