/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.geo.classes.geometry;

import uim.jsons.geo;
@safe:

/**
 * Base class for all GeoJson geometries
 */
abstract class GeoJsonGeometry : UIMObject {
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
    
    override abstract Json toJson();
    abstract void fromJson(Json json);
}
