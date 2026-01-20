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
abstract class DGeoJsonGeometry : DUIMObject {
    mixin(OProperty!("GeometryType", "geometryType"));
    
    this() {
        super();
    }
    
    this(GeometryType type) {
        this();
        this.geometryType(type);
    }
    
    abstract Json toJson();
    abstract void fromJson(Json json);
}

/**
 * Point geometry
 */
class DGeoJsonPoint : DGeoJsonGeometry {
    mixin(OProperty!("PointCoordinates", "coordinates"));
    
    this() {
        super(GeometryType.Point);
    }
    
    this(double longitude, double latitude) {
        this();
        this.coordinates = [longitude, latitude];
    }
    
    this(double longitude, double latitude, double altitude) {
        this();
        this.coordinates = [longitude, latitude, altitude];
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = Json(coordinates);
        return result;
    }
    
    override void fromJson(Json json) {
        if ("coordinates" in json) {
            coordinates = [];
            foreach (coord; json["coordinates"]) {
                coordinates ~= coord.get!double;
            }
        }
    }
}

/**
 * LineString geometry
 */
class DGeoJsonLineString : DGeoJsonGeometry {
    mixin(OProperty!("LineStringCoordinates", "coordinates"));
    
    this() {
        super(GeometryType.LineString);
    }
    
    this(LineStringCoordinates coords) {
        this();
        this.coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(coordinates);
        return result;
    }
    
    override void fromJson(Json json) {
        if ("coordinates" in json) {
            coordinates = [];
            foreach (pos; json["coordinates"]) {
                Position position;
                foreach (coord; pos) {
                    position ~= coord.get!double;
                }
                coordinates ~= position;
            }
        }
    }
}

/**
 * Polygon geometry
 */
class DGeoJsonPolygon : DGeoJsonGeometry {
    mixin(OProperty!("PolygonCoordinates", "coordinates"));
    
    this() {
        super(GeometryType.Polygon);
    }
    
    this(PolygonCoordinates coords) {
        this();
        this.coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(coordinates);
        return result;
    }
    
    override void fromJson(Json json) {
        if ("coordinates" in json) {
            coordinates = [];
            foreach (ring; json["coordinates"]) {
                Position[] ringCoords;
                foreach (pos; ring) {
                    Position position;
                    foreach (coord; pos) {
                        position ~= coord.get!double;
                    }
                    ringCoords ~= position;
                }
                coordinates ~= ringCoords;
            }
        }
    }
}

/**
 * MultiPoint geometry
 */
class DGeoJsonMultiPoint : DGeoJsonGeometry {
    mixin(OProperty!("MultiPointCoordinates", "coordinates"));
    
    this() {
        super(GeometryType.MultiPoint);
    }
    
    this(MultiPointCoordinates coords) {
        this();
        this.coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(coordinates);
        return result;
    }
    
    override void fromJson(Json json) {
        if ("coordinates" in json) {
            coordinates = [];
            foreach (pos; json["coordinates"]) {
                Position position;
                foreach (coord; pos) {
                    position ~= coord.get!double;
                }
                coordinates ~= position;
            }
        }
    }
}

/**
 * MultiLineString geometry
 */
class DGeoJsonMultiLineString : DGeoJsonGeometry {
    mixin(OProperty!("MultiLineStringCoordinates", "coordinates"));
    
    this() {
        super(GeometryType.MultiLineString);
    }
    
    this(MultiLineStringCoordinates coords) {
        this();
        this.coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(coordinates);
        return result;
    }
    
    override void fromJson(Json json) {
        if ("coordinates" in json) {
            coordinates = [];
            foreach (lineString; json["coordinates"]) {
                Position[] line;
                foreach (pos; lineString) {
                    Position position;
                    foreach (coord; pos) {
                        position ~= coord.get!double;
                    }
                    line ~= position;
                }
                coordinates ~= line;
            }
        }
    }
}

/**
 * MultiPolygon geometry
 */
class DGeoJsonMultiPolygon : DGeoJsonGeometry {
    mixin(OProperty!("MultiPolygonCoordinates", "coordinates"));
    
    this() {
        super(GeometryType.MultiPolygon);
    }
    
    this(MultiPolygonCoordinates coords) {
        this();
        this.coordinates = coords;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = geometryType.to!string;
        result["coordinates"] = serializeToJson(coordinates);
        return result;
    }
    
    override void fromJson(Json json) {
        if ("coordinates" in json) {
            coordinates = [];
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
                coordinates ~= poly;
            }
        }
    }
}

/**
 * GeometryCollection
 */
class DGeoJsonGeometryCollection : DGeoJsonGeometry {
    mixin(OProperty!("DGeoJsonGeometry[]", "geometries"));
    
    this() {
        super(GeometryType.GeometryCollection);
    }
    
    this(DGeoJsonGeometry[] geoms) {
        this();
        this.geometries = geoms;
    }
    
    override Json toJson() {
        auto result = Json.emptyObject;
        result["type"] = GeometryType.GeometryCollection.to!string;
        auto geomArray = Json.emptyArray;
        foreach (geom; geometries) {
            geomArray ~= geom.toJson();
        }
        result["geometries"] = geomArray;
        return result;
    }
    
    override void fromJson(Json json) {
        if ("geometries" in json) {
            geometries = [];
            foreach (geomJson; json["geometries"]) {
                auto geom = parseGeometry(geomJson);
                if (geom !is null) {
                    geometries ~= geom;
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
