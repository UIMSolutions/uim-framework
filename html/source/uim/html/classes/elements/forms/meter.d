/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.meter;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <meter> element.
  * Provides methods to set meter attributes like value, min, max, low, high, and optimum.
  * Example usage:
  * auto meter = H5Meter().value(0.5).min(0).max(1);
  */

class H5Meter : HtmlElement {
  mixin H5This!("meter", false);

  /// Sets the value attribute of the meter.
  H5Meter value(double val) {
    attribute("value", val.to!string);
    return this;
  }

  /// Sets the min attribute of the meter.
  H5Meter min(double val) {
    attribute("min", val.to!string);
    return this;
  }

  /// Sets the max attribute of the meter.
  H5Meter max(double val) {
    attribute("max", val.to!string);
    return this;
  }

  /// Sets the low attribute of the meter.
  H5Meter low(double val) {
    attribute("low", val.to!string);
    return this;
  }

  /// Sets the high attribute of the meter.
  H5Meter high(double val) {
    attribute("high", val.to!string);
    return this;
  }

  /// Sets the optimum attribute of the meter.
  H5Meter optimum(double val) {
    attribute("optimum", val.to!string);
    return this;
  }

  mixin(H5Calls!("Meter"));
}
///
unittest {
  assert(H5Meter() == "<meter></meter>");

  auto meter = H5Meter().value(0.5).min(0).max(1);
  assert(meter.toString().indexOf(`value="0.5"`) > 0);
  assert(meter.toString().indexOf(`min="0"`) > 0);
  assert(meter.toString().indexOf(`max="1"`) > 0);
}
