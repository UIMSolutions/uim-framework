module uim.jsons.geo.classes.multiline;

import uim.jsons.geo;
@safe:

/**
 * MultiLineString geometry
 */
class GeoJsonMultiLineString : GeoJsonGeometry {
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