module uim.core.helpers.geo;

import uim.core;
import std.math : PI;
import std.traits : isFloatingPoint;

mixin(ShowModule!());

@safe:

enum double degToRad = PI / 180.0;
enum double radToDeg = 180.0 / PI;

/// WGS84 mean Earth radius in meters.
enum double earthRadiusMeters = 6_371_008.8;

enum bool isGeoFloat(T) = isFloatingPoint!T;

