/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.catalog;

import uim.i18n;

import std.algorithm.iteration : filter;
import std.array : array;

mixin(ShowModule!());

@safe:

/// How the messages of a catalog are combined with the messages that already exist
enum I18nMergeMode {
  /// New messages are added, and replace existing messages with the same key
  overwrite,
  /// New messages are added, existing messages stay
  keepExisting,
  /// All existing messages are dropped first
  replace
}

/// A translatable text
struct I18nMessage {
  /// The identifier, which in gettext files is the source text
  string key;
  /// Separates equal keys with different meanings, like msgctxt in gettext. Empty for most messages.
  string context;
  /// The source text of the plural (msgid_plural), if the file has one
  string pluralKey;
  /// The translation. Plural messages have one entry for each plural form.
  string[] forms;

  /// The translation, or the first form of a plural message
  string text() const {
    return forms.length > 0 ? forms[0] : null;
  }
}

/// All messages of one locale.
class I18nCatalog {
  this(string locale = null) {
    _locale = locale;
  }

  // #region Properties
  /// The locale, e.g. "de_AT". Empty for a catalog that does not know its locale yet.
  string locale() const {
    return _locale;
  }

  /// Sets the locale (fluent interface)
  auto locale(string value) {
    _locale = value;
    _defaultRule = null;
    return this;
  }

  /// The plural rule of the catalog. Without an explicit rule this is the default rule of the locale.
  const(I18nPluralRule) pluralRule() {
    if (_pluralRule !is null) {
      return _pluralRule;
    }
    if (_defaultRule is null) {
      _defaultRule = defaultPluralRule(_locale);
    }
    return _defaultRule;
  }

  /// Sets the plural rule, usually from the header of a gettext file (fluent interface)
  auto pluralRule(I18nPluralRule value) {
    _pluralRule = value;
    return this;
  }

  /// Number of messages
  size_t length() const {
    return _order.length;
  }
  // #endregion Properties

  // #region Messages
  /// Sets a message (fluent interface)
  auto set(string key, string text, string context = null) {
    return add(I18nMessage(key, context, null, [text]));
  }

  /// Sets a plural message with one text for each plural form (fluent interface)
  auto setPlural(string key, const string[] forms, string context = null, string pluralKey = null) {
    return add(I18nMessage(key, context, pluralKey, forms.dup));
  }

  /// Sets a message (fluent interface)
  auto add(I18nMessage message) {
    immutable id = messageId(message.key, message.context);
    if (id !in _messages) {
      _order ~= id;
    }
    _messages[id] = message;
    return this;
  }

  /// Checks whether a message exists
  bool has(string key, string context = null) const {
    return (messageId(key, context) in _messages) !is null;
  }

  /// The text of a message, or null if there is none. For a plural message this is the first form.
  string get(string key, string context = null) const {
    auto found = messageId(key, context) in _messages;
    return found is null ? null : found.text;
  }

  /// All plural forms of a message
  string[] forms(string key, string context = null) const {
    auto found = messageId(key, context) in _messages;
    return found is null ? null : found.forms.dup;
  }

  /// All messages in insertion order
  I18nMessage[] messages() const {
    I18nMessage[] result;
    result.reserve(_order.length);
    foreach (id; _order) {
      const message = _messages[id];
      result ~= I18nMessage(message.key, message.context, message.pluralKey, message.forms.dup);
    }
    return result;
  }

  /// Removes a message (fluent interface)
  auto remove(string key, string context = null) {
    auto id = messageId(key, context);
    if (_messages.remove(id)) {
      _order = _order.filter!(entry => entry != id).array;
    }
    return this;
  }

  /// Removes all messages (fluent interface)
  auto clear() {
    _messages = null;
    _order = null;
    return this;
  }

