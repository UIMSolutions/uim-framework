module uim.core.mixins.version_;

template ShowModule() {
  const char[] ShowModule = `
version (show_module) {
  import std.stdio;
  import std.string;
  import consolecolors;

  unittest {
    string inner = leftJustify(__MODULE__, 156, ' ');
    string outer = "| Loading " ~ inner;
    cwritefln(outer.black.on_white);  
  }
}  
`;
}

template ShowTest(string msg) {
  const char[] ShowTest = `
version (show_test) {
  import std.stdio;
  import std.string;
  import consolecolors;

  string inner = leftJustify("`~msg~`", 154, ' ');
  string outer = "  | Testing " ~ inner;
  cwritefln(outer.black.on_grey);  
}  
`;
}

template ShowInit(string msg) {
  const char[] ShowInit = `
version (show_init) {
  import std.stdio;
  import std.string;
  import consolecolors;

  string inner = leftJustify("`~msg~`", 154, ' ');
  string outer = "  | Initializing " ~ inner;
  cwritefln(outer.black.on_yellow);  
}  
`;
}

template ShowFunction() {
  const char[] ShowFunction = `
version (show_function) {
  import std.stdio;
  import std.string;
  import consolecolors;

  string text = __PRETTY_FUNCTION__.replace("@safe", "").replace("@trusted", "").replace("@system", "");
  string inner = leftJustify(text, 151, ' ');
  string outer = "    | Calling  " ~ inner;
  cwritefln(outer.white.on_blue);  
}  
`;
}