module uim.bim.interfaces.storey;

import uim.bim;

mixin(ShowModule!());

@safe:
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