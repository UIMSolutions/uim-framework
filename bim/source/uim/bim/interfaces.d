/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.interfaces;

import uim.bim;

@safe:

/**
 * Base interface for all BIM elements.
 */
interface IBIMElement : IObject {
  /**
   * Get the globally unique identifier (GUID).
   */
  string guid();

  /**
   * Set the globally unique identifier.
   */
  void guid(string value);

  /**
   * Get the element type classification.
   */
  string elementType();

  /**
   * Get all properties of this element.
   */
  IBIMProperty[] properties();

  /**
   * Add a property to this element.
   */
  void addProperty(IBIMProperty property);

  /**
   * Get a property by name.
   */
  IBIMProperty getProperty(string name);

  /**
   * Get the geometry representation.
   */
  IBIMGeometry geometry();

  /**
   * Set the geometry representation.
   */
  void geometry(IBIMGeometry geom);
}

/**
 * Interface for BIM properties.
 */
interface IBIMProperty : IObject {
  /**
   * Get the property value.
   */
  Json value();

  /**
   * Set the property value.
   */
  void value(Json val);

  /**
   * Get the property unit.
   */
  string unit();

  /**
   * Get the property data type.
   */
  string dataType();
}

/**
 * Interface for geometry representations.
 */
interface IBIMGeometry {
  /**
   * Get the geometry type (e.g., "Box", "Cylinder", "Mesh").
   */
  string geometryType();

  /**
   * Get the bounding box dimensions.
   */
  BoundingBox boundingBox();

  /**
   * Calculate the volume.
   */
  double volume();

  /**
   * Calculate the surface area.
   */
  double surfaceArea();
}

/**
 * Interface for materials.
 */
interface IBIMMaterial : IObject {
  /**
   * Get material properties.
   */
  Json[string] materialProperties();

  /**
   * Get thermal conductivity.
   */
  double thermalConductivity();

  /**
   * Get density.
   */
  double density();

  /**
   * Get cost per unit.
   */
  double costPerUnit();
}

/**
 * Interface for spatial elements (spaces, zones, buildings).
 */
interface IBIMSpatialElement : IBIMElement {
  /**
   * Get the floor level.
   */
  int floorLevel();

  /**
   * Get child spatial elements.
   */
  IBIMSpatialElement[] children();

  /**
   * Add a child spatial element.
   */
  void addChild(IBIMSpatialElement child);

  /**
   * Get the parent spatial element.
   */
  IBIMSpatialElement parent();
}

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

  double width() const { return maxX - minX; }
  double depth() const { return maxY - minY; }
  double height() const { return maxZ - minZ; }
}
