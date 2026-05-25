/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.site;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimSite - Interface representing a construction site (IfcSite).
 * A site is the outermost spatial container in the BIM hierarchy:
 * Site -> Building -> Storey -> Space.
 */
interface IBimSite : IBimElement {
  // #region location
  /// WGS84 latitude in decimal degrees
  double latitude();
  IBimSite latitude(double value);

  /// WGS84 longitude in decimal degrees
  double longitude();
  IBimSite longitude(double value);

  /// Elevation above sea level in metres
  double elevation();
  IBimSite elevation(double value);

  string landTitleNumber();
  IBimSite landTitleNumber(string value);

  string siteAddress();
  IBimSite siteAddress(string value);
  // #endregion location

  // #region buildings
  string[] buildingIds();
  IBimSite addBuildingId(string id);
  IBimSite removeBuildingId(string id);
  // #endregion buildings
}
