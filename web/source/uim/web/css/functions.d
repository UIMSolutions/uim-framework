/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.functions;

import uim.web;

mixin(ShowModule!());

@safe:

/// CSS string literal, e.g. cssString(`a"b`) -> `"a\"b"`
string cssString(string value) {
  auto result = appender!string;
  result.put('"');
  foreach (dchar c; value) {
    switch (c) {
      case '"': result.put(`\"`); break;
      case '\\': result.put(`\\`); break;
      case '\n': result.put(`\a `); break;
      case '\r': result.put(`\d `); break;
      default: result.put(c);
    }
  }
  result.put('"');
  return result.data;
}

/// CSS url() function, e.g. cssUrl("bg.png") -> `url("bg.png")`
string cssUrl(string url) {
  return "url(%s)".format(cssString(url));
}
///
unittest {
  mixin(ShowTest!"cssUrl");

  assert(cssUrl("bg.png") == `url("bg.png")`);
}

/** 
 * Escapes a class name or id for use in a selector.
 *
 * Params:
 *   identifier = The class name or id to escape
 *
 * Returns:
 *   The escaped identifier
 */
string cssEscape(string identifier) {
  auto result = appender!string;
  size_t index;
  foreach (dchar c; identifier) {
    bool isDigit = c >= '0' && c <= '9';
    bool isLeadingDigit = isDigit && (index == 0 || (index == 1 && identifier[0] == '-'));
    if (c < 0x20 || c == 0x7F || isLeadingDigit) {
      result.put(`\%x `.format(cast(uint)c)); // code point escapes end at the space
    } else if (c >= 0x80 || isDigit || c == '-' || c == '_' || (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
      result.put(c);
    } else {
      result.put('\\');
      result.put(c);
    }
    index++;
  }
  return result.data;
}
///
unittest {
  mixin(ShowTest!"cssEscape");

  assert(cssEscape("button") == "button");
  assert(cssEscape("md:flex") == `md\:flex`);
  assert(cssEscape("w-1/2") == `w-1\/2`);
  assert(cssEscape("1a") == `\31 a`);
  assert(cssEscape("-1a") == `-\31 a`);
  assert(cssEscape("a1") == "a1");
  assert(cssEscape("größe") == "größe");
}

/**
 * CSS calc() function, e.g. cssCalc("100% - 2rem") -> "calc(100% - 2rem)"
 *
 * Params:
 *   expression = The expression to use inside calc()
 *
 * Returns:
 *   The calc() function as a string
 */
string cssCalc(string expression) {
  return "calc(%s)".format(expression);
}
///
unittest {
  mixin(ShowTest!"cssCalc");

  assert(cssCalc("100% - 2rem") == "calc(100% - 2rem)");
  assert(cssCalc("50% + 1rem") == "calc(50% + 1rem)");
}

/**
 * CSS clamp() function, e.g. cssClamp(rem(1), vw(2), rem(3)) -> "clamp(1rem, 2vw, 3rem)"
 *
 * Params:
 *   minimum = The minimum value
 *   preferred = The preferred value
 *   maximum = The maximum value
 *
 * Returns:
 *   The clamp() function as a string
 */
string cssClamp(string minimum, string preferred, string maximum) {
  return "clamp(%s, %s, %s)".format(minimum, preferred, maximum);
}
///
unittest {
  mixin(ShowTest!"cssClamp");

  assert(cssClamp(rem(1), vw(2), rem(3)) == "clamp(1rem, 2vw, 3rem)");
  assert(cssClamp(rem(2), vw(3), rem(4)) == "clamp(2rem, 3vw, 4rem)");
}

/**
 * CSS min() function, e.g. cssMin(percent(100), px(600)) -> "min(100%, 600px)"
 *
 * Params:
 *   values = The values to use inside min()
 *
 * Returns:
 *   The min() function as a string
 */
string cssMin(string[] values...) {
  return "min(%s)".format(values.join(", "));
}
///
unittest {
  mixin(ShowTest!"cssMin");

  assert(cssMin(percent(100), px(600)) == "min(100%, 600px)");
}

/// CSS max() function
/**
 * CSS max() function, e.g. cssMax(px(1), px(2), px(3)) -> "max(1px, 2px, 3px)"
 *
 * Params:
 *   values = The values to use inside max()
 *
 * Returns:
 *   The max() function as a string
 */
string cssMax(string[] values...) {
  return "max(%s)".format(values.join(", "));
}
///
unittest {
  mixin(ShowTest!"cssMax");

  assert(cssMax(px(1), px(2), px(3)) == "max(1px, 2px, 3px)"); 
}

/**
 * Creates a @font-face rule.
 *
 * Params:
 *   family = The font family name
 *   source = The src value, e.g. cssUrl("inter.woff2")
 *   weight = The font-weight, omitted if null
 *   display = The font-display value
 */
CssRule cssFontFace(string family, string source, string weight = null, string display = "swap") {
  auto rule = new CssRule("@font-face")
    .set("font-family", cssString(family))
    .set("src", source)
    .set("font-display", display);
  return weight.length > 0 ? rule.set("font-weight", weight) : rule;
}
///
unittest {
  mixin(ShowTest!"cssFontFace");

  assert(
    cssFontFace("Inter", cssUrl("inter.woff2")).toString
      == `@font-face { font-family: "Inter"; src: url("inter.woff2"); font-display: swap; }`);
}

///
unittest {
  assert(cssString("plain") == `"plain"`);
  assert(cssString(`a"b\c`) == `"a\"b\\c"`);
  assert(cssString("a\nb") == `"a\a b"`);
  assert(cssString("äö") == `"äö"`);

  assert(cssUrl("bg.png") == `url("bg.png")`);
  assert(cssUrl(`a");}`) == `url("a\");}")`);

  assert(cssEscape("button") == "button");
  assert(cssEscape("md:flex") == `md\:flex`);
  assert(cssEscape("w-1/2") == `w-1\/2`);
  assert(cssEscape("1a") == `\31 a`);
  assert(cssEscape("-1a") == `-\31 a`);
  assert(cssEscape("a1") == "a1");
  assert(cssEscape("größe") == "größe");

  assert(cssCalc("100% - 2rem") == "calc(100% - 2rem)");
  assert(cssClamp(rem(1), vw(2), rem(3)) == "clamp(1rem, 2vw, 3rem)");
  assert(cssMin(percent(100), px(600)) == "min(100%, 600px)");
  assert(cssMax(px(1), px(2), px(3)) == "max(1px, 2px, 3px)");

  assert(cssFontFace("Inter", cssUrl("inter.woff2")).toString
    == `@font-face { font-family: "Inter"; src: url("inter.woff2"); font-display: swap; }`);
  assert(cssFontFace("Inter", cssUrl("b.woff2"), "700", "block").minify
    == `@font-face{font-family:"Inter";src:url("b.woff2");font-display:block;font-weight:700}`);
}
