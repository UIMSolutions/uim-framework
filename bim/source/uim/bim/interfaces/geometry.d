module uim.bim.interfaces.geometry;

import uim.bim;

mixin(ShowModule!());

@safe:
/**
 * Interface for geometry representations.
 */
interface IBIMGeometry {
  string name();
  void name(string value);
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
