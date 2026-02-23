/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.hgroup;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Hgroup : HtmlElement {
  mixin(H5Template!("Hgroup", "hgroup", false));
  mixin(AttributeMethods!H5Hgroup);
}
///
unittest {
  assert(H5Hgroup() == `<hgroup></hgroup>`);
  assert(H5Hgroup(["testclass"]) == `<hgroup class="testclass"></hgroup>`);
  assert(H5Hgroup(["a":"b"]) == `<hgroup a="b"></hgroup>`);

  assert(H5Hgroup("Hello") == `<hgroup>Hello</hgroup>`);
  assert(H5Hgroup(["testclass"], "Hello") == `<hgroup class="testclass">Hello</hgroup>`);
  assert(H5Hgroup(["a":"b"], "Hello") == `<hgroup a="b">Hello</hgroup>`);

  assert(H5Hgroup(["testclass"], ["a":"b"], "Hello") == `<hgroup class="testclass" a="b">Hello</hgroup>`);
}
