/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.css.properties;

import uim.web;

mixin(ShowModule!());

@safe:

// #region box model
/// margin shorthand with one value, e.g. margin(px(8)) -> "margin: 8px;"
string margin(string value) {
  return cssProperty("margin", value);
}

/// margin shorthand with vertical/horizontal values
string margin(string vertical, string horizontal) {
  return cssProperty("margin", "%s %s".format(vertical, horizontal));
}

/// margin shorthand with top/horizontal/bottom values
string margin(string top, string horizontal, string bottom) {
  return cssProperty("margin", "%s %s %s".format(top, horizontal, bottom));
}

/// margin shorthand with top/right/bottom/left values
string margin(string top, string right, string bottom, string left) {
  return cssProperty("margin", "%s %s %s %s".format(top, right, bottom, left));
}

/// padding shorthand with one value
string padding(string value) {
  return cssProperty("padding", value);
}

/// padding shorthand with vertical/horizontal values
string padding(string vertical, string horizontal) {
  return cssProperty("padding", "%s %s".format(vertical, horizontal));
}

/// padding shorthand with top/horizontal/bottom values
string padding(string top, string horizontal, string bottom) {
  return cssProperty("padding", "%s %s %s".format(top, horizontal, bottom));
}

/// padding shorthand with top/right/bottom/left values
string padding(string top, string right, string bottom, string left) {
  return cssProperty("padding", "%s %s %s %s".format(top, right, bottom, left));
}
// #endregion box model

// #region borders
/// border shorthand, e.g. border(px(1), "solid", "red") -> "border: 1px solid red;"
string border(string width, string style, string color) {
  return cssProperty("border", cssValues(width, style, color));
}

/// border-radius shorthand, e.g. borderRadius(px(4)) -> "border-radius: 4px;"
string borderRadius(string radius) {
  return cssProperty("border-radius", radius);
}

/// border-radius with individual corners (top-left top-right bottom-right bottom-left)
string borderRadius(string topLeft, string topRight, string bottomRight, string bottomLeft) {
  return cssProperty("border-radius", cssValues(topLeft, topRight, bottomRight, bottomLeft));
}

/// outline shorthand
string outline(string width, string style, string color) {
  return cssProperty("outline", cssValues(width, style, color));
}
// #endregion borders

// #region backgrounds
/// background-color declaration
string backgroundColor(string color) {
  return cssProperty("background-color", color);
}

/// background-image with an url, e.g. backgroundImage("bg.png") -> "background-image: url(\"bg.png\");"
string backgroundImage(string url) {
  return cssProperty("background-image", cssUrl(url));
}

/// Linear gradient, e.g. linearGradient(deg(90), "red", "blue")
string linearGradient(string direction, string[] colorStops...) {
  return "linear-gradient(%s)".format(cssValues(direction).length > 0
      ? ([direction] ~ colorStops).join(", ")
      : colorStops.join(", "));
}

/// Linear gradient in degrees, e.g. linearGradient(90, "red", "blue")
string linearGradient(int degrees, string[] colorStops...) {
  return linearGradient(deg(degrees), colorStops);
}

/// Radial gradient, e.g. radialGradient("circle", "red", "blue")
string radialGradient(string shape, string[] colorStops...) {
  return "radial-gradient(%s)".format(([shape] ~ colorStops).join(", "));
}

/// background shorthand with color and image
string background(string color, string imageUrl) {
  return cssProperty("background", cssValues(color, cssUrl(imageUrl)));
}
// #endregion backgrounds

// #region shadows
/// box-shadow declaration, e.g. boxShadow(px(2), px(4), px(6), "rgba(0,0,0,0.3)")
string boxShadow(string offsetX, string offsetY, string blur, string color) {
  return cssProperty("box-shadow", cssValues(offsetX, offsetY, blur, color));
}

/// box-shadow with spread radius
string boxShadow(string offsetX, string offsetY, string blur, string spread, string color) {
  return cssProperty("box-shadow", cssValues(offsetX, offsetY, blur, spread, color));
}

/// Inset box-shadow
string boxShadowInset(string offsetX, string offsetY, string blur, string color) {
  return cssProperty("box-shadow", "inset " ~ cssValues(offsetX, offsetY, blur, color));
}

/// text-shadow declaration
string textShadow(string offsetX, string offsetY, string blur, string color) {
  return cssProperty("text-shadow", cssValues(offsetX, offsetY, blur, color));
}
// #endregion shadows

// #region typography
/// font shorthand, e.g. font("italic", "bold", px(16), "Arial, sans-serif")
string font(string style, string weight, string size, string family) {
  return cssProperty("font", cssValues(style, weight, size, family));
}

/// font-size declaration
string fontSize(string size) {
  return cssProperty("font-size", size);
}

