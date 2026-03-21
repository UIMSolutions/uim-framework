module uim.core.datatypes.geo.circle;

import uim.core;

mixin(ShowModule!());

@safe:

struct GeoCircle(T = double) if (isGeoFloat!T) {
	GeoCoordinate!T center;
	double radiusMeters;

	bool isValid() const pure nothrow {
		return center.isValid() && radiusMeters >= 0.0;
	}

	bool contains(const GeoCoordinate!T point, double radius = earthRadiusMeters) const pure {
		if (!isValid() || !point.isValid()) {
			return false;
		}
		return center.distanceTo(point, radius) <= radiusMeters;
	}
}

alias GeoCircleF = GeoCircle!float;
alias GeoCircleD = GeoCircle!double;
