/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.connectors.connector;

import uim.i18n;

mixin(ShowModule!());

@safe:

/// Reads translations from an external system, like a translation management system.
///
/// Implement this interface to connect a system. I18nManager.sync brings the result into the languages.
interface I18nConnector {
  /// A name for messages
  string name();

  /// The locales that the system offers
  /// Throws: I18nConnectorException if the system cannot be reached
  string[] locales();

  /// Reads all messages of a locale
  /// Throws: I18nConnectorException if the system cannot be reached, I18nParseException for bad content
  I18nCatalog fetch(string locale);
}
