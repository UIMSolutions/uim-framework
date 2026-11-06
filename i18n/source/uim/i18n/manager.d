/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.manager;

import uim.i18n;

import std.algorithm.searching : canFind;
import std.algorithm.sorting : sort;
import std.array : array;
import std.string : format;

mixin(ShowModule!());

@safe:

/// The outcome of reading one locale from an external system
struct I18nSyncResult {
  /// The locale, empty if the list of locales could not be read
  string locale;
  /// Number of messages that were read
  size_t messages;
  /// What went wrong, empty on success
  string error;

  bool ok() const {
    return error.length == 0;
  }
}

/// Manages the languages of an application and translates its texts.
///
/// A lookup searches the locale, its parents and finally the default locale, so "de_AT" tries
/// "de_AT", "de" and then for example "en". Text that is translated nowhere stays as it is.
///
/// Like all vibe.d objects without explicit locking, a manager belongs to one thread.
class I18nManager {
  this() {
    this.initialize();
  }

  this(string name, Json config = Json(null)) {
    this.initialize(config.set("name", name));
  }

  /// Reads "defaultLocale" from the configuration, which is "en" if it is not set
  bool initialize(Json config = Json(null)) {
    defaultLocale(config.getString("defaultLocale", "en"));
    return true;
  }

  // #region Languages
  protected string _defaultLocale;
  /// The locale that completes every lookup, and the reference for coverage
  string defaultLocale() const {
    return _defaultLocale;
  }

  /// Sets the default locale, and adds it as a language (fluent interface)
  /// Throws: I18nException if the locale is invalid
  auto defaultLocale(string value) {
    addLanguage(value);
    _defaultLocale = normalized(value);
    return this;
  }

  protected I18nCatalog[string] _catalogs;

  /// All languages, sorted
  string[] languages() const {
    return _catalogs.keys.sort.array;
  }

  /// Checks whether a language exists
  bool hasLanguage(string locale) const {
    auto value = normalizeLocale(locale);
    return value.length > 0 && (value in _catalogs) !is null;
  }

  /// Adds a language. An existing language stays as it is.
  /// Returns: the catalog of the language
  /// Throws: I18nException if the locale is invalid
  I18nCatalog addLanguage(string locale) {
    immutable value = normalized(locale);
    if (auto found = value in _catalogs) {
      return *found;
    }
    return _catalogs[value] = new I18nCatalog(value);
  }

  /// Removes a language and all of its messages (fluent interface)
  /// Throws: I18nException for the default locale, which must always exist
  auto removeLanguage(string locale) {
    auto value = normalized(locale);
    if (value == _defaultLocale) {
      throw new I18nException("The default locale '%s' cannot be removed".format(value));
    }
    _catalogs.remove(value);
    return this;
  }

  /// The catalog of a language, or null if the language does not exist
  I18nCatalog catalog(string locale) {
    auto value = normalizeLocale(locale);
    auto found = value in _catalogs;
    return found is null ? null : *found;
  }

  /// Adds the messages of a catalog to the language of the catalog, which is created if necessary.
  /// A catalog without a locale goes to the default locale (fluent interface).
  auto add(I18nCatalog source, I18nMergeMode mode = I18nMergeMode.overwrite) {
    addLanguage(source.locale.length > 0 ? source.locale : _defaultLocale).merge(source, mode);
    return this;
  }

  private string normalized(string locale) const {
    auto value = normalizeLocale(locale);
    if (value.length == 0) {
      throw new I18nException("Invalid locale '%s'".format(locale));
    }
    return value;
  }
  // #endregion Languages

  // #region Translating
  /// The catalogs of a lookup in search order. An unknown or
  /// invalid locale is no error, as it usually comes from a client.
  protected I18nCatalog[] lookupChain(string locale) {
    string[] chain = localeChain(normalizeLocale(locale));
    foreach (candidate; localeChain(_defaultLocale)) {
      if (!chain.canFind(candidate)) {
        chain ~= candidate;
      }
    }

    I18nCatalog[] result;
    foreach (candidate; chain) {
      if (auto found = candidate in _catalogs) {
        result ~= *found;
      }
    }
    return result;
  }

  /// Translates a key. Without a locale, this uses the default locale.
  /// Returns: the translation, or the key if there is none
  string translate(string key, string locale = null, string context = null) {
    foreach (candidate; lookupChain(locale)) {
      if (candidate.has(key, context)) {
        return candidate.get(key, context);
      }
    }
    return key;
  }

  /// Translates a key and replaces the placeholders {0}, {1}, ...
  string translate(string key, string locale, const string[] arguments, string context = null) {
    return formatMessage(translate(key, locale, context), arguments);
  }

  /// Translates a key and replaces named placeholders like {user}
  string translate(string key, string locale, const string[string] arguments, string context = null) {
    return formatMessage(translate(key, locale, context), arguments);
  }

