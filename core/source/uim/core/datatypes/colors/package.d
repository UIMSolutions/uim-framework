/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.colors;

import std.algorithm : clamp;
import std.array : appender;
import std.format : format;
import std.math : abs;
import std.string : startsWith;
import std.traits : isFloatingPoint;

@safe:

private enum bool isColorFloat(T) = isFloatingPoint!T;







private bool inUnitRange(T)(T value) pure nothrow if (isColorFloat!T) {
	return value >= cast(T) 0 && value <= cast(T) 1;
}

private T clamp01(T)(T value) pure nothrow if (isColorFloat!T) {
	return clamp(value, cast(T) 0, cast(T) 1);
}

private bool almostEqual(T)(T left, T right) pure nothrow if (isColorFloat!T) {
	return abs(left - right) <= cast(T) 1e-6;
}

private T max3(T)(T a, T b, T c) pure nothrow if (isColorFloat!T) {
	return a >= b ? (a >= c ? a : c) : (b >= c ? b : c);
}

private T min3(T)(T a, T b, T c) pure nothrow if (isColorFloat!T) {
	return a <= b ? (a <= c ? a : c) : (b <= c ? b : c);
}

private string normalizeHex(scope const string hex) {
	string value = hex.idup;
	if (value.startsWith("#")) {
		value = value[1 .. $];
	}

	if (value.length == 3 || value.length == 4) {
		auto builder = appender!string();
		foreach (ch; value) {
			builder.put(ch);
			builder.put(ch);
		}
		value = builder.data;
	}

	if (value.length != 6 && value.length != 8) {
		throw new Exception("Hex color must have 3, 4, 6, or 8 hex digits.");
	}

	foreach (ch; value) {
		const isDigit = ch >= '0' && ch <= '9';
		const isUpperHex = ch >= 'A' && ch <= 'F';
		const isLowerHex = ch >= 'a' && ch <= 'f';
		if (!(isDigit || isUpperHex || isLowerHex)) {
			throw new Exception("Hex color contains invalid characters.");
		}
	}

	return value;
}

private ubyte parseHexByte(scope const string twoHexDigits) pure nothrow {
	return cast(ubyte) ((hexValue(twoHexDigits[0]) << 4) | hexValue(twoHexDigits[1]));
}

private ubyte hexValue(char ch) pure nothrow {
	if (ch >= '0' && ch <= '9') {
		return cast(ubyte) (ch - '0');
	}
	if (ch >= 'A' && ch <= 'F') {
		return cast(ubyte) (10 + (ch - 'A'));
	}
	return cast(ubyte) (10 + (ch - 'a'));
}
