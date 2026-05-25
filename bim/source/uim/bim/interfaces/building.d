/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.building;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimBuilding - Interface representing a building (IfcBuilding).
 * Buildings contain storeys and are grouped into sites.
 */
interface IBimBuilding : IBimElement {
  // #region address
  string buildingAddress();
  IBimBuilding buildingAddress(string value);

  string yearOfConstruction();
  IBimBuilding yearOfConstruction(string value);

  bool isLandmarked();
  IBimBuilding isLandmarked(bool value);
  // #endregion address

  // #region storeys
  string[] storeyIds();
  IBimBuilding addStoreyId(string id);
  IBimBuilding removeStoreyId(string id);
  // #endregion storeys

  // #region metrics
  /// Total gross floor area in m²
  double grossFloorArea();
  IBimBuilding grossFloorArea(double value);

  /// Total net floor area in m²
  double netFloorArea();
  IBimBuilding netFloorArea(double value);

  /// Total height of the building in metres
  double height();
  IBimBuilding height(double value);

  /// Number of above-ground storeys
  int numberOfStoreys();
  IBimBuilding numberOfStoreys(int value);
  // #endregion metrics
}
