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
  * The <meter> HTML element represents either a scalar value within a known range or a fractional value. 
  * It is commonly used to display a measurement, such as disk usage, battery level, or any other value that can be represented as a fraction of a total.
  * The <meter> element includes attributes like value (the current value), min (the minimum value), max (the maximum value), low (the lower bound of the "low" range), high (the upper bound of the "high" range), and optimum (the optimal value).
  *
  * Example usage:
  * <meter value="0.6" min="0" max="1" low="0.3" high="0.8" optimum="0.5">60%</meter>
  */
class H5Meter : HtmlElement {
  mixin(HtmlTemplate!(H5Meter, "Meter", "meter", false));

  /// Sets the value attribute of the meter.
  H5Meter value(double val) {
    attribute("value", val.to!string);
    return this;
  }

    /// Gets the value attribute of the meter.
  H5Meter value() {
    attribute("value");
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
}
///
unittest {
  assert(H5Meter() == "<meter></meter>");

  auto meter = H5Meter().value(0.5).min(0).max(1);
  assert(meter.toString().indexOf(`value="0.5"`) > 0);
  assert(meter.toString().indexOf(`min="0"`) > 0);
  assert(meter.toString().indexOf(`max="1"`) > 0);
}
