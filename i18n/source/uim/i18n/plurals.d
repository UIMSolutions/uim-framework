/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.plurals;

import uim.i18n;

import std.array : split;
import std.conv : ConvException, to;
import std.string : format, indexOf, strip, toLower;

mixin(ShowModule!());

@safe:

/// Most plural forms of a rule. No language comes close to this.
enum size_t maxPluralForms = 64;

/// Longest accepted Plural-Forms expression. The rule comes from uploaded files, and the longest
/// rule of a real language has less than 100 characters.
enum size_t maxPluralExpressionLength = 1024;

/// Deepest accepted nesting of a Plural-Forms expression, as the parser recurses and fibers have small stacks
enum int maxPluralExpressionDepth = 32;

private enum Operation {
  constant,
  variable,
  not,
  multiply,
  divide,
  modulo,
  add,
  subtract,
  less,
  lessEqual,
  greater,
  greaterEqual,
  equal,
  notEqual,
  and,
  or,
  conditional
}

private struct Node {
  Operation operation;
  ulong value;
  size_t first;
  size_t second;
  size_t third;
}

/// A rule that selects the plural form for a number, as written in the Plural-Forms header of a
/// gettext file: "nplurals=2; plural=(n != 1);"
final class I18nPluralRule {
  /// Parses a Plural-Forms value.
  /// Throws: I18nParseException if the value is malformed
  static I18nPluralRule parse(string definition) {
    string count, expression;
    foreach (field; definition.split(";")) {
      auto separator = field.indexOf('=');
      if (separator < 0) {
        if (field.strip.length > 0) {
          throw new I18nParseException("Invalid plural rule '%s'".format(definition));
        }
        continue;
      }
      auto value = field[separator + 1 .. $].strip;
      switch (field[0 .. separator].strip.toLower) {
        case "nplurals":
          count = value;
          break;
        case "plural":
          expression = value;
          break;
        default:
          throw new I18nParseException("Invalid plural rule '%s'".format(definition));
      }
    }

    size_t forms;
    try {
      forms = count.to!size_t;
    } catch (ConvException) {
      throw new I18nParseException("Invalid nplurals in plural rule '%s'".format(definition));
    }
    if (forms == 0 || forms > maxPluralForms) {
      throw new I18nParseException("Invalid nplurals in plural rule '%s'".format(definition));
    }
    if (expression.length == 0 || expression.length > maxPluralExpressionLength) {
      throw new I18nParseException("Invalid expression in plural rule '%s'".format(definition));
    }

    auto parser = ExpressionParser(expression);
    auto rule = new I18nPluralRule;
    rule._count = forms;
    rule._root = parser.parse();
    rule._nodes = parser.nodes;
    return rule;
  }

  /// Number of plural forms
  size_t count() const {
    return _count;
  }

  /// The index of the plural form for n. Like gettext, this gives 0 if the expression
  /// yields a form that the rule does not have.
  size_t select(ulong n) const {
    immutable result = evaluate(_root, n);
    return result < _count ? cast(size_t)result : 0;
  }

  // Unsigned like gettext, so that no operation can overflow into a trap
  private ulong evaluate(size_t index, ulong n) const {
    const node = _nodes[index];
    final switch (node.operation) {
      case Operation.constant:
        return node.value;
      case Operation.variable:
        return n;
      case Operation.not:
        return evaluate(node.first, n) == 0;
      case Operation.and:
        return evaluate(node.first, n) != 0 && evaluate(node.second, n) != 0;
      case Operation.or:
        return evaluate(node.first, n) != 0 || evaluate(node.second, n) != 0;
      case Operation.conditional:
        return evaluate(evaluate(node.first, n) != 0 ? node.second : node.third, n);
      case Operation.multiply:
        return evaluate(node.first, n) * evaluate(node.second, n);
      case Operation.divide:
        immutable divisor = evaluate(node.second, n);
        return divisor == 0 ? 0 : evaluate(node.first, n) / divisor; // Would kill the process otherwise
      case Operation.modulo:
        immutable divisor = evaluate(node.second, n);
        return divisor == 0 ? 0 : evaluate(node.first, n) % divisor;
      case Operation.add:
        return evaluate(node.first, n) + evaluate(node.second, n);
      case Operation.subtract:
        return evaluate(node.first, n) - evaluate(node.second, n);
      case Operation.less:
        return evaluate(node.first, n) < evaluate(node.second, n);
      case Operation.lessEqual:
        return evaluate(node.first, n) <= evaluate(node.second, n);
      case Operation.greater:
        return evaluate(node.first, n) > evaluate(node.second, n);
      case Operation.greaterEqual:
        return evaluate(node.first, n) >= evaluate(node.second, n);
      case Operation.equal:
        return evaluate(node.first, n) == evaluate(node.second, n);
      case Operation.notEqual:
        return evaluate(node.first, n) != evaluate(node.second, n);
    }
  }

  private size_t _count;
  private size_t _root;
  private Node[] _nodes;
}

