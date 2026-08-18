module uim.core.datatypes.colors.rgba;

import uim.core;

mixin(ShowModule!());

@safe:

// struct RGBAColor(T = float) if (isColorFloat!T) {
// 	T r;
// 	T g;
// 	T b;
// 	T a = cast(T) 1;

// 	bool isValid() const pure nothrow {
// 		return inUnitRange(r) && inUnitRange(g) && inUnitRange(b) && inUnitRange(a);
// 	}

// 	RGBAColor!T clamped() const pure nothrow {
// 		return RGBAColor!T(clamp01(r), clamp01(g), clamp01(b), clamp01(a));
// 	}

// 	RGBA8Color to8Bit() const pure nothrow {
// 		const c = clamped();
// 		return RGBA8Color(
// 			cast(ubyte) (c.r * 255 + 0.5),
// 			cast(ubyte) (c.g * 255 + 0.5),
// 			cast(ubyte) (c.b * 255 + 0.5),
// 			cast(ubyte) (c.a * 255 + 0.5));
// 	}

// 	HSVAColor!T toHSVA() const pure nothrow {
// 		const c = clamped();
// 		const maxChannel = max3(c.r, c.g, c.b);
// 		const minChannel = min3(c.r, c.g, c.b);
// 		const delta = maxChannel - minChannel;

// 		T hue = 0;
// 		if (delta > cast(T) 0) {
// 			if (almostEqual(maxChannel, c.r)) {
// 				hue = cast(T) (60.0 * ((c.g - c.b) / delta));
// 			} else if (almostEqual(maxChannel, c.g)) {
// 				hue = cast(T) (60.0 * (((c.b - c.r) / delta) + 2.0));
// 			} else {
// 				hue = cast(T) (60.0 * (((c.r - c.g) / delta) + 4.0));
// 			}
// 			if (hue < cast(T) 0) {
// 				hue += cast(T) 360;
// 			}
// 		}

// 		const sat = maxChannel <= cast(T) 0 ? cast(T) 0 : delta / maxChannel;
// 		const val = maxChannel;
// 		return HSVAColor!T(hue, sat, val, c.a);
// 	}

// 	RGBAColor!T alphaBlendOver(const RGBAColor!T background) const pure nothrow {
// 		const fg = clamped();
// 		const bg = background.clamped();
// 		const outA = fg.a + bg.a * (cast(T) 1 - fg.a);
// 		if (outA <= cast(T) 0) {
// 			return RGBAColor!T(0, 0, 0, 0);
// 		}

// 		const outR = (fg.r * fg.a + bg.r * bg.a * (cast(T) 1 - fg.a)) / outA;
// 		const outG = (fg.g * fg.a + bg.g * bg.a * (cast(T) 1 - fg.a)) / outA;
// 		const outB = (fg.b * fg.a + bg.b * bg.a * (cast(T) 1 - fg.a)) / outA;
// 		return RGBAColor!T(outR, outG, outB, outA);
// 	}
// }

// alias RGBAfColor = RGBAColor!float;
// alias RGBAdColor = RGBAColor!double;