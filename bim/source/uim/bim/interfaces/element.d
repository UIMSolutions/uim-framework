module uim.bim.interfaces.element;

import uim.bim;

mixin(ShowModule!());

@safe:
/**
 * Base interface for all BIM elements.
 */
interface IBIMElement : IObject {
  string name();
  void name(string value);

  /**
   * Get the globally unique identifier (GUID).
   */
  string guid();

  /**
   * Set the globally unique identifier.
   */
  void guid(string value);

  /**
   * Get the element type classification.
   */
  string elementType();

  /**
   * Get all properties of this element.
   */
  IBIMProperty[] properties();

  /**
   * Add a property to this element.
   */
  void addProperty(IBIMProperty property);

  /**
   * Get a property by name.
   */
  IBIMProperty getProperty(string name);

  /**
   * Get the geometry representation.
   */
  IBIMGeometry geometry();

  /**
   * Set the geometry representation.
   */
  void geometry(IBIMGeometry geom);
}