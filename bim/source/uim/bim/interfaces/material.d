/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.material;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimMaterial - Interface for material definitions (IfcMaterial).
 */
interface IBimMaterial {
  string globalId();
  IBimMaterial globalId(string value);

  string name();
  IBimMaterial name(string value);

  string description();
  IBimMaterial description(string value);

  string category();
  IBimMaterial category(string value);

  /// Density in kg/m³
  double density();
  IBimMaterial density(double value);

  /// Thermal conductivity W/(m·K)
  double thermalConductivity();
  IBimMaterial thermalConductivity(double value);

  /// Specific heat capacity J/(kg·K)
  double specificHeat();
  IBimMaterial specificHeat(double value);

  /// Colour in hex notation (#RRGGBB)
  string colour();
  IBimMaterial colour(string value);

  Json[string] properties();
  IBimMaterial setProperty(string key, Json value);

  Json toJson();
  IBimMaterial fromJson(Json data);
}
