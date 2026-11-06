/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.errors;

import std.exception : basicExceptionCtors;

@safe:

/// Base class of all exceptions of this library.
class I18nException : Exception {
  mixin basicExceptionCtors;
}

/// Thrown when the content of a language file cannot be parsed.
class I18nParseException : I18nException {
  mixin basicExceptionCtors;
}

/// Thrown when an external system cannot deliver translations.
class I18nConnectorException : I18nException {
  mixin basicExceptionCtors;
}
