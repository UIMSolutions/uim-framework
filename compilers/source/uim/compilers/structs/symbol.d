module uim.compilers.structs.symbol;

import uim.compilers;

mixin(ShowModule!());

@safe:
/**
 * Symbol representing an identifier in the program.
 */
struct Symbol {
  /// Symbol name
  string name;

  /// Symbol kind
  SymbolKind kind;

  /// Symbol type
  Typeinfo type;

  /// Is the symbol constant?
  bool isConst;

  /// Is the symbol public?
  bool isPublic;

  /// Defining location
  Token location;

  /// Additional attributes
  string[string] attributes;
}