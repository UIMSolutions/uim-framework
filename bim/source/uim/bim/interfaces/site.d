module uim.bim.interfaces.site;

import uim.bim;

mixin(ShowModule!());

@safe:
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