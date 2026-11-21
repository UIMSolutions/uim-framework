/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Command line application framework: command registry with (multi word)
/// command paths, generated help, global options and uniform exit codes
/// (0 success, 1 failure, 2 usage error).
///
/// ---
/// auto app = new CliApplication("uim-demo-cli", "Demo administration");
/// app.command("greet", "<name>", "Say hello", (CliContext c) {
///   c.print("Hello " ~ c.operand(0, "name") ~ "\n");
///   return 0;
/// });
/// return app.run(argv[1 .. $]);
/// ---
module uim.service.presentation.cli.app;

import uim.service;
import uim.service.ports.services.context;
import uim.service.ports.services.entitysets : EntitySetException;
import uim.service.presentation.odata.query : ODataQueryException;
import uim.service.presentation.cli.args;
import uim.service.presentation.cli.table;

mixin(ShowModule!());

@safe:

alias CliHandler = int delegate(CliContext ctx) @safe;
alias CliOutput = void delegate(string text) @safe;

/// A registered command.
struct CliCommandDef {
  string[] path; /// e.g. ["users", "list"]
  string synopsis; /// arguments, e.g. "<Set> [--filter=EXPR]"
  string summary;
  CliHandler handler;
  string[] options; /// command specific option names (for validation); null = accept any

  string name() const {
    return path.join(" ");
  }
}

/// Everything a command handler needs.
class CliContext {
  CliArgs args;
  string[] operands; /// positional arguments after the command path
  RequestContext request; /// caller context (tenant, user, channel "cli")
  bool json; /// --json: machine readable output
  bool csv; /// --csv: CSV tables
  string[] globalOptions; /// names of the application wide options
  protected CliOutput output;

  this(CliArgs args, string[] operands, RequestContext request, CliOutput output) {
    this.args = args;
    this.operands = operands;
    this.request = request;
    this.json = args.flag("json");
    this.csv = args.flag("csv");
    this.output = output;
  }

  void print(string text) {
    output(text);
  }

  /// Operand i or a usage error.
  string operand(size_t i, string what) {
    if (i >= operands.length || operands[i].length == 0)
      throw new CliUsageError("missing argument: " ~ what);
    return operands[i];
  }

  /// Operand i or "".
  string optionalOperand(size_t i) {
    return i < operands.length ? operands[i] : "";
  }

  /// Print JSON (--json) or the table (text / --csv).
  int emit(Json data, lazy TextTable table) {
    if (json)
      print(data.toPrettyString ~ "\n");
    else if (csv)
      print(table.renderCsv);
    else
      print(table.render);
    return 0;
  }

  /// Print JSON (--json) or a message.
  int done(Json data, string message) {
    print(json ? data.toPrettyString ~ "\n" : message ~ "\n");
    return 0;
  }
}

class CliApplication {
  string program;
  string description;
  string defaultTenant = "default";
  string defaultUser;

  protected CliCommandDef[] commands;
  protected string[3][] globalOptions; // [name, synopsis, help]
  protected CliOutput output;
  protected CliOutput errorOutput;

  this(string program, string description, CliOutput output = null, CliOutput errorOutput = null) {
    this.program = program;
    this.description = description;
    this.output = output !is null ? output : (string s) @trusted { import std.stdio : write; write(s); };
    this.errorOutput = errorOutput !is null ? errorOutput : (output !is null ? output : (string s) @trusted {
      import std.stdio : stderr;

      stderr.write(s);
    });
    globalOption("tenant", "<id>", "tenant to operate on (default: " ~ defaultTenant ~ ")");
    globalOption("user", "<id>", "user recorded as actor");
    globalOption("json", "", "machine readable JSON output");
    globalOption("csv", "", "CSV instead of aligned tables");
    globalOption("help", "", "show help (also: help <command>)");
  }

  /// Register a global option (shown in help, accepted by every command).
  CliApplication globalOption(string name, string synopsis, string help) {
    foreach (ref o; globalOptions)
      if (o[0] == name) {
        o = [name, synopsis, help];
        return this;
      }
    globalOptions ~= [name, synopsis, help];
    return this;
  }

  /// Register a command; path may contain spaces ("users list").
  CliApplication command(string path, string synopsis, string summary, CliHandler handler, string[] options = null) {
    auto parts = path.split(" ").filter!(p => p.length > 0).array;
    enforce(parts.length > 0, "empty command path");
    enforce(!commands.any!(c => c.path == parts), "duplicate command " ~ path);
    commands ~= CliCommandDef(parts, synopsis, summary, handler, options);
    return this;
  }

  const(CliCommandDef)[] registered() const {
    return commands;
  }

