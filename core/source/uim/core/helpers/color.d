module uim.core.helpers.color;

import uim.core;

mixin(ShowModule!());

@safe:

 enum bool isColorFloat(T) = isFloatingPoint!T;

 bool inUnitRange(T)(T value) pure nothrow if (isColorFloat!T) {
	return value >= cast(T) 0 && value <= cast(T) 1;
}

 T clamp01(T)(T value) pure nothrow if (isColorFloat!T) {
	return clamp(value, cast(T) 0, cast(T) 1);
}

 bool almostEqual(T)(T left, T right) pure nothrow if (isColorFloat!T) {
	return abs(left - right) <= cast(T) 1e-6;
}

 T max3(T)(T a, T b, T c) pure nothrow if (isColorFloat!T) {
	return a >= b ? (a >= c ? a : c) : (b >= c ? b : c);
}

 T min3(T)(T a, T b, T c) pure nothrow if (isColorFloat!T) {
	return a <= b ? (a <= c ? a : c) : (b <= c ? b : c);
}

 string normalizeHex(scope const string hex) {
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

 ubyte parseHexByte(scope const string twoHexDigits) pure nothrow {
	return cast(ubyte) ((hexValue(twoHexDigits[0]) << 4) | hexValue(twoHexDigits[1]));
}

 ubyte hexValue(char ch) pure nothrow {
	if (ch >= '0' && ch <= '9') {
		return cast(ubyte) (ch - '0');
	}
	if (ch >= 'A' && ch <= 'F') {
		return cast(ubyte) (10 + (ch - 'A'));
	}
	return cast(ubyte) (10 + (ch - 'a'));
}
