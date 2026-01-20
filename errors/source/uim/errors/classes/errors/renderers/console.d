/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.errors.renderers.console;

import uim.errors;
mixin(ShowModule!());

@safe:

/*
 * Plain text error rendering with a stack trace.
 * Writes to STDERR via a UIM\Console\OutputConsole instance for console environments
 */
class DConsoleErrorRenderer : UIMErrorRenderer {
  mixin(ErrorRendererThis!("Console"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // `stderr` - The OutputConsole instance to use. Defaults to `D://stderr`
    // TODO _output = configuration.getEntry("stderr", new DOutput("d://stderr"));
    // `trace` - Whether or not stacktraces should be output.       
    // TODO showTrace(configuration.getBooleanEntry("trace"));

    return true;
  }

  // #region showTrace
  protected bool _showTrace = false;
  bool showTrace() {
    return _showTrace;
  }

  IErrorRenderer showTrace(bool value) {
    _showTrace = value;
    return this;
  }
  // #endregion showTrace

  // TODO protected DOutput _output;

  override IErrorRenderer write(string outputText) {
    writeln(outputText);
    return this;
  }

  override string render(IError error, bool shouldDebug) {
    auto errors = [error];
    auto previousError = error.previous();
    while (previousError !is null) {
      errors = previousError ~ errors;
      previousError = previousError.previous();
    }

    return errors.map!(e => renderError(e)).join("\n");
  }

  string renderError(IError error, IError parantError = null) {
    if (!error) {
      return "<error>Invalid error object provided.</error>";
    }

    // Render an individual error
    auto rendered = "<error>%s: %s . %s</error> on line %s of %s%s"
      .format(
        error.loglabel(),
        error.loglevel(),
        error.message(),
        error.line() ? error.line() : "",
        error.fileName() ? error.fileName() : "",
        showTrace ? "\n<info>Stack Trace:</info>\n\n" ~ error.traceAsString() : ""
      );

    // auto showDebug = configuration.getBooleanEntry("debug");
    bool showDebug = false; // TODO: Get from configuration
    if (showDebug) {
      auto attributes = error.attributes();
      if (attributes) {
        rendered ~= "<info>Error Attributes</info>";
        // TODO: rendered ~= attributes.byKeyValue.map!(kv => "\n  - %s: %s".format(kv.key, kv.value)).array.join("");
      }
    }

    if (_showTrace) {
      /* 
      auto stacktrace = Debugger.getUniqueFrames(errorToRender, parentError);
      rendered ~= "<info>Stack Trace:</info>";
      rendered ~= Debugger.formatTrace(stacktrace, ["format": "text"]);
      */
    }

    return rendered;
  }

  override string toString() {
    return "DConsoleErrorRenderer";
  }
}
