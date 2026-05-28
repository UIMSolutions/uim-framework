/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sql.helpers.dialect;

@safe:

enum SqlDialect { generic, mysql, postgresql, sqlite, mssql }

/// Returns the dialect-appropriate quoted identifier to prevent injection
/// in column/table names supplied programmatically.
string quoteIdentifier(string name, SqlDialect dialect = SqlDialect.generic) pure @safe {
  import std.string : replace;
  final switch (dialect) {
    case SqlDialect.mysql:
      return "`" ~ name.replace("`", "``") ~ "`";
    case SqlDialect.generic:
    case SqlDialect.postgresql:
    case SqlDialect.sqlite:
      return `"` ~ name.replace(`"`, `""`) ~ `"`;
    case SqlDialect.mssql:
      return "[" ~ name.replace("]", "]]") ~ "]";
  }
}

/// Returns the positional parameter placeholder for the given dialect.
string placeholderFor(int index, SqlDialect dialect = SqlDialect.generic) pure @safe {
  import std.conv : to;
  final switch (dialect) {
    case SqlDialect.postgresql:
      return "$" ~ index.to!string;
    case SqlDialect.generic:
    case SqlDialect.mysql:
    case SqlDialect.sqlite:
    case SqlDialect.mssql:
      return "?";
  }
}

unittest {
  assert(quoteIdentifier("users") == `"users"`);
  assert(quoteIdentifier("tab\"le", SqlDialect.generic) == `"tab""le"`);
  assert(quoteIdentifier("col", SqlDialect.mysql) == "`col`");
  assert(quoteIdentifier("col", SqlDialect.mssql) == "[col]");

  assert(placeholderFor(1, SqlDialect.postgresql) == "$1");
  assert(placeholderFor(2, SqlDialect.postgresql) == "$2");
  assert(placeholderFor(1, SqlDialect.mysql) == "?");
  assert(placeholderFor(1, SqlDialect.generic) == "?");
}
