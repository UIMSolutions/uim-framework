module uim.jsons.geo.classes.polygon;

import uim.jsons.geo;
@safe:

/**
 * Polygon geometry
 */
class GeoJsonPolygon : GeoJsonGeometry {
    protected PolygonCoordinates _coordinates;
    
    alias toJson = UIMObject.toJson;
    
    @property PolygonCoordinates coordinates() { return _coordinates; }
    @property void coordinates(PolygonCoordinates value) { _coordinates = value; }
    
    this() {
        super(GeometryType.Polygon);
    }
    
    this(PolygonCoordinates coords) {
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
            foreach (ring; json["coordinates"]) {
                Position[] ringCoords;
                foreach (pos; ring) {
                    Position position;
                    foreach (coord; pos) {
                        position ~= coord.get!double;
                    }
                    ringCoords ~= position;
                }
                _coordinates ~= ringCoords;
            }
        }
    }
}