  /// The generated help text.
  string usage(string topic = "") const {
    string text;
    if (topic.length > 0) {
      foreach (c; commands)
        if (c.name == topic || c.path[0] == topic)
          text ~= "  " ~ program ~ " " ~ c.name ~ (c.synopsis.length ? " " ~ c.synopsis : "") ~ "\n      " ~ c.summary ~ "\n";
      if (text.length > 0)
        return text;
    }
    text = program ~ " — " ~ description ~ "\n\nUsage: " ~ program ~ " <command> [arguments] [options]\n\nCommands:\n";
    auto width = commands.map!(c => c.name.length + (c.synopsis.length ? c.synopsis.length + 1 : 0)).fold!max(size_t(0));
    width = min(width, 52);
    foreach (c; commands) {
      auto left = c.name ~ (c.synopsis.length ? " " ~ c.synopsis : "");
      text ~= "  " ~ left ~ (left.length < width ? ' '.repeat(width - left.length).array.idup : "\n  " ~ ' '.repeat(width)
          .array.idup) ~ "  " ~ c.summary ~ "\n";
    }
    text ~= "  help [command]" ~ ' '.repeat(width > 14 ? width - 14 : 0).array.idup ~ "  show help\n\nGlobal options:\n";
    foreach (o; globalOptions) {
      auto left = "--" ~ o[0] ~ (o[1].length ? "=" ~ o[1] : "");
      text ~= "  " ~ left ~ ' '.repeat(left.length < 22 ? 22 - left.length : 1).array.idup ~ o[2] ~ "\n";
    }
    return text;
  }

  /// Run one command line (WITHOUT the program name). Returns the exit code.
  int run(const string[] argv) {
    CliArgs a;
    try {
      a = CliArgs.parse(argv);
      if (a.positional.length == 0) {
        output(usage);
        return a.flag("help") ? 0 : 2;
      }
      if (a.arg(0) == "help") {
        output(usage(a.positional[1 .. $].join(" ")));
        return 0;
      }

      // longest matching command path
      ptrdiff_t best = -1;
      foreach (i, c; commands)
        if (c.path.length <= a.positional.length && a.positional[0 .. c.path.length] == c.path
            && (best < 0 || c.path.length > commands[best].path.length))
          best = i;
      if (best < 0)
        throw new CliUsageError("unknown command '" ~ a.positional.join(" ") ~ "'");
      auto match = commands[best];
      if (a.flag("help")) {
        output(usage(match.name));
        return 0;
      }
      if (match.options !is null)
        foreach (name; a.options.keys)
          if (!match.options.canFind(name) && !globalOptions.any!(o => o[0] == name))
            throw new CliUsageError("unknown option --" ~ name ~ " for '" ~ match.name ~ "'");

      auto request = RequestContext.local(a.opt("tenant", defaultTenant), "cli", a.opt("user", defaultUser));
      auto ctx = new CliContext(a, a.positional[match.path.length .. $].dup, request, output);
      ctx.globalOptions = globalOptions.map!(o => o[0].idup).array;
      return match.handler(ctx);
    } catch (CliUsageError e) {
      errorOutput("error: " ~ e.msg ~ "\nRun '" ~ program ~ " help' for usage.\n");
      return 2;
    } catch (ODataQueryException e) {
      errorOutput("error: invalid query: " ~ e.msg ~ "\n");
      return 2;
    } catch (EntitySetException e) {
      errorOutput("error: " ~ e.msg ~ " (" ~ e.status.to!string ~ " " ~ e.code ~ ")\n");
      return 1;
    } catch (Exception e) {
      errorOutput("error: " ~ e.msg ~ "\n");
      return 1;
    }
  }
}

///
unittest {
  mixin(ShowTest!("CliApplication"));

  string out_;
  auto app = new CliApplication("demo", "Demo", (string s) @safe { out_ ~= s; });
  app.command("greet", "<name>", "Say hello", (CliContext c) @safe {
    c.print("Hello " ~ c.operand(0, "name") ~ " from " ~ c.request.tenantId ~ "\n");
    return 0;
  }, ["loud"]);
  app.command("users list", "", "List users", (CliContext c) @safe => c.done(Json.emptyArray, "no users"));
  app.command("users", "", "Users overview", (CliContext c) @safe => c.done(Json.emptyObject, "overview"));

  assert(app.run(["greet", "Ann", "--tenant=t1"]) == 0);
  assert(out_ == "Hello Ann from t1\n");

  out_ = "";
  assert(app.run(["users", "list"]) == 0 && out_ == "no users\n");
  out_ = "";
  assert(app.run(["users"]) == 0 && out_ == "overview\n");

  out_ = "";
  assert(app.run(["greet"]) == 2 && out_.canFind("missing argument"));
  assert(app.run(["greet", "x", "--bogus=1"]) == 2);
  assert(app.run(["nope"]) == 2);
  assert(app.run([]) == 2);

  out_ = "";
  assert(app.run(["help"]) == 0 && out_.canFind("users list") && out_.canFind("--tenant"));
  out_ = "";
  assert(app.run(["greet", "--help"]) == 0 && out_.canFind("Say hello"));
}
