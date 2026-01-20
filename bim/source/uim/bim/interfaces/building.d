module uim.bim.interfaces.building;

import uim.bim;

mixin(ShowModule!());

@safe:/**
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