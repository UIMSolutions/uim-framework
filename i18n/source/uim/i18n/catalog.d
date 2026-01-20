/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.i18n.catalog;

import std.path;
import std.file;
import std.string;
import std.algorithm;
import uim.i18n.translator;

@safe:

/**
 * Manages multiple translation catalogs for different locales and domains
 */
class TranslationCatalog {
    private Translator[string][string] translators; // [locale][domain]
    private string defaultLocale = "en_US";
    private string defaultDomain = "messages";
    private string localeDir;
    
    /**
     * Creates a new translation catalog
     * Params:
     *   localeDir = Base directory containing locale folders
     */
    this(string localeDir) @safe {
        this.localeDir = localeDir;
    }
    
    /**
     * Sets the default locale
     */
    void setDefaultLocale(string locale) @safe {
        this.defaultLocale = locale;
    }
    
    /**
     * Gets the default locale
     */
    string getDefaultLocale() const @safe pure nothrow {
        return defaultLocale;
    }
    
    /**
     * Sets the default domain
     */
    void setDefaultDomain(string domain) @safe {
        this.defaultDomain = domain;
    }
    
    /**
     * Gets the default domain
     */
    string getDefaultDomain() const @safe pure nothrow {
        return defaultDomain;
    }
    
    /**
     * Loads a translation file
     * Params:
     *   locale = The locale to load (e.g., "de_DE")
     *   domain = The domain to load (e.g., "messages")
     * Returns: true if loaded successfully
     */
    bool load(string locale, string domain = null) @trusted {
        if (domain is null) {
            domain = defaultDomain;
        }
        
        // Check if already loaded
        if (locale in translators && domain in translators[locale]) {
            return true;
        }
        
        // Build the path: localeDir/locale/LC_MESSAGES/domain.po
        auto poPath = buildPath(localeDir, locale, "LC_MESSAGES", domain ~ ".po");
        
        if (!exists(poPath)) {
            return false;
        }
        
        auto translator = new Translator(locale, domain);
        translator.loadFromFile(poPath);
        
        // Store translator
        if (locale !in translators) {
            translators[locale] = null;
        }
        translators[locale][domain] = translator;
        
        // Set fallback to default locale if different
        if (locale != defaultLocale && defaultLocale in translators && domain in translators[defaultLocale]) {
            translator.setFallback(translators[defaultLocale][domain]);
        }
        
        return true;
    }
    
    /**
     * Loads all available locales for a domain
     * Params:
     *   domain = The domain to load
     * Returns: Array of successfully loaded locales
     */
    string[] loadAllLocales(string domain = null) @trusted {
        if (domain is null) {
            domain = defaultDomain;
        }
        
        string[] loadedLocales;
        
        if (!exists(localeDir) || !isDir(localeDir)) {
            return loadedLocales;
        }
        
        foreach (entry; dirEntries(localeDir, SpanMode.shallow)) {
            if (entry.isDir) {
                auto locale = baseName(entry.name);
                if (load(locale, domain)) {
                    loadedLocales ~= locale;
                }
            }
        }
        
        return loadedLocales;
    }
    
    /**
     * Gets a translator for a specific locale and domain
     * Params:
     *   locale = The locale
     *   domain = The domain (null for default)
     * Returns: The translator, or null if not found
     */
    Translator getTranslator(string locale, string domain = null) @safe {
        if (domain is null) {
            domain = defaultDomain;
        }
        
        // Try to load if not already loaded
        if (locale !in translators || domain !in translators[locale]) {
            load(locale, domain);
        }
        
        if (locale in translators && domain in translators[locale]) {
            return translators[locale][domain];
        }
        
        return null;
    }
    
    /**
     * Gets the default translator
     */
    Translator getDefaultTranslator() @safe {
        return getTranslator(defaultLocale, defaultDomain);
    }
    
    /**
     * Gets all available locales
     */
    string[] getAvailableLocales() const @safe pure nothrow {
        return translators.keys;
    }
    
    /**
     * Checks if a locale is available
     */
    bool hasLocale(string locale) const @safe pure nothrow {
        return (locale in translators) !is null;
    }
    
    /**
     * Checks if a locale/domain combination is available
     */
    bool has(string locale, string domain = null) const @safe pure nothrow {
        if (domain is null) {
            domain = defaultDomain;
        }
        return hasLocale(locale) && (domain in translators[locale]) !is null;
    }
    
    /**
     * Translates a message using a specific locale
     */
    string translate(string msgid, string locale = null, string domain = null) @trusted {
        if (locale is null) {
            locale = defaultLocale;
        }
        if (domain is null) {
            domain = defaultDomain;
        }
        
        auto translator = getTranslator(locale, domain);
        if (translator !is null) {
            return translator.translate(msgid);
        }
        
        return msgid;
    }
    
    /**
     * Translates a message with context using a specific locale
     */
    string translateContext(string msgid, string context, string locale = null, string domain = null) @trusted {
        if (locale is null) {
            locale = defaultLocale;
        }
        if (domain is null) {
            domain = defaultDomain;
        }
        
        auto translator = getTranslator(locale, domain);
        if (translator !is null) {
            return translator.translateContext(msgid, context);
        }
        
        return msgid;
    }
    
    /**
     * Translates a plural message using a specific locale
     */
    string translatePlural(string msgid, string msgidPlural, long n, string locale = null, string domain = null) @trusted {
        if (locale is null) {
            locale = defaultLocale;
        }
        if (domain is null) {
            domain = defaultDomain;
        }
        
        auto translator = getTranslator(locale, domain);
        if (translator !is null) {
            return translator.translatePlural(msgid, msgidPlural, n);
        }
        
        return n == 1 ? msgid : msgidPlural;
    }
    
    /**
     * Clears all loaded translations
     */
    void clear() @safe {
        translators = null;
    }
    
    /**
     * Clears translations for a specific locale
     */
    void clearLocale(string locale) @safe {
        translators.remove(locale);
    }
}

/// Global translation catalog
private TranslationCatalog g_catalog;

/**
 * Initializes the global translation catalog
 * Params:
 *   localeDir = Base directory containing locale folders
 */
void initTranslations(string localeDir) @safe {
    g_catalog = new TranslationCatalog(localeDir);
}

/**
 * Gets the global translation catalog
 */
TranslationCatalog getTranslationCatalog() @safe {
    return g_catalog;
}

/**
 * Sets the current locale for the global catalog
 */
void setLocale(string locale) @trusted {
    if (g_catalog !is null) {
        g_catalog.setDefaultLocale(locale);
        
        // Update global translator
        auto translator = g_catalog.getDefaultTranslator();
        if (translator !is null) {
            import uim.i18n.translator : setGlobalTranslator;
            setGlobalTranslator(translator);
        }
    }
}

/**
 * Loads translations for the current locale
 */
bool loadTranslations(string locale, string domain = "messages") @trusted {
    if (g_catalog !is null) {
        auto result = g_catalog.load(locale, domain);
        if (result && locale == g_catalog.getDefaultLocale()) {
            // Update global translator
            auto translator = g_catalog.getTranslator(locale, domain);
            if (translator !is null) {
                import uim.i18n.translator : setGlobalTranslator;
                setGlobalTranslator(translator);
            }
        }
        return result;
    }
    return false;
}
