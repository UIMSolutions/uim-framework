/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.helpers.factory;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * BimFactory - Convenience factory for constructing BIM elements.
 * All methods return a freshly initialised instance ready for chaining.
 */
struct BimFactory {
@safe:
  static UIMBimSite site(string name = "") {
    return name.length ? new UIMBimSite(name) : new UIMBimSite();
  }

  static UIMBimBuilding building(string name = "") {
    return name.length ? new UIMBimBuilding(name) : new UIMBimBuilding();
  }

  static UIMBimStorey storey(string name = "", int storeyNumber = 0) {
    auto s = name.length ? new UIMBimStorey(name) : new UIMBimStorey();
    s.storeyNumber(storeyNumber);
    return s;
  }

  static UIMBimSpace space(string name = "") {
    return name.length ? new UIMBimSpace(name) : new UIMBimSpace();
  }

  static UIMBimWall wall(string name = "") {
    return name.length ? new UIMBimWall(name) : new UIMBimWall();
  }

  static UIMBimSlab slab(string name = "", string slabType = "FLOOR") {
    auto sl = name.length ? new UIMBimSlab(name) : new UIMBimSlab();
    sl.predefinedType(slabType);
    return sl;
  }

  static UIMBimColumn column(string name = "") {
    return name.length ? new UIMBimColumn(name) : new UIMBimColumn();
  }

  static UIMBimBeam beam(string name = "") {
    return name.length ? new UIMBimBeam(name) : new UIMBimBeam();
  }

  static UIMBimDoor door(string name = "") {
    return name.length ? new UIMBimDoor(name) : new UIMBimDoor();
  }

  static UIMBimWindow window(string name = "") {
    return name.length ? new UIMBimWindow(name) : new UIMBimWindow();
  }

  static UIMBimOpening opening(string name = "") {
    return name.length ? new UIMBimOpening(name) : new UIMBimOpening();
  }

  static UIMBimStair stair(string name = "") {
    return name.length ? new UIMBimStair(name) : new UIMBimStair();
  }

  static UIMBimRoof roof(string name = "") {
    return name.length ? new UIMBimRoof(name) : new UIMBimRoof();
  }

  static UIMBimMaterial material(string name = "") {
    return name.length ? new UIMBimMaterial(name) : new UIMBimMaterial();
  }

  static UIMBimPropertySet propertySet(string name = "") {
    return name.length ? new UIMBimPropertySet(name) : new UIMBimPropertySet();
  }

  static UIMBimProperty property(string name, Json value, string unit = "") {
    return new UIMBimProperty(name, value, unit);
  }

  static UIMBimClassification classification(string system, string code, string label) {
    return new UIMBimClassification(system, code, label);
  }
}
