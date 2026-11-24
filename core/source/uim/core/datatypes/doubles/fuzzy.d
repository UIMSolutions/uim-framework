/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.doubles.fuzzy;

import uim.core;

import std.math : isNaN;
import std.traits : isFloatingPoint, isIntegral, isNumeric;

mixin(ShowModule!());

@safe:

/// Floating point type used for fuzzy degrees of `T` (`T` itself for floating point types, otherwise `double`).
template FuzzyType(T) if (isNumeric!T) {
  static if (isFloatingPoint!T)
    alias FuzzyType = T;
  else
    alias FuzzyType = double;
}

// #region fuzzy
/**
  * Map a fuzzy degree from [minFuzzy, maxFuzzy] onto the value range [minValue, maxValue].
  * Degrees outside the fuzzy range are clamped. Integral results are rounded to the nearest value.
  *
  * Example: `fuzzy(0.5, 10, 20) == 15`
  */
T fuzzy(T)(double fuzzyValue, T minValue, T maxValue, double minFuzzy = 0, double maxFuzzy = 1) pure nothrow @nogc
if (isNumeric!T)
in {
  assert(minValue < maxValue, "fuzzy(): minValue must be less than maxValue");
  assert(minFuzzy < maxFuzzy, "fuzzy(): minFuzzy must be less than maxFuzzy");
}
do {
  if (fuzzyValue <= minFuzzy) {
    return minValue;
  }
  if (fuzzyValue >= maxFuzzy) {
    return maxValue;
  }

  const pos = (fuzzyValue - minFuzzy) / (maxFuzzy - minFuzzy);
  static if (isIntegral!T) {
    const offset = pos * (cast(double)maxValue - minValue); // >= 0, since pos in (0, 1)
    return cast(T)(minValue + cast(long)(offset + 0.5)); // round half up
  } else {
    return cast(T)(minValue + pos * (maxValue - minValue));
  }
}
///
unittest {
  mixin(ShowTest!"Testing fuzzy");

  assert(fuzzy(0, 0, 1) == 0);
  assert(fuzzy(1, 0, 1) == 1);

  assert(fuzzy(0, 10, 20) == 10);
  assert(fuzzy(.5, 10, 20) == 15);
  assert(fuzzy(1, 10, 20) == 20);

  assert(fuzzy(0, 1, 2) == 1);
  assert(fuzzy(2, 0, 1) == 1);
  assert(fuzzy(-1, 0, 1) == 0);
  assert(fuzzy(0.5, 0.0, 1.0) == 0.5);

  // integral results are rounded instead of throwing on inexact conversion
  assert(fuzzy(0.3, 0, 10) == 3);
  assert(fuzzy(0.26, 0, 10) == 3);
  assert(fuzzy(0.5, ubyte(0), ubyte(255)) == 128);

  // custom fuzzy range
  assert(fuzzy(50, 0.0, 1.0, 0, 100) == 0.5);
}

/**
  * Map a value from [minValue, maxValue] onto a fuzzy degree in [minFuzzy, maxFuzzy].
  * Values outside the value range are clamped. Integral inputs are computed in floating point.
  *
  * Example: `toFuzzy(15, 10, 20) == 0.5`
  */
FuzzyType!T toFuzzy(T)(T value, T minValue, T maxValue, double minFuzzy = 0, double maxFuzzy = 1) pure nothrow @nogc
if (isNumeric!T)
in {
  assert(minValue < maxValue, "toFuzzy(): minValue must be less than maxValue");
  assert(minFuzzy < maxFuzzy, "toFuzzy(): minFuzzy must be less than maxFuzzy");
}
do {
  alias F = FuzzyType!T;

  if (value <= minValue) {
    return cast(F)minFuzzy;
  }
  if (value >= maxValue) {
    return cast(F)maxFuzzy;
  }

  const pos = (cast(F)value - minValue) / (cast(F)maxValue - minValue);
  return cast(F)(minFuzzy + pos * (maxFuzzy - minFuzzy));
}
///
unittest {
  mixin(ShowTest!"Testing toFuzzy");

  assert(toFuzzy(0.5, 0.0, 1.0) == 0.5);
  assert(toFuzzy(-1.0, 0.0, 1.0) == 0);
  assert(toFuzzy(2.0, 0.0, 1.0) == 1);

  // integral inputs no longer suffer from integer division
  assert(toFuzzy(15, 10, 20) == 0.5);
  assert(toFuzzy(5, 10, 20) == 0);
  assert(toFuzzy(25, 10, 20) == 1);
  assert(toFuzzy(15, 10, 20, 0, 100) == 50);

  // roundtrip
  assert(fuzzy(toFuzzy(15, 10, 20), 10, 20) == 15);
}
// #endregion fuzzy

