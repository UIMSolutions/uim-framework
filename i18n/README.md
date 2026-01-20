# UIM i18n - Internationalization Library

A comprehensive D language library for internationalization (i18n) and translations using Gettext PO files.

## Features

- **PO File Support** - Uses the uim-base:po parser for reading PO files
- **Multiple Translators** - Create separate translators for different locales and domains
- **Translation Catalog** - Manage multiple locales and domains efficiently
- **Fallback Support** - Chain translators for graceful degradation
- **Context Support** - Disambiguate translations with msgctxt
- **Plural Forms** - Full support for complex plural rules
- **Global Functions** - Convenient shortcuts like `_()`, `_n()`, `_c()`
- **Format Support** - `_f()` and `_nf()` for formatted translations
- **Thread-Safe** - Safe by default with @safe annotations

## Quick Start

### Basic Usage

```d
import uim.i18n;
import std.stdio;

void main() {
    // Create a translator
    auto translator = new Translator("de_DE", "messages");
    translator.loadFromFile("locales/de_DE/LC_MESSAGES/messages.po");
    
    // Use it
    writeln(translator.translate("Hello, World!"));
    // Output: "Hallo, Welt!"
}
```

### Using Global Translator

```d
import uim.i18n;

void main() {
    auto translator = new Translator("de_DE");
    translator.loadFromFile("locales/de_DE/LC_MESSAGES/messages.po");
    
    // Set as global
    setGlobalTranslator(translator);
    
    // Use convenient functions
    writeln(_("Hello, World!"));           // Simple translation
    writeln(_c("File", "menu"));           // With context
    writeln(_n("item", "items", 5));       // Plural
    writeln(_f("Hello, %s!", "Alice"));    // Formatted
}
```

### Using Translation Catalog

```d
import uim.i18n;

void main() {
    // Initialize with locale directory
    // Expected structure: locales/de_DE/LC_MESSAGES/messages.po
    initTranslations("./locales");
    
    // Set locale and load
    setLocale("de_DE");
    loadTranslations("de_DE", "messages");
    
    // Now use global functions
    writeln(_("Welcome"));
}
```

## API Reference

### Translator Class

```d
class Translator {
    // Constructor
    this(string locale, string domain = "messages");
    
    // Load translations
    void loadFromFile(string filename);
    void loadFromString(string content);
    
    // Set fallback
    void setFallback(Translator translator);
    
    // Translation methods
    string translate(string msgid);
    string translateContext(string msgid, string context);
    string translatePlural(string msgid, string msgidPlural, long n);
    string translatePluralContext(string msgid, string msgidPlural, long n, string context);
    
    // Metadata
    string getMetadata(string key) const;
    string getLocale() const;
    string getDomain() const;
    bool hasTranslations() const;
}
```

### Global Functions

```d
// Simple translation
string _(string msgid);

// Translation with context
string _c(string msgid, string context);

// Plural translation
string _n(string msgid, string msgidPlural, long n);

// Plural with context
string _nc(string msgid, string msgidPlural, long n, string context);

// Formatted translation
string _f(Args...)(string msgid, Args args);

// Formatted plural
string _nf(Args...)(string msgid, string msgidPlural, long n, Args args);

// Global translator management
void setGlobalTranslator(Translator translator);
Translator getGlobalTranslator();
```

### TranslationCatalog Class

```d
class TranslationCatalog {
    // Constructor
    this(string localeDir);
    
    // Configuration
    void setDefaultLocale(string locale);
    void setDefaultDomain(string domain);
    string getDefaultLocale() const;
    string getDefaultDomain() const;
    
    // Loading
    bool load(string locale, string domain = null);
    string[] loadAllLocales(string domain = null);
    
    // Access
    Translator getTranslator(string locale, string domain = null);
    Translator getDefaultTranslator();
    string[] getAvailableLocales() const;
    bool hasLocale(string locale) const;
    bool has(string locale, string domain = null) const;
    
    // Translation shortcuts
    string translate(string msgid, string locale = null, string domain = null);
    string translateContext(string msgid, string context, string locale = null, string domain = null);
    string translatePlural(string msgid, string msgidPlural, long n, string locale = null, string domain = null);
    
    // Management
    void clear();
    void clearLocale(string locale);
}
```

### Catalog Functions

```d
// Initialize catalog
void initTranslations(string localeDir);

// Get catalog
TranslationCatalog getTranslationCatalog();

// Set locale (also updates global translator)
void setLocale(string locale);

// Load translations
bool loadTranslations(string locale, string domain = "messages");
```

## Directory Structure

The library expects PO files in a standard Gettext directory structure:

```
locales/
├── de_DE/
│   └── LC_MESSAGES/
│       ├── messages.po
│       └── errors.po
├── fr_FR/
│   └── LC_MESSAGES/
│       └── messages.po
└── en_US/
    └── LC_MESSAGES/
        └── messages.po
```

## PO File Format

```po
# Translator comment
msgid "Hello, World!"
msgstr "Hallo, Welt!"

# With context
msgctxt "menu"
msgid "File"
msgstr "Datei"

# Plural forms
msgid "One item"
msgid_plural "%d items"
msgstr[0] "Ein Element"
msgstr[1] "%d Elemente"
```

## Examples

See the `examples/` directory for complete working examples:

```bash
cd examples
dub run
```

## Dependencies

- **uim-base:core** - Core UIM functionality
- **uim-base:po** - PO file parser

## License

Apache-2.0

## Author

Ozan Nurettin Süel (aka UIManufaktur)

## Copyright

Copyright © 2018-2026, ONS
