module uim.core.datatypes.colors.rgba8;

import uim.core;

mixin(ShowModule!());

@safe:
// struct RGBA8Color {
// 	ubyte r;
// 	ubyte g;
// 	ubyte b;
// 	ubyte a = 255;

// 	static RGBA8Color fromHex(scope const string hex) {
// 		auto value = normalizeHex(hex);

// 		if (value.length == 6) {
// 			return RGBA8Color(
// 				parseHexByte(value[0 .. 2]),
// 				parseHexByte(value[2 .. 4]),
// 				parseHexByte(value[4 .. 6]),
// 				255);
// 		}

// 		return RGBA8Color(
// 			parseHexByte(value[0 .. 2]),
// 			parseHexByte(value[2 .. 4]),
// 			parseHexByte(value[4 .. 6]),
// 			parseHexByte(value[6 .. 8]));
// 	}

// 	string toHexRGB() const {
// 		return format("#%02X%02X%02X", r, g, b);
// 	}

// 	string toHexRGBA() const {
// 		return format("#%02X%02X%02X%02X", r, g, b, a);
// 	}

// 	RGBAfColor toFloat() const pure nothrow {
// 		return RGBAfColor(r / 255.0f, g / 255.0f, b / 255.0f, a / 255.0f);
// 	}

// 	RGBA8Color premultiplied() const pure nothrow {
// 		const af = a / 255.0;
// 		return RGBA8Color(
// 			cast(ubyte) (r * af + 0.5),
// 			cast(ubyte) (g * af + 0.5),
// 			cast(ubyte) (b * af + 0.5),
// 			a);
// 	}

// 	RGBA8Color withAlpha(ubyte alpha) const pure nothrow {
// 		return RGBA8Color(r, g, b, alpha);
// 	}
// }