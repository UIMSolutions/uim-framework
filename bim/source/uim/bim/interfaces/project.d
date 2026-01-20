module uim.bim.interfaces.project;

import uim.bim;

mixin(ShowModule!());

@safe:
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