  /// Translates a text that depends on a number, and inserts the number for {n}, {0} and %d.
  ///
  /// Each catalog selects the form by its own plural rule, as its forms belong to its language.
  /// Like ngettext, this falls back to the key for one and to pluralKey for other numbers.
  string translatePlural(string key, string pluralKey, ulong n, string locale = null, string context = null) {
    foreach (candidate; lookupChain(locale)) {
      auto forms = candidate.forms(key, context);
      if (forms.length == 0) {
        continue;
      }
      immutable index = candidate.pluralRule.select(n);
      if (index < forms.length && forms[index].length > 0) {
        return formatPluralMessage(forms[index], n);
      }
    }
    return formatPluralMessage(n == 1 ? key : pluralKey, n);
  }
  // #endregion Translating

  // #region Coverage
  /// The messages of the default locale that a language does not translate itself
  I18nMessage[] missing(string locale) {
    auto target = catalog(locale);
    I18nMessage[] result;
    foreach (message; catalog(_defaultLocale).messages) {
      if (target is null || !target.has(message.key, message.context)) {
        result ~= message;
      }
    }
    return result;
  }

  /// The share of the messages of the default locale that a language translates, from 0 to 1
  double coverage(string locale) {
    immutable total = catalog(_defaultLocale).length;
    return total == 0 ? 1 : cast(double)(total - missing(locale).length) / total;
  }
  // #endregion Coverage

  // #region External systems
  /// Reads translations from an external system.
  ///
  /// Locales are independent of each other: one that fails keeps its messages, and is reported
  /// in the result. So the caller decides if a partial update is good enough. In the mode replace,
  /// an empty result counts as failure, as it more likely is a fault of the system than the truth.
  ///
  /// Params:
  ///   connector = the external system
  ///   locales = the locales to read, by default all locales of the system
  ///   mode = how the messages are combined with existing messages
  /// Returns: one result for each locale, or a single failed result if the system lists no locales
  I18nSyncResult[] sync(I18nConnector connector, const string[] locales = null,
    I18nMergeMode mode = I18nMergeMode.overwrite) {
    string[] wanted = locales.dup;
    if (wanted.length == 0) {
      try {
        wanted = connector.locales();
      } catch (Exception e) {
        return [I18nSyncResult(null, 0, e.msg)];
      }
    }

    I18nSyncResult[] results;
    foreach (locale; wanted) {
      auto value = normalizeLocale(locale);
      if (value.length == 0) {
        results ~= I18nSyncResult(locale, 0, "Invalid locale");
        continue;
      }

      try {
        auto fetched = connector.fetch(value);
        if (mode == I18nMergeMode.replace && fetched.length == 0) {
          results ~= I18nSyncResult(value, 0, "The system delivered no messages");
          continue;
        }
        add(fetched.locale(value), mode);
        results ~= I18nSyncResult(value, fetched.length);
      } catch (Exception e) {
        results ~= I18nSyncResult(value, 0, e.msg);
      }
    }
    return results;
  }
  // #endregion External systems
}

version (unittest) {
  import std.exception : assertThrown;

  private I18nManager sample() {
    auto manager = new I18nManager;
    manager.add(new I18nCatalog("en")
        .set("save", "Save")
        .set("greeting", "Hello {0}")
        .set("named", "Hello {user}")
        .set("open", "Open", "menu")
        .setPlural("file", ["one file", "%d files"])
        .set("only.en", "English"));
    manager.add(new I18nCatalog("de")
        .set("save", "Speichern")
        .set("greeting", "Hallo {0}")
        .set("open", "Öffnen", "menu")
        .setPlural("file", ["eine Datei", "%d Dateien"]));
    manager.add(new I18nCatalog("de_AT").set("save", "Sichern"));
    return manager;
  }

  /// A connector with fixed content, which fails for the locale "xx"
  private class TestConnector : I18nConnector {
    string name() {
      return "test";
    }

    string[] locales() {
      return ["de", "xx", "fr"];
    }

    I18nCatalog fetch(string locale) {
      if (locale == "xx") {
        throw new I18nConnectorException("Service down");
      }
      return new I18nCatalog().set("synced", locale);
    }
  }
}

/// Languages
unittest {
  auto manager = new I18nManager;
  assert(manager.defaultLocale == "en");
  assert(manager.languages == ["en"]);

  auto catalog = manager.addLanguage("de-AT");
  assert(catalog.locale == "de_AT");
  assert(manager.addLanguage("de_at") is catalog);
  assert(manager.hasLanguage("DE_at") && !manager.hasLanguage("fr") && !manager.hasLanguage("../x"));
  assert(manager.languages == ["de_AT", "en"]);
  assert(manager.catalog("de-at") is catalog);
  assert(manager.catalog("fr") is null);
  assert(manager.catalog("../x") is null);

  manager.defaultLocale("fr");
  assert(manager.languages == ["de_AT", "en", "fr"]);

  manager.removeLanguage("en").removeLanguage("es");
  assert(manager.languages == ["de_AT", "fr"]);
  assertThrown!I18nException(manager.removeLanguage("fr"));
  assertThrown!I18nException(manager.addLanguage("../x"));
  assertThrown!I18nException(manager.defaultLocale("../x"));
  assert(manager.defaultLocale == "fr");

  assert(new I18nManager("app", Json.emptyObject.set("defaultLocale", "de-AT")).defaultLocale == "de_AT");
  assert(new I18nManager("app").defaultLocale == "en");
}

