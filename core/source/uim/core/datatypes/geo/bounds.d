module uim.core.datatypes.geo.bounds;

import uim.core;

mixin(ShowModule!());

@safe:

struct GeoBounds(T = double) if (isGeoFloat!T) {
	T minLatitude;
	T minLongitude;
	T maxLatitude;
	T maxLongitude;

	bool isValid() const pure nothrow {
		return minLatitude >= -90 && maxLatitude <= 90
			&& minLatitude <= maxLatitude
			&& minLongitude >= -180 && minLongitude <= 180
			&& maxLongitude >= -180 && maxLongitude <= 180;
	}

	bool crossesAntimeridian() const pure nothrow {
		return minLongitude > maxLongitude;
	}

	bool contains(const GeoCoordinate!T point) const pure nothrow {
		if (!isValid() || !point.isValid()) {
			return false;
		}

		if (point.latitude < minLatitude || point.latitude > maxLatitude) {
			return false;
		}

		if (!crossesAntimeridian()) {
			return point.longitude >= minLongitude && point.longitude <= maxLongitude;
		}

		return point.longitude >= minLongitude || point.longitude <= maxLongitude;
	}

	GeoCoordinate!T center() const pure nothrow {
		const centerLat = (cast(double) minLatitude + cast(double) maxLatitude) / 2.0;
		double centerLon;
		if (!crossesAntimeridian()) {
			centerLon = (cast(double) minLongitude + cast(double) maxLongitude) / 2.0;
		} else {
			const wrappedMax = cast(double) maxLongitude + 360.0;
			centerLon = (cast(double) minLongitude + wrappedMax) / 2.0;
			if (centerLon > 180.0) {
				centerLon -= 360.0;
			}
		}

		return GeoCoordinate!T(cast(T) centerLat, cast(T) centerLon, 0);
	}
}

alias GeoBoundsF = GeoBounds!float;
alias GeoBoundsD = GeoBounds!double;