// #region degree helpers
/// Clamp a fuzzy degree to [0, 1]. NaN is treated as 0.
T clampFuzzy(T)(T degree) pure nothrow @nogc if (isFloatingPoint!T) {
  if (isNaN(degree) || degree <= 0)
    return 0;
  return degree >= 1 ? 1 : degree;
}
///
unittest {
  mixin(ShowTest!"Testing clampFuzzy");

  assert(clampFuzzy(-0.5) == 0);
  assert(clampFuzzy(0.25) == 0.25);
  assert(clampFuzzy(1.5) == 1);
  assert(clampFuzzy(double.nan) == 0);
}

/// Check whether a value is a valid fuzzy degree in [0, 1].
bool isFuzzy(T)(T degree) pure nothrow @nogc if (isNumeric!T) {
  return degree >= 0 && degree <= 1;
}
///
unittest {
  mixin(ShowTest!"Testing isFuzzy");

  assert(isFuzzy(0) && isFuzzy(1) && isFuzzy(0.5));
  assert(!isFuzzy(-0.1) && !isFuzzy(1.1) && !isFuzzy(double.nan));
}
// #endregion degree helpers

// #region fuzzy logic (Zadeh operators)
/// Fuzzy AND (minimum of all degrees).
T fuzzyAnd(T)(T first, T[] others...) pure nothrow @nogc if (isFloatingPoint!T) {
  T result = first;
  foreach (degree; others)
    if (degree < result)
      result = degree;
  return result;
}
///
unittest {
  mixin(ShowTest!"Testing fuzzy AND and OR");

  assert(fuzzyAnd(0.3, 0.7) == 0.3);
  assert(fuzzyAnd(0.3, 0.7, 0.1) == 0.1);
}

/// Fuzzy OR (maximum of all degrees).
T fuzzyOr(T)(T first, T[] others...) pure nothrow @nogc if (isFloatingPoint!T) {
  T result = first;
  foreach (degree; others)
    if (degree > result)
      result = degree;
  return result;
}
///
unittest {
  mixin(ShowTest!"Testing fuzzy AND and OR");

  assert(fuzzyOr(0.3, 0.7) == 0.7);
  assert(fuzzyOr(0.3, 0.7, 0.9) == 0.9);
}

/// Fuzzy NOT (complement: 1 - degree).
T fuzzyNot(T)(T degree) pure nothrow @nogc if (isFloatingPoint!T) {
  return 1 - degree;
}
///
unittest {
  mixin(ShowTest!"Testing fuzzy logic operators");

  assert(fuzzyNot(0.25) == 0.75);
  assert(fuzzyAnd(0.4) == 0.4);
}
// #endregion fuzzy logic

// #region membership functions
/**
  * Triangular membership: 0 at `left`, rising to 1 at `peak`, falling to 0 at `right`.
  * `left == peak` or `peak == right` give a shoulder.
  */
double triangularMembership(double value, double left, double peak, double right) pure nothrow @nogc
in {
  assert(left <= peak && peak <= right, "triangularMembership(): requires left <= peak <= right");
}
do {
  if (value == peak)
    return 1;
  if (value <= left || value >= right)
    return 0;
  return value < peak
    ? (value - left) / (peak - left)
    : (right - value) / (right - peak);
}
///
unittest {
  mixin(ShowTest!"Testing triangularMembership");

  assert(triangularMembership(0, 0, 5, 10) == 0);
  assert(triangularMembership(2.5, 0, 5, 10) == 0.5);
  assert(triangularMembership(5, 0, 5, 10) == 1);
  assert(triangularMembership(7.5, 0, 5, 10) == 0.5);
  assert(triangularMembership(11, 0, 5, 10) == 0);
  assert(triangularMembership(0, 0, 0, 10) == 1); // left shoulder
}

/**
  * Trapezoidal membership: 0 below `left`, rising to 1 on [`leftTop`, `rightTop`], falling to 0 at `right`.
  */
double trapezoidalMembership(double value, double left, double leftTop, double rightTop, double right)
pure nothrow @nogc
in {
  assert(left <= leftTop && leftTop <= rightTop && rightTop <= right,
    "trapezoidalMembership(): requires left <= leftTop <= rightTop <= right");
}
do {
  if (value >= leftTop && value <= rightTop)
    return 1;
  if (value <= left || value >= right)
    return 0;
  return value < leftTop
    ? (value - left) / (leftTop - left)
    : (right - value) / (right - rightTop);
}
///
unittest {
  mixin(ShowTest!"Testing trapezoidalMembership");

  assert(trapezoidalMembership(0, 0, 2, 8, 10) == 0);
  assert(trapezoidalMembership(1, 0, 2, 8, 10) == 0.5);
  assert(trapezoidalMembership(5, 0, 2, 8, 10) == 1);
  assert(trapezoidalMembership(9, 0, 2, 8, 10) == 0.5);
  assert(trapezoidalMembership(10, 0, 2, 8, 10) == 0);
  assert(trapezoidalMembership(-5, 0, 0, 8, 10) == 0);
  assert(trapezoidalMembership(0, 0, 0, 8, 10) == 1); // left shoulder
}
// #endregion membership functions
