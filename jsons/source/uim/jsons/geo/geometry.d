/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.geojson.geometry;

import uim.geojson;
import vibe.data.json;

@safe:

/**
 * Base class for all GeoJSON geometries
 */
abstract class DGeoJsonGeometry : UIMObject {
    protected GeometryType _geometryType;
    
    alias toJson = UIMObject.toJson;
    
    this() {
        super();
    }
    
    this(GeometryType type) {
        this();
        this._geometryType = type;
    }
    
    @property GeometryType geometryType() { return _geometryType; }
    @property void geometryType(GeometryType value) { _geometryType = value; }
    
    abstract Json toJson();
    abstract void fromJson(Json json);
}

/**
 * Point geometry
 */
class DGeoJsonPoint : DGeoJsonGeometry {
    protected PointCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property PointCoordinates coordinates() { return _coordinates; }
    @property void coordinates(PointCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.Point);
    }
    
    this(double longitude, double latitude) {
        this();
        this._coordinates = [longitude, latitude];
    }
    
    this(double longitude, double latitude, double altitude) {
        this();
        this._coordinates = [longitude, latitude, altitude];
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(_coordinates);
        return result;
    }
    
    override void fromJson(Json json) @trusted {
        if ("coordinates" in json) {
            _coordinates = [];
            foreach (coord; json["coordinates"]) {
                _coordinates ~= coord.get!double;
            }
        }
    }
}

/**
 * LineString geometry
 */
class DGeoJsonLineString : DGeoJsonGeometry {
    protected LineStringCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property LineStringCoordinates coordinates() { return _coordinates; }
    @property void coordinates(LineStringCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.LineString);
    }
    
    this(LineStringCoordinates coords) {
        this();
        this._coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(_coordinates);
        return result;
    }
    
    override void fromJson(Json json) @trusted {
        if ("coordinates" in json) {
            _coordinates = [];
            foreach (pos; json["coordinates"]) {
                Position position;
                foreach (coord; pos) {
                    position ~= coord.get!double;
                }
                _coordinates ~= position;
            }
        }
    }
}

/**
 * Polygon geometry
 */
class DGeoJsonPolygon : DGeoJsonGeometry {
    protected PolygonCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property PolygonCoordinates coordinates() { return _coordinates; }
    @property void coordinates(PolygonCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.Polygon);
    }
    
    this(PolygonCoordinates coords) {
        this();
        this._coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(_coordinates);
        return result;
    }
    
    override void fromJson(Json json) @trusted {
        if ("coordinates" in json) {
            _coordinates = [];
            foreach (ring; json["coordinates"]) {
                Position[] ringCoords;
                foreach (pos; ring) {
                    Position position;
                    foreach (coord; pos) {
                        position ~= coord.get!double;
                    }
                    ringCoords ~= position;
                }
                _coordinates ~= ringCoords;
            }
        }
    }
}

/**
 * MultiPoint geometry
 */
class DGeoJsonMultiPoint : DGeoJsonGeometry {
    protected MultiPointCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property MultiPointCoordinates coordinates() { return _coordinates; }
    @property void coordinates(MultiPointCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.MultiPoint);
    }
    
    this(MultiPointCoordinates coords) {
        this();
        this._coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(_coordinates);
        return result;
    }
    
    override void fromJson(Json json) @trusted {
        if ("coordinates" in json) {
            _coordinates = [];
            foreach (pos; json["coordinates"]) {
                Position position;
                foreach (coord; pos) {
                    position ~= coord.get!double;
                }
                _coordinates ~= position;
            }
        }
    }
}

/**
 * MultiLineString geometry
 */
