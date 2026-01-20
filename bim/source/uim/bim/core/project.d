/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.core.project;

import uim.bim;

@safe:

/**
 * BIM project container class.
 */
class DBIMProject : UIMObject, IBIMProject {
  protected IBIMSite _site;
  protected IBIMBuilding[] _buildings;
  protected string _phase;
  protected Json[string] _metadata;

  this() {
    super();
    _phase = "Design";
  }

  this(string projectName) {
    this();
    this.name = projectName;
  }

  IBIMSite site() {
    return _site;
  }

  void site(IBIMSite s) {
    _site = s;
  }

  IBIMBuilding[] buildings() {
    return _buildings.dup;
  }

  void addBuilding(IBIMBuilding building) {
    if (building !is null) {
      _buildings ~= building;
    }
  }

  string phase() {
    return _phase;
  }

  void phase(string p) {
    _phase = p;
  }

  Json[string] metadata() {
    return _metadata.dup;
  }

  void setMetadata(string key, Json value) {
    _metadata[key] = value;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (auto phase = "phase" in initData) {
      _phase = phase.get!string;
    }

    return true;
  }
}

unittest {
  auto project = new DBIMProject("Office Building Project");
  assert(project !is null);
  assert(project.name == "Office Building Project");
  assert(project.phase == "Design");
}
