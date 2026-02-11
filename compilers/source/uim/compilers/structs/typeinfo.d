module uim.compilers.structs.typeinfo;

import uim.compilers;

mixin(ShowModule!());

@safe:
/**
 * Type information for semantic analysis.
 */
struct Typeinfo {
  /// Type name
  string name;

  /// Type kind
  TypeKind kind;

  /// For array types: element type
  Typeinfo* elementType;

  /// For function types: parameter types
  Typeinfo[] parameterTypes;

  /// For function types: return type
  Typeinfo* returnType;

  /// Size in bytes (0 if unknown)
  size_t size;

  /// Is nullable?
  bool nullable;
}