module uim.bim.interfaces.property;

import uim.bim;

mixin(ShowModule!());

@safe:
/**
 * Interface for BIM properties.
 */
interface IBIMProperty : IObject {
  string name();
  void name(string value);
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