/// Recursive descent parser for the C subset of Plural-Forms expressions
private struct ExpressionParser {
  string text;
  size_t position;
  int depth;
  Node[] nodes;

  this(string expression) {
    text = expression;
  }

  size_t parse() {
    immutable root = parseConditional();
    skipSpace();
    if (position != text.length) {
      fail();
    }
    return root;
  }

  private void fail() {
    throw new I18nParseException("Invalid plural expression '%s'".format(text));
  }

  private void enter() {
    if (++depth > maxPluralExpressionDepth) {
      throw new I18nParseException("Plural expression is nested too deeply");
    }
  }

  private size_t add(Operation operation, ulong value = 0, size_t first = 0, size_t second = 0, size_t third = 0) {
    nodes ~= Node(operation, value, first, second, third);
    return nodes.length - 1;
  }

  private void skipSpace() {
    while (position < text.length && (text[position] == ' ' || text[position] == '\t'
        || text[position] == '\n' || text[position] == '\r')) {
      position++;
    }
  }

  private bool accept(char c) {
    skipSpace();
    if (position < text.length && text[position] == c) {
      position++;
      return true;
    }
    return false;
  }

  private size_t parseConditional() {
    enter();
    scope (exit) depth--;

    immutable condition = parseBinary(0);
    if (!accept('?')) {
      return condition;
    }
    immutable whenTrue = parseConditional();
    if (!accept(':')) {
      fail();
    }
    immutable whenFalse = parseConditional();
    return add(Operation.conditional, 0, condition, whenTrue, whenFalse);
  }

  /// Reads a binary operator of at least the given precedence
  private bool acceptOperator(int minimum, out Operation operation, out int precedence) {
    static struct Entry {
      string symbol;
      Operation operation;
      int precedence;
    }

    // Longer symbols first, so that "<=" is not read as "<"
    static immutable Entry[] operators = [
      Entry("||", Operation.or, 0), Entry("&&", Operation.and, 1),
      Entry("==", Operation.equal, 2), Entry("!=", Operation.notEqual, 2),
      Entry("<=", Operation.lessEqual, 3), Entry(">=", Operation.greaterEqual, 3),
      Entry("<", Operation.less, 3), Entry(">", Operation.greater, 3),
      Entry("+", Operation.add, 4), Entry("-", Operation.subtract, 4),
      Entry("*", Operation.multiply, 5), Entry("/", Operation.divide, 5), Entry("%", Operation.modulo, 5),
    ];

    skipSpace();
    foreach (entry; operators) {
      immutable end = position + entry.symbol.length;
      if (end <= text.length && text[position .. end] == entry.symbol) {
        if (entry.precedence < minimum) {
          return false;
        }
        position = end;
        operation = entry.operation;
        precedence = entry.precedence;
        return true;
      }
    }
    return false;
  }

  private size_t parseBinary(int minimum) {
    auto left = parseUnary();
    Operation operation;
    int precedence;
    while (acceptOperator(minimum, operation, precedence)) {
      immutable right = parseBinary(precedence + 1);
      left = add(operation, 0, left, right);
    }
    return left;
  }

  private size_t parseUnary() {
    enter();
    scope (exit) depth--;

    if (accept('!')) {
      return add(Operation.not, 0, parseUnary());
    }
    if (accept('(')) {
      immutable inner = parseConditional();
      if (!accept(')')) {
        fail();
      }
      return inner;
    }
    if (accept('n')) {
      return add(Operation.variable);
    }

    skipSpace();
    immutable start = position;
    ulong value;
    while (position < text.length && text[position] >= '0' && text[position] <= '9') {
      if (position - start >= 18) {
        fail(); // Would overflow, and no real rule has such a constant
      }
      value = value * 10 + (text[position] - '0');
      position++;
    }
    if (position == start) {
      fail();
    }
    return add(Operation.constant, value);
  }
}

/// The plural rule of a locale, for files that do not bring their own.
/// Languages that are not listed get the rule of English, which is also the default of gettext.
I18nPluralRule defaultPluralRule(string locale) {
  string definition;
  switch (localeLanguage(locale)) {
    case "id":
    case "ja":
    case "ko":
    case "th":
    case "vi":
    case "zh":
      definition = "nplurals=1; plural=0;";
      break;
    case "fr":
      definition = "nplurals=2; plural=(n > 1);";
      break;
    case "ru":
    case "uk":
      definition = "nplurals=3; plural=(n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2);";
      break;
    case "pl":
      definition = "nplurals=3; plural=(n==1 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2);";
      break;
    case "cs":
    case "sk":
      definition = "nplurals=3; plural=(n==1 ? 0 : n>=2 && n<=4 ? 1 : 2);";
      break;
    case "ar":
      definition = "nplurals=6; plural=(n==0 ? 0 : n==1 ? 1 : n==2 ? 2 : n%100>=3 && n%100<=10 ? 3 : n%100>=11 ? 4 : 5);";
      break;
    default:
      definition = "nplurals=2; plural=(n != 1);";
  }
  return I18nPluralRule.parse(definition);
}

