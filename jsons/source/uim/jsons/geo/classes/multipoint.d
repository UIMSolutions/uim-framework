module uim.jsons.geo.classes.multipoint;

import uim.jsons.geo;
@safe:

/**
 * MultiPoint geometry
 */
class GeoJsonMultiPoint : GeoJsonGeometry {
    protected MultiPointCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property MultiPointCoordinates coordinates() { return _coordinates; }
    @property void coordinates(MultiPointCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.MultiPoint);
    }
    
    this(MultiPointCoordinates coords) {
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
