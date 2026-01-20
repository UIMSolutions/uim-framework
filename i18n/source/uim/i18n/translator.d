/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.i18n.translator;

import std.string;
import std.format;
import std.conv;
import uim.po;

@safe:

/**
 * Translator class that handles translation of messages using PO files
 */
class Translator {
    private POFile poFile;
    private string locale;
    private string domain;
    private Translator fallbackTranslator;
    
    /**
     * Creates a new translator
     * Params:
     *   locale = The locale code (e.g., "de_DE", "en_US")
     *   domain = The translation domain (e.g., "messages", "app")
     */
    this(string locale, string domain = "messages") @safe {
        this.locale = locale;
        this.domain = domain;
    }
    
    /**
     * Loads translations from a PO file
     * Params:
     *   filename = Path to the PO file
     */
    void loadFromFile(string filename) @trusted {
        poFile = POParser.parseFile(filename);
    }
    
    /**
     * Loads translations from a PO string
     * Params:
     *   content = PO file content as string
     */
    void loadFromString(string content) @trusted {
        poFile = POParser.parse(content);
    }
    
    /**
     * Sets a fallback translator for missing translations
     * Params:
     *   translator = The fallback translator to use
     */
    void setFallback(Translator translator) @safe {
        this.fallbackTranslator = translator;
    }
    
    /**
     * Translates a message
     * Params:
     *   msgid = The message ID to translate
     * Returns: The translated string, or the original msgid if not found
     */
    string translate(string msgid) @trusted {
        auto entry = poFile.findEntry(msgid);
        if (entry !is null && entry.msgstr.length > 0 && entry.msgstr[0].length > 0) {
            return entry.msgstr[0];
        }
        
        // Try fallback translator
        if (fallbackTranslator !is null) {
            return fallbackTranslator.translate(msgid);
        }
        
        return msgid;
    }
    
    /**
     * Translates a message with context
     * Params:
     *   msgid = The message ID to translate
     *   context = The message context
     * Returns: The translated string, or the original msgid if not found
     */
    string translateContext(string msgid, string context) @trusted {
        auto entry = poFile.findEntry(msgid, context);
        if (entry !is null && entry.msgstr.length > 0 && entry.msgstr[0].length > 0) {
            return entry.msgstr[0];
        }
        
        // Try fallback translator
        if (fallbackTranslator !is null) {
            return fallbackTranslator.translateContext(msgid, context);
        }
        
        return msgid;
    }
    
    /**
     * Translates a plural message
     * Params:
     *   msgid = The singular message ID
     *   msgidPlural = The plural message ID
     *   n = The count to determine which plural form to use
     * Returns: The appropriate translated plural form
     */
    string translatePlural(string msgid, string msgidPlural, long n) @trusted {
        auto entry = poFile.findEntry(msgid);
        if (entry !is null && entry.hasPlural && entry.msgstr.length > 0) {
            auto pluralIndex = getPluralIndex(n);
            if (pluralIndex < entry.msgstr.length && entry.msgstr[pluralIndex].length > 0) {
                return entry.msgstr[pluralIndex];
            }
        }
        
        // Try fallback translator
        if (fallbackTranslator !is null) {
            return fallbackTranslator.translatePlural(msgid, msgidPlural, n);
        }
        
        // Default plural form selection
        return n == 1 ? msgid : msgidPlural;
    }
    
    /**
     * Translates a plural message with context
     * Params:
     *   msgid = The singular message ID
     *   msgidPlural = The plural message ID
     *   n = The count to determine which plural form to use
     *   context = The message context
     * Returns: The appropriate translated plural form
     */
    string translatePluralContext(string msgid, string msgidPlural, long n, string context) @trusted {
        auto entry = poFile.findEntry(msgid, context);
        if (entry !is null && entry.hasPlural && entry.msgstr.length > 0) {
            auto pluralIndex = getPluralIndex(n);
            if (pluralIndex < entry.msgstr.length && entry.msgstr[pluralIndex].length > 0) {
                return entry.msgstr[pluralIndex];
            }
        }
        
        // Try fallback translator
        if (fallbackTranslator !is null) {
            return fallbackTranslator.translatePluralContext(msgid, msgidPlural, n, context);
        }
        
        // Default plural form selection
        return n == 1 ? msgid : msgidPlural;
    }
    
