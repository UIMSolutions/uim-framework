module uim.bim.interfaces.space;

import uim.bim;

mixin(ShowModule!());

@safe:
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