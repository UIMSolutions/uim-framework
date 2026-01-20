/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.geo.types;

import uim.jsons.geo;

@safe:

/**
 * GeoJSON geometry types
 */
enum GeometryType : string {
    Point = "Point",
    MultiPoint = "MultiPoint",
    LineString = "LineString",
    MultiLineString = "MultiLineString",
    Polygon = "Polygon",
    MultiPolygon = "MultiPolygon",
    GeometryCollection = "GeometryCollection"
}

/**
 * GeoJSON object types
 */
enum GeoJsonType : string {
    Feature = "Feature",
    FeatureCollection = "FeatureCollection"
}

/**
 * Position type: [longitude, latitude] or [longitude, latitude, altitude]
 */
alias Position = double[];

/**
 * Coordinate types for different geometries
 */
alias PointCoordinates = Position;
alias MultiPointCoordinates = Position[];
alias LineStringCoordinates = Position[];
alias MultiLineStringCoordinates = Position[][];
alias PolygonCoordinates = Position[][];
alias MultiPolygonCoordinates = Position[][][];
