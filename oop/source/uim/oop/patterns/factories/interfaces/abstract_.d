/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
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

