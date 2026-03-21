module uim.core.datatypes.colors.hsva;
import uim.core;

mixin(ShowModule!());

@safe:

struct ColorHSVA(T = float) if (isColorFloat!T) {
	T h;
	T s;
	T v;
	T a = cast(T) 1;

	bool isValid() const pure nothrow {
		return h >= cast(T) 0 && h < cast(T) 360 && inUnitRange(s) && inUnitRange(v) && inUnitRange(a);
	}

	ColorHSVA!T normalized() const pure nothrow {
		T normalizedHue = h;
		while (normalizedHue < cast(T) 0) {
			normalizedHue += cast(T) 360;
		}
		while (normalizedHue >= cast(T) 360) {
			normalizedHue -= cast(T) 360;
		}

		return ColorHSVA!T(normalizedHue, clamp01(s), clamp01(v), clamp01(a));
	}

	ColorRGBA!T toRGBA() const pure nothrow {
		const c = normalized();
		const chroma = c.v * c.s;
		const hPrime = c.h / cast(T) 60;
		const x = chroma * (cast(T) 1 - cast(T) abs((hPrime % cast(T) 2) - cast(T) 1));

		T r1;
		T g1;
		T b1;

		if (hPrime < cast(T) 1) {
			r1 = chroma;
			g1 = x;
			b1 = 0;
		} else if (hPrime < cast(T) 2) {
			r1 = x;
			g1 = chroma;
			b1 = 0;
		} else if (hPrime < cast(T) 3) {
			r1 = 0;
			g1 = chroma;
			b1 = x;
		} else if (hPrime < cast(T) 4) {
			r1 = 0;
			g1 = x;
			b1 = chroma;
		} else if (hPrime < cast(T) 5) {
			r1 = x;
			g1 = 0;
			b1 = chroma;
		} else {
			r1 = chroma;
			g1 = 0;
			b1 = x;
		}

		const m = c.v - chroma;
		return ColorRGBA!T(r1 + m, g1 + m, b1 + m, c.a);
	}
}

alias ColorHSVAf = ColorHSVA!float;
alias ColorHSVAd = ColorHSVA!double;