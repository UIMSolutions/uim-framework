/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.units;

import uim.web;

mixin(ShowModule!());

@safe:

// #region length units
/// CSS pixel unit, e.g. px(12) -> "12px"
string px(int value) {
  return "%spx".format(value);
}

/// CSS pixel unit for fractional values, e.g. px(1.5) -> "1.5px"
string px(double value) {
  return "%spx".format(trimNumber(value));
}

/// CSS em unit (relative to the font-size of the parent element)
string em(double value) {
  return "%sem".format(trimNumber(value));
}

/// CSS rem unit (relative to the font-size of the root element)
string rem(double value) {
  return "%srem".format(trimNumber(value));
}

/// CSS percentage unit, e.g. percent(50) -> "50%"
string percent(int value) {
  return "%s%%".format(value);
}

/// CSS percentage unit for fractional values
string percent(double value) {
  return "%s%%".format(trimNumber(value));
}

/// CSS viewport height unit
string vh(int value) {
  return "%svh".format(value);
}

/// CSS viewport height unit for fractional values
string vh(double value) {
  return "%svh".format(trimNumber(value));
}

/// CSS viewport width unit
string vw(int value) {
  return "%svw".format(value);
}

/// CSS viewport width unit for fractional values
string vw(double value) {
  return "%svw".format(trimNumber(value));
}

/// CSS vmin unit (smaller of viewport width and height)
string vmin(int value) {
  return "%svmin".format(value);
}

/// CSS vmax unit (larger of viewport width and height)
string vmax(int value) {
  return "%svmax".format(value);
}

/// CSS dynamic viewport height unit, which follows collapsing browser toolbars
string dvh(double value) {
  return "%sdvh".format(trimNumber(value));
}

/// CSS small viewport height unit
string svh(double value) {
  return "%ssvh".format(trimNumber(value));
}

/// CSS large viewport height unit
string lvh(double value) {
  return "%slvh".format(trimNumber(value));
}

/// CSS container query width unit
string cqw(double value) {
  return "%scqw".format(trimNumber(value));
}

/// CSS container query height unit
string cqh(double value) {
  return "%scqh".format(trimNumber(value));
}

/// CSS ch unit (width of the "0" glyph of the current font)
string ch(int value) {
  return "%sch".format(value);
}

/// CSS ex unit (x-height of the current font)
string ex(int value) {
  return "%sex".format(value);
}

/// CSS centimeter unit
string cm(double value) {
  return "%scm".format(trimNumber(value));
}

/// CSS millimeter unit
string mm(double value) {
  return "%smm".format(trimNumber(value));
}

/// CSS point unit (1/72 of an inch)
string pt(double value) {
  return "%spt".format(trimNumber(value));
}

/// CSS pica unit (12 points)
string pc(double value) {
  return "%spc".format(trimNumber(value));
}

/// CSS inch unit
string inch(double value) {
  return "%sin".format(trimNumber(value));
}
// #endregion length units

// #region time units
/// CSS seconds unit, e.g. s(2) -> "2s"
string s(int value) {
  return "%ss".format(value);
}

/// CSS seconds unit for fractional values
string s(double value) {
  return "%ss".format(trimNumber(value));
}

/// CSS milliseconds unit, e.g. ms(250) -> "250ms"
string ms(int value) {
  return "%sms".format(value);
}
// #endregion time units

// #region angle units
/// CSS degree unit, e.g. deg(90) -> "90deg"
string deg(int value) {
  return "%sdeg".format(value);
}

/// CSS degree unit for fractional values
string deg(double value) {
  return "%sdeg".format(trimNumber(value));
}

/// CSS radian unit
string rad(double value) {
  return "%srad".format(trimNumber(value));
}

/// CSS gradian unit
string grad(int value) {
  return "%sgrad".format(value);
}

/// CSS turn unit, e.g. turn(0.5) -> "0.5turn"
string turn(double value) {
  return "%sturn".format(trimNumber(value));
}
// #endregion angle units

// #region grid units
/// CSS fraction unit for grid layouts, e.g. fr(2) -> "2fr"
string fr(int value) {
  return "%sfr".format(value);
}

/// CSS fraction unit for fractional values
string fr(double value) {
  return "%sfr".format(trimNumber(value));
}
// #endregion grid units

/// Formats a double without trailing zeros, e.g. trimNumber(1.50) -> "1.5"
string trimNumber(double value) {
  string result = "%.4f".format(value).stripRight("0").stripRight(".");
  return result == "-0" ? "0" : result;
}

/// Joins multiple values with a space, e.g. cssValues(px(1), "solid", "red")
string cssValues(string[] values...) {
  return values.filter!(v => v.length > 0).join(" ");
}

///
unittest {
  assert(px(12) == "12px");
  assert(px(1.5) == "1.5px");
  assert(em(1.25) == "1.25em");
  assert(rem(2) == "2rem");
  assert(percent(50) == "50%");
  assert(percent(33.3) == "33.3%");
  assert(vh(100) == "100vh");
  assert(vw(50) == "50vw");
  assert(vmin(10) == "10vmin");
  assert(vmax(90) == "90vmax");
  assert(ch(40) == "40ch");
  assert(ex(2) == "2ex");
  assert(cm(2.54) == "2.54cm");
  assert(mm(10) == "10mm");
  assert(pt(12) == "12pt");
  assert(pc(1) == "1pc");
  assert(inch(1) == "1in");
  assert(s(2) == "2s");
  assert(s(0.3) == "0.3s");
  assert(ms(250) == "250ms");
  assert(deg(90) == "90deg");
  assert(deg(45.5) == "45.5deg");
  assert(rad(3.1416) == "3.1416rad");
  assert(grad(100) == "100grad");
  assert(turn(0.5) == "0.5turn");
  assert(fr(2) == "2fr");
  assert(fr(1.5) == "1.5fr");
  assert(trimNumber(2.0) == "2");
  assert(trimNumber(2.50) == "2.5");
  assert(cssValues(px(1), "solid", "red") == "1px solid red");

  assert(trimNumber(100) == "100");
  assert(trimNumber(0) == "0");
  assert(trimNumber(-0.00001) == "0");
  assert(trimNumber(-1.5) == "-1.5");

  assert(vh(12.5) == "12.5vh");
  assert(vw(33.3) == "33.3vw");
  assert(dvh(100) == "100dvh");
  assert(svh(100) == "100svh");
  assert(lvh(100) == "100lvh");
  assert(cqw(50) == "50cqw");
  assert(cqh(50) == "50cqh");
}
