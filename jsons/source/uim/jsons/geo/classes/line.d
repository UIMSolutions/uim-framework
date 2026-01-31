module uim.jsons.geo.classes.line;

import uim.jsons.geo;
@safe:

/**
 * LineString geometry
 */
class GeoJsonLineString : GeoJsonGeometry {
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