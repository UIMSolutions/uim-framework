/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.search;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5SearchInput class represents an HTML <input> element with the type "search". It is used to create input fields that accept search values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "search" by default.
  * Example usage:
  * auto searchInput = H5SearchInput("search");
  * assert(searchInput == `<input type="search" name="search">`);
  * assert(searchInput.type() == "search");
  * assert(searchInput.name() == "search");
  */
class H5SearchInput : H5Input {
  mixin H5This!("input", false);

  override bool initialize(Json[string] initData = null) {
    super.initialize(initData);
    
    type("search");
    return true;  
  }

  mixin(H5Calls!("SearchInput"));
}
///
unittest {
  auto searchInput = H5SearchInput("search");
  assert(searchInput == `<input type="search" name="search">`);
  assert(searchInput.type() == "search");
  assert(searchInput.name() == "search");  
}