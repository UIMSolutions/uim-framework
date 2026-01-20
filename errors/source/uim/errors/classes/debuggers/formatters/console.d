/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.formatters.console;

mixin(ShowModule!());
import uim.errors;
import std.array : replicate;

@safe:

// Debugger formatter for generating output with ANSI escape codes
class DConsoleErrorFormatter : UIMErrorFormatter {
  mixin(ErrorFormatterThis!("Console"));

  // text colors used in colored output.
  protected string[string] styles = [
    // bold yellow
    "const": "1;33",
    // green
    "string": "0;32",
    // bold blue
    "number": "1;34",
    // cyan
    "class": "0;36",
    // grey
    "punct": "0;90",
    // default foreground
    "property": "0;39",
    // magenta
    "visibility": "0;35",
    // red
    "special": "0;31",
  ];

  // Check if the current environment supports ANSI output.
  static bool environmentMatches() {
    /* if (UIM_SAPI != "cli") {
            return false;
        }
        // NO_COLOR in environment means no color.
        if (enviroment("NO_COLOR")) {
            return false;
        }
        // Windows environment checks
        if (
            DIR_SEPARATOR == "\\" &&
            !D_uname("v").lower.contains("windows 10") &&
            !strtolower((string)enviroment("SHELL")).contains("bash.exe") &&
            !(bool)enviroment("ANSICON") &&
            enviroment("ConEmuANSI") != "ON"
       ) {
            return false;
        }
        return true; */
    return false;
  }

  string formatWrapper(string contents, Json[string] locations) {
    string lineInfo = "";
    if (("file" in locations) && ("line" in locations)) {
      lineInfo = "%s (line %s)".format(locations.getString("file"), locations.getString("line"));
    }

    return [
      style("const", lineInfo),
      style("special", "########## DEBUG ##########"),
      contents,
      style("special", "###########################"),
      "",
    ].join("\n");
  }

  // #region export 
  // Export an array type object
  override protected string exportArray(DArrayErrorNode node, size_t indentLevel) {
    super.exportArray(node, indentLevel);

    if (node is null) {
      return null;
    }
    auto result = style("punct", "[");

    auto items = node.children()
      .map!(item => exportArrayItem(item, indentLevel))
      .array;

    auto closeText = style("punct", "]");
    return result ~ (!items.isEmpty
        ? items.join(style("punct", ",")) ~ endBreak : "") ~ closeText;
  }

  override protected string exportArrayItem(IErrorNode node, size_t indentLevel) {
    if (node is null) {
      return null;
    }

    auto arrowText = style("punct", ": ");
    return startBreak ~ export_(node, indentLevel) ~ arrowText ~ export_(node, indentLevel);
  }

  override protected string exportReference(DReferenceErrorNode node, size_t indentLevel) {
    if (node is null) {
      return null;
    }
    // object(xxx) id: xxx{}
    return style("punct", "object(") ~
      style("class", node.classname) ~
      style("punct", ") id:") ~
      style("number", to!string(node.id())) ~
      style("punct", " {}");
  }

  override protected string exportClass(DClassErrorNode node, size_t indentLevel) {
    string startBreak = "\n" ~ replicate(" ", indentLevel);
    string endBreak = "\n" ~ replicate(" ", indentLevel - 1) ~ style("punct", "}");

    if (node is null) {
      return null;
    }

    string[] props;

    auto result = style("punct", "object(") ~
      style("class", node.classname) ~
      style("punct", ") id:") ~
      style("number", to!string(node.id)) ~ style("punct", " {");

    string[] exportedProperties = node.children
      .map!(prop => exportProperty(cast(DPropertyErrorNode) prop, indentLevel)).array;

    return result ~ (exportedProperties.length > 0
        ? startBreak ~ exportedProperties.join(startBreak) ~ endBreak : style("punct", "}"));
  }

  override protected string exportProperty(DPropertyErrorNode node, size_t indentLevel) {
    if (node is null) {
      return null;
    }

    auto visibility = node.visibility;
    // Get the object name from UIMObject base class
    string nodeName = node.objName();
    auto arrow = style("punct", ": ");

    return visibility != "public"
      ? style("visibility", visibility) ~ " " ~ style("property", nodeName) ~ arrow ~ export_(node.value(), indentLevel)
      : style("property", nodeName) ~ arrow ~ export_(node.value(), indentLevel);
  }

  override protected string exportScalar(DScalarErrorNode node, size_t indentLevel) {
    if (node is null) {
      return null;
    }

    /*  switch (node.getType()) {
        case "bool":
            return style("const", node.getBoolean() ? "true" : "false");
        case "null":
            return style("const", "null");
        case "string":
            return style("string", "'" ~ node.getString() ~ "'");
        case "int", "float":
            return style("visibility", "({node.getType()})") ~ " " ~ style("number", "{node.value()}");
        default:
            return "({node.getType()}) {node.value()}";
        }; */
    return null;
  }

  override protected string exportSpecial(DSpecialErrorNode node, size_t indentLevel) {
    if (node is null) {
      return null;
    }
    return null;
  }
  // #endregion export 

  // Style text with ANSI escape codes.
  protected string style(string styleToUse, string textToStyle) {
    /* auto code = _styles[styleToUse];
        return "\033[{code}m{textToStyle}\033[0m"; */
    return null;
  }
}
