/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.article;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Article : HtmlElement {
  mixin(H5Template!("Article", "article", false));
  mixin(AttributeMethods!H5Article);
}
///
unittest {
  assert(H5Article() == `<article></article>`);
  assert(H5Article(["testclass"]) == `<article class="testclass"></article>`);
  assert(H5Article(["a":"b"]) == `<article a="b"></article>`);

  assert(H5Article("Hello") == `<article>Hello</article>`);
  assert(H5Article(["testclass"], "Hello") == `<article class="testclass">Hello</article>`);
  assert(H5Article(["a":"b"], "Hello") == `<article a="b">Hello</article>`);

  assert(H5Article(["testclass"], ["a":"b"], "Hello") == `<article class="testclass" a="b">Hello</article>`);
}
