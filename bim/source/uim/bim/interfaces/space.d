/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.space;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimSpace - Interface representing a spatial zone or room (IfcSpace).
 * A space defines a bounded volume with a specific function (e.g. office, corridor).
 */
interface IBimSpace : IBimElement {
  // #region identity
  string spaceNumber();
  IBimSpace spaceNumber(string value);

  /// Predefined type: SPACE, PARKING, GFA, INTERNAL, EXTERNAL
  string predefinedType();
  IBimSpace predefinedType(string value);

  string longName();
  IBimSpace longName(string value);
  // #endregion identity

  // #region metrics
  /// Gross floor area in m²
  double grossFloorArea();
  IBimSpace grossFloorArea(double value);

  /// Net floor area in m²
  double netFloorArea();
  IBimSpace netFloorArea(double value);

  /// Clear height of the space in metres
  double netHeight();
  IBimSpace netHeight(double value);

  /// Gross volume in m³
  double grossVolume();
  IBimSpace grossVolume(double value);

  /// Net volume in m³
  double netVolume();
  IBimSpace netVolume(double value);
  // #endregion metrics

  // #region components
  string[] componentIds();
  IBimSpace addComponentId(string id);
  IBimSpace removeComponentId(string id);
  // #endregion components
}