/// Common rules
unittest {
  auto english = I18nPluralRule.parse("nplurals=2; plural=(n != 1);");
  assert(english.count == 2);
  assert(english.select(0) == 1 && english.select(1) == 0 && english.select(2) == 1);

  auto japanese = I18nPluralRule.parse("nplurals=1; plural=0;");
  assert(japanese.count == 1 && japanese.select(7) == 0);

  auto russian = defaultPluralRule("ru_RU");
  assert(russian.count == 3);
  foreach (n; [1, 21, 101, 1001]) {
    assert(russian.select(n) == 0);
  }
  foreach (n; [2, 3, 4, 22, 104]) {
    assert(russian.select(n) == 1);
  }
  foreach (n; [0, 5, 11, 12, 14, 19, 100, 111]) {
    assert(russian.select(n) == 2);
  }

  auto arabic = defaultPluralRule("ar");
  assert(arabic.count == 6);
  size_t[] forms;
  foreach (n; [0, 1, 2, 3, 11, 100]) {
    forms ~= arabic.select(n);
  }
  assert(forms == [0, 1, 2, 3, 4, 5]);

  assert(defaultPluralRule("fr").select(0) == 0);
  assert(defaultPluralRule("de").select(0) == 1);
  assert(defaultPluralRule(null).count == 2);
}

/// Precedence and syntax
unittest {
  size_t evaluate(string expression, ulong n = 0) {
    return I18nPluralRule.parse("nplurals=64; plural=" ~ expression ~ ";").select(n);
  }

  assert(evaluate("2 + 3 * 4") == 14);
  assert(evaluate("(2 + 3) * 4") == 20);
  assert(evaluate("10 - 3 - 2") == 5); // Left to right
  assert(evaluate("20 / 2 / 5") == 2);
  assert(evaluate("7 % 4 + 1") == 4);
  assert(evaluate("1 < 2 == 1") == 1);
  assert(evaluate("1 || 0 && 0") == 1);
  assert(evaluate("!0") == 1 && evaluate("!!5") == 1);
  assert(evaluate("1 ? 2 : 3") == 2);
  assert(evaluate("0 ? 2 : 0 ? 3 : 4") == 4); // Right to left
  assert(evaluate("n>=2&&n<=4?1:2", 3) == 1);
  assert(evaluate("n", 5) == 5);

  // Case and spaces of the header do not matter
  assert(I18nPluralRule.parse(" NPlurals = 2 ;\tPLURAL = n>1").count == 2);
}

/// Hostile rules cannot crash the process or leave the range of forms
unittest {
  import std.array : replicate;
  import std.exception : assertThrown;

  // Division by zero is a hardware trap in D, which no exception handler catches
  assert(I18nPluralRule.parse("nplurals=2; plural=1/0;").select(1) == 0);
  assert(I18nPluralRule.parse("nplurals=2; plural=1%0;").select(1) == 0);
  assert(I18nPluralRule.parse("nplurals=2; plural=1/(n-n);").select(5) == 0);
  // Form out of range, or a wrap-around of the unsigned arithmetic
  assert(I18nPluralRule.parse("nplurals=2; plural=7;").select(1) == 0);
  assert(I18nPluralRule.parse("nplurals=2; plural=n-5;").select(1) == 0);
  assert(I18nPluralRule.parse("nplurals=2; plural=n*n;").select(ulong.max) == 1);

  foreach (bad; [
      "", "nplurals=2", "plural=n", "nplurals=0; plural=0;", "nplurals=65; plural=0;", "nplurals=x; plural=0;",
      "nplurals=-1; plural=0;", "nplurals=2; plural=;", "nplurals=2; plural=(n;", "nplurals=2; plural=n);",
      "nplurals=2; plural=1 +;", "nplurals=2; plural=n ? 1;", "nplurals=2; plural=x;", "nplurals=2; plural=n n;",
      "nplurals=2; plural=99999999999999999999;", "nplurals=2; plural=0; other=1;", "nonsense",
    ]) {
    assertThrown!I18nParseException(I18nPluralRule.parse(bad), bad);
  }

  // Depth and length limits, which keep the recursion away from the end of a fiber stack
  assertThrown!I18nParseException(I18nPluralRule.parse("nplurals=2; plural=" ~ "(".replicate(500) ~ "n" ~ ")".replicate(500)));
  assertThrown!I18nParseException(I18nPluralRule.parse("nplurals=2; plural=" ~ "!".replicate(500) ~ "n"));
  assertThrown!I18nParseException(I18nPluralRule.parse("nplurals=2; plural=" ~ "n?1:".replicate(200) ~ "0"));
  assertThrown!I18nParseException(I18nPluralRule.parse("nplurals=2; plural=" ~ "n+".replicate(1000) ~ "n"));
  assert(I18nPluralRule.parse("nplurals=2; plural=" ~ "n+".replicate(400) ~ "n").select(0) == 0);
}