  /// Copies the messages and the plural rule of another catalog (fluent interface)
  auto merge(I18nCatalog other, I18nMergeMode mode = I18nMergeMode.overwrite) {
    if (other is this) {
      return this;
    }
    if (mode == I18nMergeMode.replace) {
      clear();
      _pluralRule = null;
    }
    foreach (message; other.messages) {
      if (mode != I18nMergeMode.keepExisting || !has(message.key, message.context)) {
        add(message);
      }
    }
    if (other._pluralRule !is null && (mode != I18nMergeMode.keepExisting || _pluralRule is null)) {
      _pluralRule = other._pluralRule;
    }
    return this;
  }
  // #endregion Messages

  /// The same separator that .mo files use between context and key
  private static string messageId(string key, string context) {
    return context.length > 0 ? context ~ "\x04" ~ key : key;
  }

  private string _locale;
  private I18nPluralRule _pluralRule;
  private I18nPluralRule _defaultRule;
  private I18nMessage[string] _messages;
  private string[] _order;
}

/// Messages
unittest {
  auto catalog = new I18nCatalog("de");
  assert(catalog.locale == "de" && catalog.length == 0);

  catalog.set("save", "Speichern").set("open", "Öffnen").set("open", "Offen", "state");
  assert(catalog.length == 3);
  assert(catalog.has("save") && !catalog.has("missing") && !catalog.has("save", "state"));
  assert(catalog.get("open") == "Öffnen");
  assert(catalog.get("open", "state") == "Offen");
  assert(catalog.get("missing") is null);

  catalog.set("save", "Sichern");
  assert(catalog.length == 3 && catalog.get("save") == "Sichern");

  catalog.setPlural("file", ["Datei", "Dateien"]);
  assert(catalog.get("file") == "Datei");
  assert(catalog.forms("file") == ["Datei", "Dateien"]);
  assert(catalog.forms("missing") is null);

  catalog.remove("open");
  assert(!catalog.has("open") && catalog.has("open", "state"));
  catalog.remove("never there");

  string[] keys;
  foreach (message; catalog.messages) {
    keys ~= message.key;
  }
  assert(keys == ["save", "open", "file"]);

  // Results are copies, so they cannot change the catalog
  catalog.messages[0].forms[0] = "changed";
  catalog.forms("file")[0] = "changed";
  assert(catalog.get("save") == "Sichern" && catalog.get("file") == "Datei");
}

/// Plural rules
unittest {
  auto catalog = new I18nCatalog("ru");
  assert(catalog.pluralRule.count == 3);
  catalog.locale("de");
  assert(catalog.pluralRule.count == 2);
  catalog.pluralRule(I18nPluralRule.parse("nplurals=1; plural=0;"));
  assert(catalog.pluralRule.count == 1);
  catalog.locale("ru");
  assert(catalog.pluralRule.count == 1); // An explicit rule does not depend on the locale
}

/// Merging
unittest {
  auto oneForm = I18nPluralRule.parse("nplurals=1; plural=0;");
  auto twoForms = I18nPluralRule.parse("nplurals=2; plural=n>1;");

  I18nCatalog existing() {
    return new I18nCatalog("de").set("a", "old").set("b", "old").pluralRule(oneForm);
  }

  auto incoming = new I18nCatalog("de").set("b", "new").set("c", "new").pluralRule(twoForms);

  auto merged = existing.merge(incoming);
  assert(merged.get("a") == "old" && merged.get("b") == "new" && merged.get("c") == "new");
  assert(merged.pluralRule.count == 2);

  merged = existing.merge(incoming, I18nMergeMode.keepExisting);
  assert(merged.get("a") == "old" && merged.get("b") == "old" && merged.get("c") == "new");
  assert(merged.pluralRule.count == 1);

  merged = existing.merge(incoming, I18nMergeMode.replace);
  assert(!merged.has("a") && merged.get("b") == "new" && merged.length == 2);

  // Replacing also drops a rule that the new content does not bring
  merged = existing.merge(new I18nCatalog("de").set("x", "y"), I18nMergeMode.replace);
  assert(merged.pluralRule.count == 2);

  // A catalog cannot wipe itself
  auto self = existing;
  self.merge(self, I18nMergeMode.replace);
  assert(self.length == 2);
}
