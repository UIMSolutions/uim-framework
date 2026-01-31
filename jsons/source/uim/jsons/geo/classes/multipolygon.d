module uim.jsons.geo.classes.multipolygon;

import uim.jsons.geo;
@safe:
/**
 * MultiPolygon geometry
 */
class GeoJsonMultiPolygon : GeoJsonGeometry {
    protected MultiPolygonCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property MultiPolygonCoordinates coordinates() { return _coordinates; }
    @property void coordinates(MultiPolygonCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.MultiPolygon);
    }
    
    this(MultiPolygonCoordinates coords) {
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
            foreach (polygon; json["coordinates"]) {
                Position[][] poly;
                foreach (ring; polygon) {
                    Position[] ringCoords;
                    foreach (pos; ring) {
                        Position position;
                        foreach (coord; pos) {
                            position ~= coord.get!double;
                        }
                        ringCoords ~= position;
                    }
                    poly ~= ringCoords;
                }
                _coordinates ~= poly;
            }
        }
    }
}