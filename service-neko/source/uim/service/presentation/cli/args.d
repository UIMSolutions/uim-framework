/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Dependency free command line parser: positional arguments, --key=value,
/// --key value, boolean --flag, --no-flag, -h and the "--" terminator.
module uim.service.presentation.cli.args;

import uim.service;

mixin(ShowModule!());

@safe:

/// Wrong command line usage (exit code 2).
class CliUsageError : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__) pure nothrow {
    super(msg, file, line);
  }
}

/// Options that never take a value, so "--json list" keeps "list" positional.
enum string[] defaultCliFlags = ["json", "csv", "help", "yes", "count", "verbose", "quiet"];

struct CliArgs {
  string[] positional;
  string[string] options;

  /// Parse argv WITHOUT the program name.
  static CliArgs parse(const string[] argv, const string[] flags = defaultCliFlags) {
    CliArgs a;
    for (size_t i = 0; i < argv.length; i++) {
      auto arg = argv[i];
      if (arg == "--") {
        a.positional ~= argv[i + 1 .. $].dup;
        break;
      }
      if (arg.startsWith("--") && arg.length > 2) {
        auto name = arg[2 .. $];
        auto eq = name.indexOf('=');
        if (eq >= 0)
          a.options[name[0 .. eq]] = name[eq + 1 .. $];
        else if (name.startsWith("no-") && flags.canFind(name[3 .. $]))
          a.options[name[3 .. $]] = "false";
        else if (flags.canFind(name) || i + 1 >= argv.length || argv[i + 1].startsWith("--"))
          a.options[name] = "true";
        else
          a.options[name] = argv[++i];
      } else if (arg == "-h") {
        a.options["help"] = "true";
      } else {
        a.positional ~= arg;
      }
    }
    return a;
  }

  bool has(string key) const {
    return (key in options) !is null;
  }

  string opt(string key, string fallback = "") const {
    if (auto v = key in options)
      return *v;
    return fallback;
  }

  bool flag(string key) const {
    auto v = opt(key, "false").toLower;
    return v == "true" || v == "1" || v == "yes" || v == "on";
  }

  long intOpt(string key, long fallback) const {
    auto v = opt(key);
    if (v.length == 0)
      return fallback;
    try
      return v.to!long;
    catch (Exception)
      throw new CliUsageError("--" ~ key ~ " expects a number, got '" ~ v ~ "'");
  }

  /// Comma separated list option.
  string[] listOpt(string key) const {
    return opt(key).split(",").map!(s => s.strip).filter!(s => s.length > 0).array;
  }

  /// Positional argument i ("" if missing).
  string arg(size_t i) const {
    return i < positional.length ? positional[i] : "";
  }

  /// Positional argument i, or a usage error.
  string requireArg(size_t i, string what) const {
    auto v = arg(i);
    if (v.length == 0)
      throw new CliUsageError("missing argument: " ~ what);
    return v;
  }

  string requireOpt(string key) const {
    auto v = opt(key);
    if (v.length == 0)
      throw new CliUsageError("missing option: --" ~ key);
    return v;
  }
}

///
unittest {
  mixin(ShowTest!("CliArgs"));

  auto a = CliArgs.parse(["list", "Items", "--tenant", "t1", "--top=5", "--json", "--tags=a, b", "--no-verbose"]);
  assert(a.positional == ["list", "Items"]);
  assert(a.opt("tenant") == "t1");
  assert(a.intOpt("top", 0) == 5);
  assert(a.flag("json") && !a.flag("verbose") && a.has("verbose"));
  assert(a.listOpt("tags") == ["a", "b"]);
  assert(a.arg(5) == "");

  auto b = CliArgs.parse(["--json", "sets", "--", "--literal"]);
  assert(b.flag("json") && b.positional == ["sets", "--literal"]);

  bool failed;
  try
    CliArgs.parse(["--top=x"]).intOpt("top", 0);
  catch (CliUsageError)
    failed = true;
  assert(failed);
}
