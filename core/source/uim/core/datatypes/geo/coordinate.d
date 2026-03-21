module uim.core.datatypes.geo.coordinate;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  * Represents a geographic coordinate with latitude, longitude, and optional altitude.
  * Latitude is in degrees [-90, 90], longitude in degrees [-180, 180].
  * Provides methods for validation, distance calculation, bearing, and moving to a new coordinate.
  *
  * Example usage:
  * ```
  * auto coord1 = GeoCoordinateD(37.7749, -122.4194); // San Francisco
  * auto coord2 = GeoCoordinateD(34.0522, -118.2437); // Los Angeles
  * double distance = coord1.distanceTo(coord2); // Distance in meters
  * double bearing = coord1.initialBearingTo(coord2); // Initial bearing in degrees
  * auto movedCoord = coord1.moved(10000, 90); // Move 10 km east
  * ```
  */
struct GeoCoordinate(T = double) if (isGeoFloat!T) {
	T latitude;
	T longitude;
	T altitude;

	bool isValid() const pure nothrow {
		return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
	}

	double latitudeRadians() const pure nothrow {
		return cast(double) latitude * degToRad;
	}

	double longitudeRadians() const pure nothrow {
		return cast(double) longitude * degToRad;
	}

	/// Great-circle distance in meters using the Haversine formula.
	double distanceTo(const GeoCoordinate!T other, double radiusMeters = earthRadiusMeters) const pure {
		const lat1 = latitudeRadians();
		const lon1 = longitudeRadians();
		const lat2 = other.latitudeRadians();
		const lon2 = other.longitudeRadians();
		const dLat = lat2 - lat1;
		const dLon = lon2 - lon1;

		const a = sin(dLat / 2.0) * sin(dLat / 2.0)
			+ cos(lat1) * cos(lat2) * sin(dLon / 2.0) * sin(dLon / 2.0);
		const rootA = sqrt(a);
		const clampedRootA = rootA < 1.0 ? rootA : 1.0;
		const c = 2.0 * asin(clampedRootA);
		return radiusMeters * c;
	}

	/// Initial bearing in degrees [0, 360).
	double initialBearingTo(const GeoCoordinate!T other) const pure {
		const lat1 = latitudeRadians();
		const lat2 = other.latitudeRadians();
		const dLon = other.longitudeRadians() - longitudeRadians();

		const y = sin(dLon) * cos(lat2);
		const x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
		double bearing = atan2(y, x) * radToDeg;
		if (bearing < 0.0) {
			bearing += 360.0;
		}
		return bearing;
	}

	GeoCoordinate!T moved(double distanceMeters, double bearingDegrees,
		double radiusMeters = earthRadiusMeters) const pure {
		const angularDistance = distanceMeters / radiusMeters;
		const bearingRad = bearingDegrees * degToRad;
		const lat1 = latitudeRadians();
		const lon1 = longitudeRadians();

		const sinLat1 = sin(lat1);
		const cosLat1 = cos(lat1);
		const sinAd = sin(angularDistance);
		const cosAd = cos(angularDistance);
		const sinBr = sin(bearingRad);
		const cosBr = cos(bearingRad);

		const lat2 = asin(sinLat1 * cosAd + cosLat1 * sinAd * cosBr);
		const lon2 = lon1 + atan2(sinBr * sinAd * cosLat1, cosAd - sinLat1 * sin(lat2));

		auto normalizedLon = lon2 * radToDeg;
		while (normalizedLon > 180.0) {
			normalizedLon -= 360.0;
		}
		while (normalizedLon < -180.0) {
			normalizedLon += 360.0;
		}

		return GeoCoordinate!T(cast(T) (lat2 * radToDeg), cast(T) normalizedLon, altitude);
	}
}

alias GeoCoordinateF = GeoCoordinate!float;
alias GeoCoordinateD = GeoCoordinate!double;