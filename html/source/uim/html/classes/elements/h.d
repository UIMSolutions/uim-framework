/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.h;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML heading element (h1-h6)
class H5H1 : HtmlElement {
  mixin(HtmlTemplate!(H5H1, "H1", "h1", false));
  mixin(HtmlMethods!H5H1);
}
///
unittest {
  assert(H5H1() == `<h1></h1>`);
  assert(H5H1(["testclass"]) == `<h1 class="testclass"></h1>`);
  assert(H5H1(["a": "b"]) == `<h1 a="b"></h1>`);

  assert(H5H1("Hello") == `<h1>Hello</h1>`);
  assert(H5H1(["testclass"], "Hello") == `<h1 class="testclass">Hello</h1>`);
  assert(H5H1(["a": "b"], "Hello") == `<h1 a="b">Hello</h1>`);

  assert(H5H1(["testclass"], ["a": "b"], "Hello") == `<h1 class="testclass" a="b">Hello</h1>`);
}

class H5H2 : HtmlElement {
  mixin(HtmlTemplate!(H5H2, "H2", "h2", false));
  mixin(HtmlMethods!H5H2);
}
///
unittest {
  assert(H5H2() == `<h2></h2>`);
  assert(H5H2(["testclass"]) == `<h2 class="testclass"></h2>`);
  assert(H5H2(["a": "b"]) == `<h2 a="b"></h2>`);

  assert(H5H2("Hello") == `<h2>Hello</h2>`);
  assert(H5H2(["testclass"], "Hello") == `<h2 class="testclass">Hello</h2>`);
  assert(H5H2(["a": "b"], "Hello") == `<h2 a="b">Hello</h2>`);

  assert(H5H2(["testclass"], ["a": "b"], "Hello") == `<h2 class="testclass" a="b">Hello</h2>`);
}

class H5H3 : HtmlElement {
  mixin(HtmlTemplate!(H5H3, "H3", "h3", false));
  mixin(HtmlMethods!H5H3);
}
///
unittest {
  assert(H5H3() == `<h3></h3>`);
  assert(H5H3(["testclass"]) == `<h3 class="testclass"></h3>`);
  assert(H5H3(["a": "b"]) == `<h3 a="b"></h3>`);

  assert(H5H3("Hello") == `<h3>Hello</h3>`);
  assert(H5H3(["testclass"], "Hello") == `<h3 class="testclass">Hello</h3>`);
  assert(H5H3(["a": "b"], "Hello") == `<h3 a="b">Hello</h3>`);

  assert(H5H3(["testclass"], ["a": "b"], "Hello") == `<h3 class="testclass" a="b">Hello</h3>`);
}

class H5H4 : HtmlElement {
  mixin(HtmlTemplate!(H5H4, "H4", "h4", false));
  mixin(HtmlMethods!H5H4);
}
///
unittest {
  assert(H5H4() == `<h4></h4>`);
  assert(H5H4(["testclass"]) == `<h4 class="testclass"></h4>`);
  assert(H5H4(["a": "b"]) == `<h4 a="b"></h4>`);
  assert(H5H4(["testclass"], ["a": "b"]) == `<h4 class="testclass" a="b"></h4>`);

  assert(H5H4("Hello") == `<h4>Hello</h4>`);
  assert(H5H4(["testclass"], "Hello") == `<h4 class="testclass">Hello</h4>`);
  assert(H5H4(["a": "b"], "Hello") == `<h4 a="b">Hello</h4>`);
  assert(H5H4(["testclass"], ["a": "b"], "Hello") == `<h4 class="testclass" a="b">Hello</h4>`);
}

class H5H5 : HtmlElement {
  mixin(HtmlTemplate!(H5H5, "H5", "h5", false));
  mixin(HtmlMethods!H5H5);
}
///
unittest {
  assert(H5H5() == `<h5></h5>`);
  assert(H5H5(["testclass"]) == `<h5 class="testclass"></h5>`);
  assert(H5H5(["a": "b"]) == `<h5 a="b"></h5>`);

  assert(H5H5("Hello") == `<h5>Hello</h5>`);
  assert(H5H5(["testclass"], "Hello") == `<h5 class="testclass">Hello</h5>`);
  assert(H5H5(["a": "b"], "Hello") == `<h5 a="b">Hello</h5>`);

  assert(H5H5(["testclass"], ["a": "b"], "Hello") == `<h5 class="testclass" a="b">Hello</h5>`);
}

class H5H6 : HtmlElement {
  mixin(HtmlTemplate!(H5H6, "H6", "h6", false));
}
///
unittest {
  assert(H5H6() == `<h6></h6>`);
  assert(H5H6(["testclass"]) == `<h6 class="testclass"></h6>`);
  assert(H5H6(["a": "b"]) == `<h6 a="b"></h6>`);

  assert(H5H6("Hello") == `<h6>Hello</h6>`);
  assert(H5H6(["testclass"], "Hello") == `<h6 class="testclass">Hello</h6>`);
  assert(H5H6(["a": "b"], "Hello") == `<h6 a="b">Hello</h6>`);

  assert(H5H6(["testclass"], ["a": "b"], "Hello") == `<h6 class="testclass" a="b">Hello</h6>`);
}
