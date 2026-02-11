/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.errors.renderers.text;

import uim.errors;
mixin(ShowModule!());
@safe:

/**
 * Plain text error rendering with a stack trace.
 * Useful in CI or plain text environments.
 */
class TextErrorRenderer : ErrorRenderer {
  mixin(ErrorRendererThis!("Text"));

  private IError _error;

  this(IError error) {
    _error = error;
  }

  // Render an error into a plain text message.
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

  // Write output to stdout.
  override IErrorRenderer write(string output) {
    import std.stdio : writeln;
    writeln(output);
    return this;
  }
}
