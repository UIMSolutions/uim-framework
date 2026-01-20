module uim.bim.interfaces.spatial;

import uim.bim;

mixin(ShowModule!());

@safe:
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

  /**
   * Set the parent spatial element.
   */
  void parent(IBIMSpatialElement value);
}