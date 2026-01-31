module uim.jsons.geo.classes.point;

import uim.jsons.geo;
@safe:
/**
 * Point geometry
 */
class GeoJsonPoint : GeoJsonGeometry {
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