class DGeoJsonMultiLineString : DGeoJsonGeometry {
    protected MultiLineStringCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property MultiLineStringCoordinates coordinates() { return _coordinates; }
    @property void coordinates(MultiLineStringCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.MultiLineString);
    }
    
    this(MultiLineStringCoordinates coords) {
        this();
        this._coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(_coordinates);
        return result;
    }
    
    override void fromJson(Json json) @trusted {
        if ("coordinates" in json) {
            _coordinates = [];
            foreach (lineString; json["coordinates"]) {
                Position[] line;
                foreach (pos; lineString) {
                    Position position;
                    foreach (coord; pos) {
                        position ~= coord.get!double;
                    }
                    line ~= position;
                }
                _coordinates ~= line;
            }
        }
    }
}

/**
 * MultiPolygon geometry
 */
class DGeoJsonMultiPolygon : DGeoJsonGeometry {
    protected MultiPolygonCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property MultiPolygonCoordinates coordinates() { return _coordinates; }
    @property void coordinates(MultiPolygonCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.MultiPolygon);
    }
    
    this(MultiPolygonCoordinates coords) {
        this();
        this._coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(_coordinates);
        return result;
    }
    
    override void fromJson(Json json) @trusted {
        if ("coordinates" in json) {
            _coordinates = [];
            foreach (polygon; json["coordinates"]) {
                Position[][] poly;
                foreach (ring; polygon) {
                    Position[] ringCoords;
                    foreach (pos; ring) {
                        Position position;
                        foreach (coord; pos) {
                            position ~= coord.get!double;
                        }
                        ringCoords ~= position;
                    }
                    poly ~= ringCoords;
                }
                _coordinates ~= poly;
            }
        }
    }
}

/**
 * GeometryCollection
 */
class DGeoJsonGeometryCollection : DGeoJsonGeometry {
    protected DGeoJsonGeometry[] _geometries;
    
    alias toJson = UIMObject.toJson;
    
    @property DGeoJsonGeometry[] geometries() { return _geometries; }
    @property void geometries(DGeoJsonGeometry[] value) { _geometries = value; }
    
    this() {
        super(GeometryType.GeometryCollection);
    }
    
    this(DGeoJsonGeometry[] geoms) {
        this();
        this._geometries = geoms;
    }
    
    override Json toJson() @trusted {
        auto result = Json.emptyObject;
        result["type"] = GeometryType.GeometryCollection.to!string;
        auto geomArray = Json.emptyArray;
        foreach (geom; _geometries) {
            geomArray ~= geom.toJson();
        }
        result["geometries"] = geomArray;
        return result;
    }
    
    override void fromJson(Json json) @trusted {
        if ("geometries" in json) {
            _geometries = [];
            foreach (geomJson; json["geometries"]) {
                auto geom = parseGeometry(geomJson);
                if (geom !is null) {
                    _geometries ~= geom;
                }
            }
        }
    }
}

/**
 * Parse a geometry from JSON
 */
DGeoJsonGeometry parseGeometry(Json json) @trusted {
    if ("type" !in json) return null;
    
    auto typeStr = json["type"].get!string;
    
    switch (typeStr) {
        case "Point":
            auto point = new DGeoJsonPoint();
            point.fromJson(json);
            return point;
        case "LineString":
            auto lineString = new DGeoJsonLineString();
            lineString.fromJson(json);
            return lineString;
        case "Polygon":
            auto polygon = new DGeoJsonPolygon();
            polygon.fromJson(json);
            return polygon;
        case "MultiPoint":
            auto multiPoint = new DGeoJsonMultiPoint();
            multiPoint.fromJson(json);
            return multiPoint;
        case "MultiLineString":
            auto multiLineString = new DGeoJsonMultiLineString();
            multiLineString.fromJson(json);
            return multiLineString;
        case "MultiPolygon":
            auto multiPolygon = new DGeoJsonMultiPolygon();
            multiPolygon.fromJson(json);
            return multiPolygon;
        case "GeometryCollection":
            auto collection = new DGeoJsonGeometryCollection();
            collection.fromJson(json);
            return collection;
        default:
            return null;
    }
}
