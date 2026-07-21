module scanner.examples.scan_folder;

/++
  Run with:
  dub --single examples/scan_folder.d -- /path/to/source --strict --shallow --compact
+/ 

import std.stdio : stderr, writeln;

import uim.scanner;

void main(string[] args) {
  auto rootPath = args.length > 1 ? args[1] : ".";

  bool recursive = true;
  bool strict = false;
  bool compact = false;

  if (args.length > 2) foreach (arg; args[2 .. $]) {
    switch (arg) {
      case "--shallow":
        recursive = false;
        break;
      case "--strict":
        strict = true;
        break;
      case "--compact":
        compact = true;
        break;
      default:
        stderr.writeln("Unknown argument: ", arg);
        stderr.writeln("Supported: --shallow --strict --compact");
        return;
    }
  }

  DScanOptions options;
  options.strictMode = strict;

  auto scanner = DCodeScannerService();
  auto json = compact
    ? scanner.scanDirectoryAsJson(rootPath, recursive, options)
    : scanner.scanDirectoryAsPrettyJson(rootPath, recursive, options);

  writeln(json);
}
