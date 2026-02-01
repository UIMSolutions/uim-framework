/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
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
            auto point = new GeoJsonPoint();
            point.fromJson(json);
            return point;
        case "LineString":
            auto lineString = new GeoJsonLineString();
            lineString.fromJson(json);
            return lineString;
        case "Polygon":
            auto polygon = new GeoJsonPolygon();
            polygon.fromJson(json);
            return polygon;
        case "MultiPoint":
            auto multiPoint = new GeoJsonMultiPoint();
            multiPoint.fromJson(json);
            return multiPoint;
        case "MultiLineString":
            auto multiLineString = new GeoJsonMultiLineString();
            multiLineString.fromJson(json);
            return multiLineString;
        case "MultiPolygon":
            auto multiPolygon = new GeoJsonMultiPolygon();
            multiPolygon.fromJson(json);
            return multiPolygon;
        case "GeometryCollection":
            auto collection = new GeoJsonGeometryCollection();
            collection.fromJson(json);
            return collection;
        default:
            return null;
    }
}
