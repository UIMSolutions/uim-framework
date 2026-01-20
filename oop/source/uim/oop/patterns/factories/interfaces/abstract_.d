module uim.oop.patterns.factories.interfaces.abstract_;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Abstract factory interface for creating families of related objects.
 */
interface IAbstractFactory {
  Object createProduct(string productType);
}

