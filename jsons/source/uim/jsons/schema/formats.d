/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.schemas.formats;

import uim.jsons;

@safe:

/**
 * Base interface for format validators.
 */
interface DFormatValidator {
  bool validate(string value);
  string formatName();
}

/**
 * Email format validator.
 */
class DEmailFormatValidator : DFormatValidator {
  bool validate(string value) {
    import std.regex : regex, matchFirst;
    auto emailRegex = regex(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return !matchFirst(value, emailRegex).empty;
  }

  string formatName() {
    return "email";
  }
}

/**
 * URI format validator.
 */
class DURIFormatValidator : DFormatValidator {
  bool validate(string value) {
    import std.regex : regex, matchFirst;
    auto uriRegex = regex(r"^[a-z][a-z0-9+.-]*:");
    return !matchFirst(value, uriRegex).empty;
  }

  string formatName() {
    return "uri";
  }
}

/**
 * Date format validator (YYYY-MM-DD).
 */
class DDateFormatValidator : DFormatValidator {
  bool validate(string value) {
    import std.regex : regex, matchFirst;
    auto dateRegex = regex(r"^\d{4}-\d{2}-\d{2}$");
    return !matchFirst(value, dateRegex).empty;
  }

  string formatName() {
    return "date";
  }
}

/**
 * DateTime format validator (ISO 8601).
 */
class DDateTimeFormatValidator : DFormatValidator {
  bool validate(string value) {
    import std.regex : regex, matchFirst;
    auto dateTimeRegex = regex(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}");
    return !matchFirst(value, dateTimeRegex).empty;
  }

  string formatName() {
    return "date-time";
  }
}

/**
 * IPv4 format validator.
 */
class DIPv4FormatValidator : DFormatValidator {
  bool validate(string value) {
    import std.regex : regex, matchFirst;
    auto ipv4Regex = regex(r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
    return !matchFirst(value, ipv4Regex).empty;
  }

  string formatName() {
    return "ipv4";
  }
}

/**
 * IPv6 format validator.
 */
class DIPv6FormatValidator : DFormatValidator {
  bool validate(string value) {
    import std.regex : regex, matchFirst;
    auto ipv6Regex = regex(r"^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4})$");
    return !matchFirst(value, ipv6Regex).empty;
  }

  string formatName() {
    return "ipv6";
  }
}

unittest {
  auto emailValidator = new DEmailFormatValidator();
  assert(emailValidator.validate("test@example.com"));
  assert(!emailValidator.validate("invalid-email"));
  
  auto dateValidator = new DDateFormatValidator();
  assert(dateValidator.validate("2026-01-19"));
  assert(!dateValidator.validate("19-01-2026"));
}
