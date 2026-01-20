/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.elements.spatial;

import uim.bim;

@safe:

/**
 * Base class for spatial elements (hierarchical structure).
 */
abstract class DBIMSpatialElement : DBIMElement, IBIMSpatialElement {
  protected int _floorLevel;
  protected IBIMSpatialElement[] _children;
  protected IBIMSpatialElement _parent;

  this(string elementType) {
    super(elementType);
  }

  int floorLevel() {
    return _floorLevel;
  }

  void floorLevel(int level) {
    _floorLevel = level;
  }

  IBIMSpatialElement[] children() {
    return _children.dup;
  }

  void addChild(IBIMSpatialElement child) {
    if (child !is null) {
      _children ~= child;
    }
  }

  IBIMSpatialElement parent() {
    return _parent;
  }

  void parent(IBIMSpatialElement p) {
    _parent = p;
  }
}

/**
 * Building site element.
 */
class DBIMSite : DBIMSpatialElement, IBIMSite {
  protected string _address;
  protected double[2] _coordinates;
  protected double _siteArea;

  this() {
    super("Site");
  }

  string address() {
    return _address;
  }

  void address(string addr) {
    _address = addr;
  }

  double[2] coordinates() {
    return _coordinates;
  }

  void coordinates(double lat, double lon) {
    _coordinates = [lat, lon];
  }

  double siteArea() {
    return _siteArea;
  }

  void siteArea(double area) {
    _siteArea = area;
  }
}

/**
 * Building element.
 */
class DBIMBuilding : DBIMSpatialElement, IBIMBuilding {
  protected IBIMStorey[] _storeys;
  protected double _height;
  protected double _totalFloorArea;

  this() {
    super("Building");
  }

  IBIMStorey[] storeys() {
    return _storeys.dup;
  }

  void addStorey(IBIMStorey storey) {
    if (storey !is null) {
      _storeys ~= storey;
      storey.parent = this;
    }
  }

  double height() {
    return _height;
  }

  void height(double h) {
    _height = h;
  }

  double totalFloorArea() {
    return _totalFloorArea;
  }

  void totalFloorArea(double area) {
    _totalFloorArea = area;
  }
}

/**
 * Building storey/floor element.
 */
class DBIMStorey : DBIMSpatialElement, IBIMStorey {
  protected double _elevation;
  protected IBIMSpace[] _spaces;

  this() {
    super("Storey");
  }

  double elevation() {
    return _elevation;
  }

  void elevation(double elev) {
    _elevation = elev;
  }

  IBIMSpace[] spaces() {
    return _spaces.dup;
  }

  void addSpace(IBIMSpace space) {
    if (space !is null) {
      _spaces ~= space;
      space.parent = this;
    }
  }
}

/**
 * Space/room element.
 */
class DBIMSpace : DBIMSpatialElement, IBIMSpace {
  protected string _spaceType;
  protected double _area;
  protected double _volume;
  protected int _occupancy;

  this() {
    super("Space");
    _spaceType = "General";
  }

  string spaceType() {
    return _spaceType;
  }

  void spaceType(string type) {
    _spaceType = type;
  }

  double area() {
    return _area;
  }

  void area(double a) {
    _area = a;
  }

  double volume() {
    return _volume;
  }

  void volume(double v) {
    _volume = v;
  }

  int occupancy() {
    return _occupancy;
  }

  void occupancy(int occ) {
    _occupancy = occ;
  }
}

unittest {
  auto building = new DBIMBuilding();
  auto storey = new DBIMStorey();
  auto space = new DBIMSpace();
  
  building.addStorey(storey);
  storey.addSpace(space);
  
  assert(building.storeys.length == 1);
  assert(storey.spaces.length == 1);
}