/// font-weight declaration, e.g. fontWeight(700) -> "font-weight: 700;"
string fontWeight(int weight) {
  return cssProperty("font-weight", weight.to!string);
}

/// font-weight declaration with a keyword, e.g. fontWeight("bold")
string fontWeight(string weight) {
  return cssProperty("font-weight", weight);
}

/// font-family declaration, e.g. fontFamily("Arial", "sans-serif") -> "font-family: Arial, sans-serif;"
string fontFamily(string[] families...) {
  return cssProperty("font-family", families.join(", "));
}

/// line-height declaration
string lineHeight(double value) {
  return cssProperty("line-height", trimNumber(value));
}

/// text-align declaration, e.g. textAlign("center")
string textAlign(string alignment) {
  return cssProperty("text-align", alignment);
}

/// text-decoration declaration, e.g. textDecoration("underline")
string textDecoration(string decoration) {
  return cssProperty("text-decoration", decoration);
}

/// text-transform declaration, e.g. textTransform("uppercase")
string textTransform(string transformation) {
  return cssProperty("text-transform", transformation);
}
// #endregion typography

// #region transforms and transitions
/// CSS transform functions, e.g. transform(translateX(px(10)), scale(1.5))
string transform(string[] functions...) {
  return cssProperty("transform", functions.join(" "));
}

/// translate() transform function
string translate(string x, string y) {
  return "translate(%s, %s)".format(x, y);
}

/// translateX() transform function
string translateX(string x) {
  return "translateX(%s)".format(x);
}

/// translateY() transform function
string translateY(string y) {
  return "translateY(%s)".format(y);
}

/// scale() transform function
string scale(double factor) {
  return "scale(%s)".format(trimNumber(factor));
}

/// scale() with separate x/y factors
string scale(double x, double y) {
  return "scale(%s, %s)".format(trimNumber(x), trimNumber(y));
}

/// rotate() transform function
string rotate(string angle) {
  return "rotate(%s)".format(angle);
}

/// skew() transform function
string skew(string x, string y) {
  return "skew(%s, %s)".format(x, y);
}

/// transition shorthand, e.g. transition("opacity", ms(300)) -> "transition: opacity 300ms ease;"
string transition(string property, string duration, string timingFunction = "ease") {
  return cssProperty("transition", cssValues(property, duration, timingFunction));
}

/// transition for multiple properties
string transitionAll(string duration, string timingFunction = "ease") {
  return cssProperty("transition", cssValues("all", duration, timingFunction));
}

/// animation shorthand, e.g. animation("fadeIn", s(2)) -> "animation: fadeIn 2s ease;"
string animation(string name, string duration, string timingFunction = "ease") {
  return cssProperty("animation", cssValues(name, duration, timingFunction));
}
// #endregion transforms and transitions

// #region layout
/// display declaration, e.g. display("flex")
string display(string value) {
  return cssProperty("display", value);
}

/// position declaration, e.g. position("absolute")
string position(string value) {
  return cssProperty("position", value);
}

/// Flexbox container declarations (display: flex)
string flex() {
  return cssProperty("display", "flex");
}

/// Flexbox declarations to center content horizontally and vertically
string flexCenter() {
  return [
    cssProperty("display", "flex"),
    cssProperty("justify-content", "center"),
    cssProperty("align-items", "center")
  ].join(" ");
}

/// flex-direction declaration
string flexDirection(string direction) {
  return cssProperty("flex-direction", direction);
}

/// justify-content declaration
string justifyContent(string value) {
  return cssProperty("justify-content", value);
}

/// align-items declaration
string alignItems(string value) {
  return cssProperty("align-items", value);
}

/// gap declaration for flex and grid layouts
string gap(string value) {
  return cssProperty("gap", value);
}

/// Grid container declarations (display: grid)
string grid() {
  return cssProperty("display", "grid");
}

/// grid-template-columns declaration, e.g. gridTemplateColumns(fr(1), fr(2), fr(1))
string gridTemplateColumns(string[] columns...) {
  return cssProperty("grid-template-columns", columns.join(" "));
}

/// grid-template-rows declaration
string gridTemplateRows(string[] rows...) {
  return cssProperty("grid-template-rows", rows.join(" "));
}

/// z-index declaration
string zIndex(int index) {
  return cssProperty("z-index", index.to!string);
}

/// opacity declaration, value in the range 0.0 .. 1.0
string opacity(double value) {
  return cssProperty("opacity", trimNumber(value));
}

/// visibility declaration
string visibility(string value) {
  return cssProperty("visibility", value);
}

/// overflow declaration
string overflow(string value) {
  return cssProperty("overflow", value);
}

/// cursor declaration, e.g. cursor("pointer")
string cursor(string value) {
  return cssProperty("cursor", value);
}
// #endregion layout

