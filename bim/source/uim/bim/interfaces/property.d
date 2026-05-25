/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.property;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimProperty - Interface for a single named property (IfcProperty).
 */
interface IBimProperty {
  string name();
  IBimProperty name(string value);

  string description();
  IBimProperty description(string value);

  /// Nominal/primary value encoded as Json
  Json value();
  IBimProperty value(Json v);

  /// Unit of measure (e.g. "m", "m2", "kg", "°C")
  string unit();
  IBimProperty unit(string value);

  Json toJson();
}

/**
 * IBimPropertySet - Interface for a named collection of properties (IfcPropertySet).
 */
interface IBimPropertySet {
  string name();
  IBimPropertySet name(string value);

  string description();
  IBimPropertySet description(string value);

  IBimProperty[string] properties();
  IBimPropertySet addProperty(IBimProperty prop);
  IBimPropertySet removeProperty(string propName);
  bool hasProperty(string propName);
  IBimProperty getProperty(string propName);

  Json toJson();
  IBimPropertySet fromJson(Json data);
}