/// A catalog without a locale goes to the default locale
unittest {
  auto manager = new I18nManager;
  manager.add(new I18nCatalog().set("a", "b"));
  assert(manager.catalog("en").get("a") == "b");
  assert(manager.languages == ["en"]);
}

/// Lookups
unittest {
  auto manager = sample;
  assert(manager.translate("save") == "Save");
  assert(manager.translate("save", "de") == "Speichern");
  assert(manager.translate("save", "de-AT") == "Sichern");
  assert(manager.translate("greeting", "de_AT") == "Hallo {0}"); // Parent
  assert(manager.translate("only.en", "de_AT") == "English"); // Default locale
  assert(manager.translate("save", "fr") == "Save"); // Unknown language
  assert(manager.translate("save", "../x") == "Save"); // Invalid locale
  assert(manager.translate("unknown text", "de") == "unknown text");

  assert(manager.translate("open", "de", "menu") == "Öffnen");
  assert(manager.translate("open", "de") == "open"); // Other context

  assert(manager.translate("greeting", "de", ["Ada"]) == "Hallo Ada");
  assert(manager.translate("named", "de", ["user": "Ada"]) == "Hello Ada");
}

/// Plurals
unittest {
  auto manager = sample;
  assert(manager.translatePlural("file", "files", 1, "de") == "eine Datei");
  assert(manager.translatePlural("file", "files", 3, "de") == "3 Dateien");
  assert(manager.translatePlural("file", "files", 0, "de") == "0 Dateien");
  assert(manager.translatePlural("file", "files", 3, "de_AT") == "3 Dateien"); // Parent
  assert(manager.translatePlural("x {n}", "xs {n}", 1, "de") == "x 1");
  assert(manager.translatePlural("x {n}", "xs {n}", 2, "de") == "xs 2");

  // Russian needs three forms, and the rule of the language chooses between them
  manager.add(new I18nCatalog("ru").setPlural("file", ["%d файл", "%d файла", "%d файлов"]));
  assert(manager.translatePlural("file", "files", 21, "ru") == "21 файл");
  assert(manager.translatePlural("file", "files", 23, "ru") == "23 файла");
  assert(manager.translatePlural("file", "files", 25, "ru") == "25 файлов");

  // A catalog with too few forms hands over to the next one, which uses its own rule
  manager.add(new I18nCatalog("pl").setPlural("file", ["%d plik"]));
  assert(manager.translatePlural("file", "files", 1, "pl") == "1 plik");
  assert(manager.translatePlural("file", "files", 5, "pl") == "5 files");

  // A plain message serves as the only form
  manager.add(new I18nCatalog("ja").set("file", "%d ファイル"));
  assert(manager.translatePlural("file", "files", 5, "ja") == "5 ファイル");
}

/// Coverage
unittest {
  auto manager = sample;
  assert(manager.coverage("en") == 1);
  assert(manager.missing("en").length == 0);

  auto missing = manager.missing("de");
  assert(missing.length == 2);
  assert(missing[0].key == "named" && missing[1].key == "only.en");
  assert(manager.coverage("de") == 4.0 / 6);
  assert(manager.coverage("fr") == 0);
  assert(manager.missing("fr").length == 6);

  assert(new I18nManager().coverage("de") == 1); // Nothing to translate
}

/// External systems
unittest {
  auto manager = sample;
  auto results = manager.sync(new TestConnector);
  assert(results.length == 3);
  assert(results[0] == I18nSyncResult("de", 1));
  assert(results[1].locale == "xx" && !results[1].ok && results[1].error == "Service down");
  assert(results[2].ok);

  assert(manager.translate("synced", "de") == "de");
  assert(manager.translate("save", "de") == "Speichern"); // Existing messages stay
  assert(manager.translate("synced", "fr") == "fr"); // New languages are created
  assert(!manager.hasLanguage("xx"));

  // Only some locales
  manager = sample;
  results = manager.sync(new TestConnector, ["fr-CA"]);
  assert(results.length == 1 && results[0].locale == "fr_CA" && results[0].ok);
  assert(manager.catalog("fr_CA").get("synced") == "fr_CA");
  assert(!manager.sync(new TestConnector, ["../x"])[0].ok);

  // The mode reaches the catalogs
  manager = sample;
  manager.sync(new TestConnector, ["de"], I18nMergeMode.replace);
  assert(manager.catalog("de").length == 1);
}

/// A failing system does not damage existing messages
unittest {
  class Empty : I18nConnector {
    string name() {
      return "empty";
    }

    string[] locales() {
      throw new I18nConnectorException("No list");
    }

    I18nCatalog fetch(string locale) {
      return new I18nCatalog;
    }
  }

  auto manager = sample;
  auto results = manager.sync(new Empty);
  assert(results.length == 1 && !results[0].ok && results[0].error == "No list");

  results = manager.sync(new Empty, ["de"], I18nMergeMode.replace);
  assert(!results[0].ok);
  assert(manager.catalog("de").length == 4);

  results = manager.sync(new Empty, ["de"]);
  assert(results[0].ok && results[0].messages == 0);
}