///
unittest {
  // box model
  assert(margin(px(8)) == "margin: 8px;");
  assert(margin(px(8), px(16)) == "margin: 8px 16px;");
  assert(margin(px(8), px(16), px(24)) == "margin: 8px 16px 24px;");
  assert(margin(px(1), px(2), px(3), px(4)) == "margin: 1px 2px 3px 4px;");
  assert(padding(rem(1)) == "padding: 1rem;");
  assert(padding(rem(1), rem(2)) == "padding: 1rem 2rem;");
  assert(padding(rem(1), rem(2), rem(3)) == "padding: 1rem 2rem 3rem;");
  assert(padding(rem(1), rem(2), rem(3), rem(4)) == "padding: 1rem 2rem 3rem 4rem;");

  // borders
  assert(border(px(1), "solid", "red") == "border: 1px solid red;");
  assert(borderRadius(px(4)) == "border-radius: 4px;");
  assert(borderRadius(px(4), px(8), px(4), px(8)) == "border-radius: 4px 8px 4px 8px;");
  assert(outline(px(2), "dashed", "blue") == "outline: 2px dashed blue;");

  // backgrounds
  assert(backgroundColor("#fff") == "background-color: #fff;");
  assert(backgroundImage("bg.png") == `background-image: url("bg.png");`);
  assert(linearGradient(deg(90), "red", "blue") == "linear-gradient(90deg, red, blue)");
  assert(linearGradient(180, "white", "black") == "linear-gradient(180deg, white, black)");
  assert(radialGradient("circle", "red", "blue") == "radial-gradient(circle, red, blue)");
  assert(background("#fff", "bg.png") == `background: #fff url("bg.png");`);
  assert(backgroundImage(`a");}body{x:y`) == `background-image: url("a\");}body{x:y");`);

  // shadows
  assert(boxShadow(px(2), px(4), px(6), "black") == "box-shadow: 2px 4px 6px black;");
  assert(boxShadow(px(1), px(2), px(3), px(4), "black") == "box-shadow: 1px 2px 3px 4px black;");
  assert(boxShadowInset(px(0), px(1), px(2), "gray") == "box-shadow: inset 0px 1px 2px gray;");
  assert(textShadow(px(1), px(1), px(2), "black") == "text-shadow: 1px 1px 2px black;");

  // typography
  assert(font("italic", "bold", px(16), "Arial") == "font: italic bold 16px Arial;");
  assert(fontSize(px(16)) == "font-size: 16px;");
  assert(fontWeight(700) == "font-weight: 700;");
  assert(fontWeight("bold") == "font-weight: bold;");
  assert(fontFamily("Arial", "sans-serif") == "font-family: Arial, sans-serif;");
  assert(lineHeight(1.5) == "line-height: 1.5;");
  assert(textAlign("center") == "text-align: center;");
  assert(textDecoration("underline") == "text-decoration: underline;");
  assert(textTransform("uppercase") == "text-transform: uppercase;");

  // transforms and transitions
  assert(transform(translateX(px(10)), scale(1.5)) == "transform: translateX(10px) scale(1.5);");
  assert(translate(px(10), px(20)) == "translate(10px, 20px)");
  assert(translateX(px(10)) == "translateX(10px)");
  assert(translateY(percent(50)) == "translateY(50%)");
  assert(scale(2) == "scale(2)");
  assert(scale(1, 2) == "scale(1, 2)");
  assert(rotate(deg(45)) == "rotate(45deg)");
  assert(skew(deg(10), deg(20)) == "skew(10deg, 20deg)");
  assert(transition("opacity", ms(300)) == "transition: opacity 300ms ease;");
  assert(transition("all", s(1), "linear") == "transition: all 1s linear;");
  assert(transitionAll(ms(200)) == "transition: all 200ms ease;");
  assert(animation("fadeIn", s(2)) == "animation: fadeIn 2s ease;");

  // layout
  assert(display("block") == "display: block;");
  assert(position("absolute") == "position: absolute;");
  assert(flex == "display: flex;");
  assert(flexCenter == "display: flex; justify-content: center; align-items: center;");
  assert(flexDirection("column") == "flex-direction: column;");
  assert(justifyContent("space-between") == "justify-content: space-between;");
  assert(alignItems("center") == "align-items: center;");
  assert(gap(rem(1)) == "gap: 1rem;");
  assert(grid == "display: grid;");
  assert(gridTemplateColumns(fr(1), fr(2)) == "grid-template-columns: 1fr 2fr;");
  assert(gridTemplateRows(px(100), fr(1)) == "grid-template-rows: 100px 1fr;");
  assert(zIndex(10) == "z-index: 10;");
  assert(opacity(0.5) == "opacity: 0.5;");
  assert(visibility("hidden") == "visibility: hidden;");
  assert(overflow("hidden") == "overflow: hidden;");
  assert(cursor("pointer") == "cursor: pointer;");
}
