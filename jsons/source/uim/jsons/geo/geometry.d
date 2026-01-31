/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.geo.geometry;

import uim.jsons;

mixin(ShowModule!());

@safe:














/**
 * Parse a geometry from Json
 */
GeoJsonGeometry parseGeometry(Json json) @trusted {
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