    /**
     * Determines which plural form to use based on the count
     * This uses a simplified plural rule that works for many languages
     * Override this method for more complex plural rules
     */
    protected size_t getPluralIndex(long n) @safe pure nothrow {
        // Simple rule: 0 -> form 1, 1 -> form 0, n > 1 -> form 1
        // This works for English and German
        return (n == 1) ? 0 : 1;
    }
    
    /**
     * Gets the current locale
     */
    @property string getLocale() const @safe pure nothrow {
        return locale;
    }
    
    /**
     * Gets the current domain
     */
    @property string getDomain() const @safe pure nothrow {
        return domain;
    }
    
    /**
     * Gets metadata from the PO file header
     */
    string getMetadata(string key) const @trusted {
        return poFile.getMetadata(key);
    }
    
    /**
     * Checks if the translator has translations loaded
     */
    bool hasTranslations() const @safe pure nothrow {
        return poFile.entries.length > 0;
    }
}

/**
 * Convenience functions for translation
 */

/// Global default translator instance
private Translator g_translator;

/**
 * Sets the global translator
 */
void setGlobalTranslator(Translator translator) @safe {
    g_translator = translator;
}

/**
 * Gets the global translator
 */
Translator getGlobalTranslator() @safe {
    return g_translator;
}

/**
 * Translates a message using the global translator
 * Params:
 *   msgid = The message ID to translate
 * Returns: The translated string
 */
string _(string msgid) @trusted {
    if (g_translator is null) {
        return msgid;
    }
    return g_translator.translate(msgid);
}

/**
 * Translates a message with context using the global translator
 * Params:
 *   msgid = The message ID to translate
 *   context = The message context
 * Returns: The translated string
 */
string _c(string msgid, string context) @trusted {
    if (g_translator is null) {
        return msgid;
    }
    return g_translator.translateContext(msgid, context);
}

/**
 * Translates a plural message using the global translator
 * Params:
 *   msgid = The singular message ID
 *   msgidPlural = The plural message ID
 *   n = The count
 * Returns: The translated string
 */
string _n(string msgid, string msgidPlural, long n) @trusted {
    if (g_translator is null) {
        return n == 1 ? msgid : msgidPlural;
    }
    return g_translator.translatePlural(msgid, msgidPlural, n);
}

/**
 * Translates a plural message with context using the global translator
 * Params:
 *   msgid = The singular message ID
 *   msgidPlural = The plural message ID
 *   n = The count
 *   context = The message context
 * Returns: The translated string
 */
string _nc(string msgid, string msgidPlural, long n, string context) @trusted {
    if (g_translator is null) {
        return n == 1 ? msgid : msgidPlural;
    }
    return g_translator.translatePluralContext(msgid, msgidPlural, n, context);
}

/**
 * Formats a translated message with arguments
 * Params:
 *   msgid = The message ID to translate
 *   args = Format arguments
 * Returns: The formatted translated string
 */
string _f(Args...)(string msgid, Args args) @trusted {
    auto translated = _(msgid);
    return format(translated, args);
}

/**
 * Formats a translated plural message with arguments
 * Params:
 *   msgid = The singular message ID
 *   msgidPlural = The plural message ID
 *   n = The count
 *   args = Format arguments
 * Returns: The formatted translated string
 */
string _nf(Args...)(string msgid, string msgidPlural, long n, Args args) @trusted {
    auto translated = _n(msgid, msgidPlural, n);
    return format(translated, args);
}
