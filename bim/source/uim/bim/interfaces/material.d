module uim.bim.interfaces.material;

import uim.bim;

mixin(ShowModule!());

@safe:
/**
 * Interface for materials.
 */
interface IBIMMaterial : IObject {
  string name();
  void name(string value);
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