/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.storey;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimStorey - Interface representing a building storey/floor (IfcBuildingStorey).
 * A storey is a horizontal section of a building at a defined elevation.
 */
interface IBimStorey : IBimElement {
  // #region elevation
  /// Absolute elevation of the storey floor level in metres
  double elevation();
  IBimStorey elevation(double value);

  /// Floor-to-floor height in metres
  double floorHeight();
  IBimStorey floorHeight(double value);

  /// Floor-to-ceiling height in metres (clear height)
  double netHeight();
  IBimStorey netHeight(double value);

  /// Storey number (negative for basement)
  int storeyNumber();
  IBimStorey storeyNumber(int value);
  // #endregion elevation

  // #region spaces
  string[] spaceIds();
  IBimStorey addSpaceId(string id);
  IBimStorey removeSpaceId(string id);
  // #endregion spaces

  // #region components
  string[] componentIds();
  IBimStorey addComponentId(string id);
  IBimStorey removeComponentId(string id);
  // #endregion components

  // #region metrics
  /// Gross floor area in m²
  double grossArea();
  IBimStorey grossArea(double value);

  /// Net floor area in m²
  double netArea();
  IBimStorey netArea(double value);
  // #endregion metrics
}
