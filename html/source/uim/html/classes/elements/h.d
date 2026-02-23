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
  mixin(H5This!("h1", false));

  mixin(H5Calls!("h1")); 
}

class H5H2 : HtmlElement {
  mixin(H5This!("h2", false));

  mixin(H5Calls!("h2")); 
}

class H5H3 : HtmlElement {
  mixin(H5This!("h3", false));

  mixin(H5Calls!("h3")); 
}

class H5H4 : HtmlElement {
  mixin(H5This!("h4", false));

  mixin(H5Calls!("h4")); 
}

class H5H5 : HtmlElement {
  mixin(H5This!("h5", false));

  mixin(H5Calls!("h5")); 
}

class H5H6 : HtmlElement {
  mixin(H5This!("h6", false));

  mixin(H5Calls!("h6")); 
}


