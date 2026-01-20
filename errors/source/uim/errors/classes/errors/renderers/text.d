/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.errors.renderers.text;

import uim.errors;
mixin(ShowModule!());
@safe:

/**
 * Plain text error rendering with a stack trace.
 * Useful in CI or plain text environments.
 */
class DTextErrorRenderer : UIMErrorRenderer {
  mixin(ErrorRendererThis!("Text"));

  private IError _error;

  this(IError error) {
    _error = error;
  }

  // Render an error into a plain text message.
  string render() {
    return "%s : %s on line %s of %s\nTrace:\n%s".format(
      _error.message(),
      _error.fileName(),
      _error.lineNumber()
    );
  }

  // Write output to stdout.
  override IErrorRenderer write(string outputText) {
    writeln(outputText);
    return this;
  }
}
mixin(ErrorRendererCalls!("Text"));
