#!/usr/bin/env dub
/+ dub.sdl:
    name "i18n-example"
    dependency "uim-base:i18n" path="../.."
+/
import std.stdio;
import uim.i18n;

void main() {
    writeln("=== i18n Translation Example ===");
    writeln();
    
    // Create a translator
    auto translator = new Translator("de_DE", "messages");
    
    // Load German translations from string
    string poContent = `msgid ""
msgstr ""
"Language: de\n"

msgid "Hello, World!"
msgstr "Hallo, Welt!"

msgid "Welcome"
msgstr "Willkommen"

msgctxt "menu"
msgid "File"
msgstr "Datei"

msgid "One item"
msgid_plural "%d items"
msgstr[0] "Ein Element"
msgstr[1] "%d Elemente"
`;
    
    translator.loadFromString(poContent);
    
    writeln("--- Simple Translations ---");
    writeln("Hello, World! => ", translator.translate("Hello, World!"));
    writeln("Welcome => ", translator.translate("Welcome"));
    writeln();
    
    writeln("--- Context Translations ---");
    writeln("File (menu) => ", translator.translateContext("File", "menu"));
    writeln();
    
    writeln("--- Plural Translations ---");
    writeln("1 item => ", translator.translatePlural("One item", "%d items", 1));
    writeln("5 items => ", translator.translatePlural("One item", "%d items", 5));
    writeln();
    
    writeln("--- Using Global Functions ---");
    setGlobalTranslator(translator);
    writeln("_('Hello, World!') => ", _("Hello, World!"));
    writeln("_n('One item', '%d items', 3) => ", _n("One item", "%d items", 3));
    writeln();
    
    writeln("=== Example Complete ===");
}
