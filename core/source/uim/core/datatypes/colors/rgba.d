module uim.core.datatypes.colors.rgba;

import uim.core;

mixin(ShowModule!());

@safe:

struct ColorRGBA(T = float) if (isColorFloat!T) {
	T r;
	T g;
	T b;
	T a = cast(T) 1;

	bool isValid() const pure nothrow {
		return inUnitRange(r) && inUnitRange(g) && inUnitRange(b) && inUnitRange(a);
	}

	ColorRGBA!T clamped() const pure nothrow {
		return ColorRGBA!T(clamp01(r), clamp01(g), clamp01(b), clamp01(a));
	}

	ColorRGBA8 to8Bit() const pure nothrow {
		const c = clamped();
		return ColorRGBA8(
			cast(ubyte) (c.r * 255 + 0.5),
			cast(ubyte) (c.g * 255 + 0.5),
			cast(ubyte) (c.b * 255 + 0.5),
			cast(ubyte) (c.a * 255 + 0.5));
	}

	ColorHSVA!T toHSVA() const pure nothrow {
		const c = clamped();
		const maxChannel = max3(c.r, c.g, c.b);
		const minChannel = min3(c.r, c.g, c.b);
		const delta = maxChannel - minChannel;

		T hue = 0;
		if (delta > cast(T) 0) {
			if (almostEqual(maxChannel, c.r)) {
				hue = cast(T) (60.0 * ((c.g - c.b) / delta));
			} else if (almostEqual(maxChannel, c.g)) {
				hue = cast(T) (60.0 * (((c.b - c.r) / delta) + 2.0));
			} else {
				hue = cast(T) (60.0 * (((c.r - c.g) / delta) + 4.0));
			}
			if (hue < cast(T) 0) {
				hue += cast(T) 360;
			}
		}

		const sat = maxChannel <= cast(T) 0 ? cast(T) 0 : delta / maxChannel;
		const val = maxChannel;
		return ColorHSVA!T(hue, sat, val, c.a);
	}

	ColorRGBA!T alphaBlendOver(const ColorRGBA!T background) const pure nothrow {
		const fg = clamped();
		const bg = background.clamped();
		const outA = fg.a + bg.a * (cast(T) 1 - fg.a);
		if (outA <= cast(T) 0) {
			return ColorRGBA!T(0, 0, 0, 0);
		}

		const outR = (fg.r * fg.a + bg.r * bg.a * (cast(T) 1 - fg.a)) / outA;
		const outG = (fg.g * fg.a + bg.g * bg.a * (cast(T) 1 - fg.a)) / outA;
		const outB = (fg.b * fg.a + bg.b * bg.a * (cast(T) 1 - fg.a)) / outA;
		return ColorRGBA!T(outR, outG, outB, outA);
	}
}

alias ColorRGBAf = ColorRGBA!float;
alias ColorRGBAd = ColorRGBA!double;