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
    
    abstract Json toJson();
    abstract void fromJson(Json json);
}
