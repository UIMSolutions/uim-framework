/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.dataframe;

import std.traits;
import std.algorithm;
import std.array;
import std.associative;
import uim.core;
import uim.datascience.series;

/**
 * A two-dimensional labeled data structure, similar to a pandas DataFrame
 */
class DataFrame {
  private {
    Series!double[string] _columns;
    string[] _columnNames;
    string[] _index;
    size_t _nrows;
  }

  /// Create an empty DataFrame
  this() {
    _nrows = 0;
  }

  /// Create DataFrame from columns
  this(Series!double[string] columns) {
    if (columns.length > 0) {
      _nrows = columns.values().front.length;
      foreach(k, v; columns) {
        assert(v.length == _nrows, "All columns must have same length");
        _columns[k] = v;
        _columnNames ~= k;
      }
      // Create default numeric index
      _index = new string[_nrows];
      foreach(i; 0 .. _nrows) {
        _index[i] = i.to!string;
      }
    }
  }

  /// Add a column
  void addColumn(string name, Series!double series) {
    if (_nrows == 0) {
      _nrows = series.length;
      _index = new string[_nrows];
      foreach(i; 0 .. _nrows) {
        _index[i] = i.to!string;
      }
    }
    assert(series.length == _nrows, "Column length must match DataFrame rows");
    _columns[name] = series;
    if (!_columnNames.canFind(name)) {
      _columnNames ~= name;
    }
  }

  /// Get column by name
  Series!double opIndex(string columnName) const {
    assert(columnName in _columns, "Column not found: " ~ columnName);
    return _columns[columnName];
  }

  /// Get number of rows
  @property size_t nrows() const { return _nrows; }

  /// Get number of columns
  @property size_t ncols() const { return _columns.length; }

  /// Get column names
  @property string[] columnNames() const { return _columnNames.dup; }

  /// Get index (row names)
  @property string[] index() const { return _index.dup; }

  /// Select columns
  DataFrame select(string[] columnNames) const {
    DataFrame df = new DataFrame();
    df._nrows = _nrows;
    df._index = _index.dup;
    foreach(name; columnNames) {
      assert(name in _columns, "Column not found: " ~ name);
      df._columns[name] = _columns[name];
      df._columnNames ~= name;
    }
    return df;
  }

  /// Get descriptive statistics for all numeric columns
  void describe() const {
    writeln("Shape: (", _nrows, ", ", _columns.length, ")");
    writeln("\nColumn Statistics:");
    foreach(name; _columnNames) {
      auto col = _columns[name];
      auto stats = col.describe();
      writeln("\n", name, ":");
      writeln("  count: ", stats.count);
      writeln("  mean:  ", stats.mean);
      writeln("  std:   ", stats.stddev);
      writeln("  min:   ", stats.min);
      writeln("  25%:   ", stats.q25);
      writeln("  50%:   ", stats.median);
      writeln("  75%:   ", stats.q75);
      writeln("  max:   ", stats.max);
    }
  }

  /// Filter rows by condition on a column
  DataFrame filterByColumn(string columnName, bool delegate(double) predicate) const {
    auto col = _columns[columnName];
    size_t[] indices;
    foreach(i; 0 .. _nrows) {
      if (predicate(col[i])) {
        indices ~= i;
      }
    }

    DataFrame result = new DataFrame();
    result._nrows = indices.length;
    result._index = new string[indices.length];
    foreach(i, idx; indices) {
      result._index[i] = _index[idx];
    }

    foreach(name; _columnNames) {
      auto col_data = _columns[name].values;
      double[] newCol;
      foreach(idx; indices) {
        newCol ~= col_data[idx];
      }
      result.addColumn(name, new Series!double(newCol));
    }

    return result;
  }

  /// Get row as array
  double[] getRow(size_t idx) const {
    assert(idx < _nrows);
    double[] row;
    foreach(name; _columnNames) {
      row ~= _columns[name][idx];
    }
    return row;
  }

  /// Calculate correlation matrix
  double[][] correlationMatrix() const {
    size_t n = _columnNames.length;
    double[][] corr = new double[][](n, n);

    foreach(i; 0 .. n) {
      foreach(j; 0 .. n) {
        if (i == j) {
          corr[i][j] = 1.0;
        } else if (j > i) {
          double cov = covariance(
            _columns[_columnNames[i]].values,
            _columns[_columnNames[j]].values
          );
          double std_i = _columns[_columnNames[i]].stddev();
          double std_j = _columns[_columnNames[j]].stddev();
          corr[i][j] = cov / (std_i * std_j);
        } else {
          corr[i][j] = corr[j][i];
        }
      }
    }

    return corr;
  }

  /// Calculate head - first n rows
  DataFrame head(size_t n = 5) const {
    DataFrame result = new DataFrame();
    size_t nrows = n < _nrows ? n : _nrows;
    result._nrows = nrows;
    result._index = _index[0 .. nrows].dup;

    foreach(name; _columnNames) {
      auto col = _columns[name].values;
      result.addColumn(name, new Series!double(col[0 .. nrows]));
    }

    return result;
  }

  /// Calculate tail - last n rows
  DataFrame tail(size_t n = 5) const {
    DataFrame result = new DataFrame();
    size_t start = _nrows > n ? _nrows - n : 0;
    result._nrows = _nrows - start;
    result._index = _index[start .. $].dup;

    foreach(name; _columnNames) {
      auto col = _columns[name].values;
      result.addColumn(name, new Series!double(col[start .. $]));
    }

    return result;
  }

  private static double covariance(double[] x, double[] y) pure {
    assert(x.length == y.length);
    if (x.length == 0) return double.nan;

    double mean_x = 0.0, mean_y = 0.0;
    foreach(i; 0 .. x.length) {
      mean_x += x[i];
      mean_y += y[i];
    }
    mean_x /= x.length;
    mean_y /= y.length;

    double cov = 0.0;
    foreach(i; 0 .. x.length) {
      cov += (x[i] - mean_x) * (y[i] - mean_y);
    }
    return cov / (x.length - 1);
  }

  /// Convert to string
  override string toString() const {
    return "DataFrame(" ~ _nrows.to!string ~ " x " ~ _columns.length.to!string ~ ")";
  }
}
