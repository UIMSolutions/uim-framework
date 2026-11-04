/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.colors;

import std.ascii : isDigit;

import uim.web;

mixin(ShowModule!());

@safe:

/**
 * Creates a CSS rgb() color string.
 *
 * Params:
 *   red = Red component (0-255)
 *   green = Green component (0-255)
 *   blue = Blue component (0-255)
 *
 * Returns: CSS rgb() color string, e.g. "rgb(255, 0, 0)"
 */
string rgb(ubyte red, ubyte green, ubyte blue) {
  return "rgb(%s, %s, %s)".format(red, green, blue);
}
///
unittest {
  mixin(ShowTest!"rgb");

  assert(rgb(255, 0, 0) == "rgb(255, 0, 0)");
  assert(rgba(255, 0, 0, 0.5) == "rgba(255, 0, 0, 0.5)");
}

/**
 * Creates a CSS rgba() color string.
 *
 * Params:
 *   red = Red component (0-255)
 *   green = Green component (0-255)
 *   blue = Blue component (0-255)
 *   alpha = Alpha component (0.0-1.0)
 *
 * Returns: CSS rgba() color string, e.g. "rgba(255, 0, 0, 0.5)"
 */
string rgba(ubyte red, ubyte green, ubyte blue, double alpha) {
  return "rgba(%s, %s, %s, %s)".format(red, green, blue, trimNumber(alpha));
}
///
unittest {
  mixin(ShowTest!"rgba");

  assert(rgba(255, 0, 0, 0.5) == "rgba(255, 0, 0, 0.5)");
}

/// CSS hsl() color function, e.g. hsl(120, 100, 50) -> "hsl(120, 100%, 50%)"
/**
 * Creates a CSS hsl() color string.
 *
 * Params:
 *   hue = Hue component (0-360)
 *   saturation = Saturation component (0-100)
 *   lightness = Lightness component (0-100)
 *
 * Returns: CSS hsl() color string, e.g. "hsl(120, 100%, 50%)"
 */
string hsl(int hue, int saturation, int lightness) {
  return "hsl(%s, %s%%, %s%%)".format(hue, saturation, lightness);
}
///
unittest {
  mixin(ShowTest!"hsl");

  assert(hsl(120, 100, 50) == "hsl(120, 100%, 50%)");
}

/**
 * Creates a CSS hsla() color string.
 *
 * Params:
 *   hue = Hue component (0-360)
 *   saturation = Saturation component (0-100)
 *   lightness = Lightness component (0-100)
 *   alpha = Alpha component (0.0-1.0)
 *
 * Returns: CSS hsla() color string, e.g. "hsla(120, 100%, 50%, 0.5)"
 */
string hsla(int hue, int saturation, int lightness, double alpha) {
  return "hsla(%s, %s%%, %s%%, %s)".format(hue, saturation, lightness, trimNumber(alpha));
}
///
unittest {
  mixin(ShowTest!"hsla");

  assert(hsla(120, 100, 50, 0.5) == "hsla(120, 100%, 50%, 0.5)");
}

/**
 * Normalizes a hex color string to the form "#rrggbb" (lowercase, 6 digits)
 *
 * Params:
 *   hexColor = Hex color string, e.g. "#fff", "ff0000"
 *
 * Returns: Normalized hex color string, e.g. "#ffffff"
 */
string normalizeHex(string hexColor) {
  string result = hexColor.strip;
  if (result.startsWith("#")) {
    result = result[1 .. $];
  }
  if (result.length == 3) {
    result = result.map!(c => "%c%c".format(c, c)).join;
  }
  return "#" ~ result.toLower;
}

/**
 * Checks whether a string is a valid CSS hex color.
 *
 * Params:
 *   value = String to check, e.g. "#fff", "#ff0000", "ff0000"
 *
 * Returns: true if the string is a valid hex color, false otherwise
 */
bool isHexColor(string value) {
  string hex = value.strip;
  if (hex.startsWith("#")) {
    hex = hex[1 .. $];
  }
  if (hex.length != 3 && hex.length != 4 && hex.length != 6 && hex.length != 8) {
    return false;
  }
  return hex.all!(c => c.isHexDigit);
}

/**
 * Converts a hex color ("#rrggbb") to a CSS rgb() function string.
 *
 * Params:
 *   hexColor = Hex color string, e.g. "#ff0000"
 *
 * Returns: CSS rgb() color string, e.g. "rgb(255, 0, 0)"
 */
string hexToRgb(string hexColor) {
  string hex = normalizeHex(hexColor)[1 .. $];
  auto red = hex[0 .. 2].to!ubyte(16);
  auto green = hex[2 .. 4].to!ubyte(16);
  auto blue = hex[4 .. 6].to!ubyte(16);
  return rgb(red, green, blue);
}

/// Converts red/green/blue components to a hex color string "#rrggbb"
string rgbToHex(ubyte red, ubyte green, ubyte blue) {
  return "#%02x%02x%02x".format(red, green, blue);
}
///
unittest {
  mixin(ShowTest!"rgb rgba");
 
  assert(rgb(255, 0, 0) == "rgb(255, 0, 0)");
  assert(rgb(0, 255, 0) == "rgb(0, 255, 0)");
  assert(rgb(0, 0, 255) == "rgb(0, 0, 255)");
}

/**
 * Returns the CSS currentColor keyword.
 *
 * Returns: "currentColor"
 */
string currentColor() {
  return "currentColor";
}

/**
 * Returns the CSS transparent keyword.
 *
 * Returns: "transparent"
 */
string transparent() {
  return "transparent";
}

/**
 * Checks whether a character is a valid hexadecimal digit.
 *
 * Params:
 *   c = Character to check
 *
 * Returns: true if the character is a hex digit, false otherwise
 */
private bool isHexDigit(dchar c) {
  return c.isDigit || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
}

///
unittest {
  assert(isHexDigit('0'));
  assert(isHexDigit('9'));
  assert(isHexDigit('a'));
  assert(isHexDigit('f'));
  assert(isHexDigit('A'));
  assert(isHexDigit('F'));
  assert(!isHexDigit('g'));
  assert(!isHexDigit('z'));
  assert(!isHexDigit('G'));
  assert(!isHexDigit('Z'));
}

///
unittest {
  assert(rgb(255, 0, 0) == "rgb(255, 0, 0)");
  assert(rgba(255, 0, 0, 0.5) == "rgba(255, 0, 0, 0.5)");
  assert(hsl(120, 100, 50) == "hsl(120, 100%, 50%)");
  assert(hsla(120, 100, 50, 0.25) == "hsla(120, 100%, 50%, 0.25)");

  assert(normalizeHex("#FFF") == "#ffffff");
  assert(normalizeHex("ff0000") == "#ff0000");
  assert(normalizeHex("#Ab12Cd") == "#ab12cd");

  assert(isHexColor("#fff"));
  assert(isHexColor("#ff0000"));
  assert(isHexColor("ff0000"));
  assert(!isHexColor("#ff"));
  assert(!isHexColor("#gg0000"));
  assert(!isHexColor("red"));
  assert(isHexColor("#ff00")); // #rgba form

  assert(hexToRgb("#ff0000") == "rgb(255, 0, 0)");
  assert(hexToRgb("#00ff00") == "rgb(0, 255, 0)");
  assert(rgbToHex(255, 0, 0) == "#ff0000");
  assert(rgbToHex(0, 128, 255) == "#0080ff");

  assert(currentColor() == "currentColor");
  assert(transparent()  == "transparent");
}
