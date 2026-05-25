/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.component;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimComponent - Interface for physical building components (IfcBuildingElement).
 * Covers structural and architectural elements such as walls, slabs, columns,
 * beams, doors, windows, and openings.
 */
interface IBimComponent : IBimElement {
  // #region placement
  /// X coordinate of the local origin in metres
  double posX();
  IBimComponent posX(double value);

  /// Y coordinate of the local origin in metres
  double posY();
  IBimComponent posY(double value);

  /// Z coordinate (elevation) of the local origin in metres
  double posZ();
  IBimComponent posZ(double value);

  /// Rotation around Z-axis in degrees
  double rotationZ();
  IBimComponent rotationZ(double value);
  // #endregion placement

  // #region material
  string materialId();
  IBimComponent materialId(string value);

  string[] layerMaterialIds();
  IBimComponent addLayerMaterialId(string id);
  IBimComponent removeLayerMaterialId(string id);
  // #endregion material

  // #region loadBearing
  bool isLoadBearing();
  IBimComponent isLoadBearing(bool value);

  bool isExternal();
  IBimComponent isExternal(bool value);
  // #endregion loadBearing
}
