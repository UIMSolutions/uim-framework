module uim.bim.interfaces.buildingelement;

import uim.bim;

mixin(ShowModule!());

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