/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.geo.helpers.collection;

import uim.jsons.geo;
@safe:
/**
 * GeometryCollection
 */
class GeoJsonGeometryCollection : GeoJsonGeometry {
    protected GeoJsonGeometry[] _geometries;
    
    alias toJson = UIMObject.toJson;
    
    @property GeoJsonGeometry[] geometries() { return _geometries; }
    @property void geometries(GeoJsonGeometry[] value) { _geometries = value; }
    
    this() {
        super(GeometryType.GeometryCollection);
    }
    
    this(GeoJsonGeometry[] geoms) {
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
