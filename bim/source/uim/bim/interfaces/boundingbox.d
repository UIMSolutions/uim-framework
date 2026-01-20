/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.interfaces.boundingbox;

import uim.bim;

@safe:











/**
 * Bounding box structure.
 */
struct BoundingBox {
  double minX, minY, minZ;
  double maxX, maxY, maxZ;

  double width() const {
    return maxX - minX;
  }

  double depth() const {
    return maxY - minY;
  }

  double height() const {
    return maxZ - minZ;
  }
}
