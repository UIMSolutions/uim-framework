/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.errors.renderers.yaml;

import uim.errors;

mixin(ShowModule!());
@safe:

class YamlErrorRenderer : ErrorRenderer {
  mixin(ErrorRendererThis!("Yaml"));

  override string render(IError error, bool shouldDebug) {
    // In a real implementation, this would render an HTML page with the error details.
    // For simplicity, we return a plain text representation here.
    if (shouldDebug) {
      // Render detailed error information for debugging.
      return "%s : %s on line %s of %s\nTrace:\n%s".format(
        error.message(),
        error.fileName(),
        error.lineNumber(),
        error.traceAsString()
      );
    } else {
      // Render a generic error message for production.
      return "An error occurred. Please try again later.";
    }
  }
}
