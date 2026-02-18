/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.file;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The FileInput class represents an HTML <input> element with the type "file". It is used to create a file upload field that allows users to select files from their device to be uploaded to the server when a form is submitted.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "file" by default.
  * Example usage:
  * auto fileInput = H5FileInput("file");
  * assert(fileInput == `<input type="file" name="file">`);
  * assert(fileInput.type() == "file");
  * assert(fileInput.name() == "file");
  */
class H5FileInput : H5Input {
  mixin H5This!("input", false);

  override bool initialize(Json[string] initData = null) {
    super.initialize(initData);
    type("file");
    return true;
  }

  mixin(H5Calls!("FileInput"));
}
///
unittest {
  auto fileInput = H5FileInput("file");
  assert(fileInput == `<input type="file" name="file">`);
  assert(fileInput.type() == "file");
  assert(fileInput.name() == "file");  
}