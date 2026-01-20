/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.interfaces.interfaces;

import uim.bim;

@safe:










/**
 * Interface for building elements (walls, doors, windows, etc.).
 */
interface IBIMBuildingElement : IBIMElement {
  /**
   * Get the material composition.
   */
  IBIMMaterial[] materials();

  /**
   * Add a material layer.
   */
  void addMaterial(IBIMMaterial material, double thickness);

  /**
   * Get load-bearing status.
   */
  bool isLoadBearing();

  /**
   * Get fire resistance rating.
   */
  string fireResistance();
}

/**
 * Interface for BIM project.
 */
interface IBIMProject : IObject {
  string name();
  void name(string value);
  /**
   * Get project site.
   */
  IBIMSite site();

  /**
   * Get all buildings in the project.
   */
  IBIMBuilding[] buildings();

  /**
   * Add a building to the project.
   */
  void addBuilding(IBIMBuilding building);

  /**
   * Get project phase.
   */
  string phase();

  /**
   * Get project metadata.
   */
  Json[string] metadata();
}

/**
 * Interface for BIM site.
 */
interface IBIMSite : IBIMSpatialElement {
  /**
   * Get site address.
   */
  string address();

  /**
   * Get site coordinates (latitude, longitude).
   */
  double[2] coordinates();

  /**
   * Get site area in square meters.
   */
  double siteArea();
}

/**
 * Interface for BIM building.
 */
interface IBIMBuilding : IBIMSpatialElement {
  /**
   * Get building storeys.
   */
  IBIMStorey[] storeys();

  /**
   * Add a storey to the building.
   */
  void addStorey(IBIMStorey storey);

  /**
   * Get total building height.
   */
  double height();

  /**
   * Get total floor area.
   */
  double totalFloorArea();
}

/**
 * Interface for building storey/floor.
 */
interface IBIMStorey : IBIMSpatialElement {
  /**
   * Get storey elevation.
   */
  double elevation();

  /**
   * Get spaces in this storey.
   */
  IBIMSpace[] spaces();

  /**
   * Add a space to this storey.
   */
  void addSpace(IBIMSpace space);
}

/**
 * Interface for spaces/rooms.
 */
interface IBIMSpace : IBIMSpatialElement {
  /**
   * Get space function/usage type.
   */
  string spaceType();

  /**
   * Get floor area.
   */
  double area();

  /**
   * Get volume.
   */
  double volume();

  /**
   * Get occupancy capacity.
   */
  int occupancy();
}

/**
 * Bounding box structure.
 */
struct BoundingBox {
  double minX, minY, minZ;
  double maxX, maxY, maxZ;

  double width() const {
    return maxX - minX;
  }

  double depth() const {
    return maxY - minY;
  }

  double height() const {
    return maxZ - minZ;
  }
}
