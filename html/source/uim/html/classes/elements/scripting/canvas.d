/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.scripting.canvas;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <canvas> element.
  * Provides methods to set canvas attributes like height and width.
  * Example usage:
  * auto canvas = Canvas("400", "600");
  */
  @StringAttribute("height") /// The height of the canvas in pixels or as a percentage of the containing element.
  @StringAttribute("width") /// The width of the canvas in pixels or as a percentage of the containing element.
class H5Canvas : HtmlElement {
  mixin(HtmlTemplate!(H5Canvas, "Canvas", "canvas", false));
}
///
unittest {
  assert(H5Canvas() == `<canvas></canvas>`);
  assert(H5Canvas(["testclass"]) == `<canvas class="testclass"></canvas>`);
  assert(H5Canvas(["a":"b"]) == `<canvas a="b"></canvas>`);
  assert(H5Canvas(["testclass"], ["a":"b"]) == `<canvas class="testclass" a="b"></canvas>`);

  assert(H5Canvas("Hello") == `<canvas></canvas>`);
  assert(H5Canvas(["testclass"], "Hello") == `<canvas class="testclass">Hello</canvas>`);
  assert(H5Canvas(["a":"b"], "Hello") == `<canvas a="b">Hello</canvas>`);
  assert(H5Canvas(["testclass"], ["a":"b"], "Hello") == `<canvas class="testclass" a="b">Hello</canvas>`);

  assert(H5Canvas().height("400").width("600") == `<canvas height="400" width="600"></canvas>`);
}