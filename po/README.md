# UIM PO - Portable Object File Parser

A D language library for parsing PO (Portable Object) files used in internationalization and localization with gettext.

## Features

- **Full PO file parsing** - Supports all standard PO file features
- **Comments support** - Translator comments, extracted comments, references, and flags
- **Context support** - Handle msgctxt for disambiguating translations
- **Plural forms** - Full support for msgid_plural and msgstr[n]
- **Header parsing** - Extract metadata from PO file headers
- **Obsolete entries** - Parse entries marked with #~
- **Previous strings** - Support for #| previous context and msgid
- **Safe by default** - Uses @safe annotations where possible

## Usage

### Basic Example

```d
import uim.po;
import std.stdio;

void main() {
    // Parse from string
    auto poFile = POParser.parse(poContent);
    
    // Or parse from file
    // auto poFile = POParser.parseFile("messages.po");
    
    // Access header metadata
    writeln("Language: ", poFile.getMetadata("Language"));
    
    // Iterate through entries
    foreach (entry; poFile.entries) {
        writeln("msgid: ", entry.msgid);
        writeln("msgstr: ", entry.msgstr[0]);
    }
    
    // Look up specific translations
    auto entry = poFile.findEntry("Hello, World!");
    if (entry !is null) {
        writeln("Translation: ", entry.msgstr[0]);
    }
    
    // Look up with context
    auto ctxEntry = poFile.findEntry("File", "menu");
    if (ctxEntry !is null) {
        writeln("Menu File: ", ctxEntry.msgstr[0]);
    }
}
```

### POEntry Structure

```d
struct POEntry {
    string[] translatorComments;   // Lines starting with "# "
    string[] extractedComments;    // Lines starting with "#. "
    string[] references;           // Lines starting with "#: "
    string[] flags;                // Lines starting with "#, "
    string[] previousContext;      // Lines starting with "#| msgctxt"
    string[] previousId;           // Lines starting with "#| msgid"
    string context;                // msgctxt
    string msgid;                  // msgid
    string msgidPlural;            // msgid_plural
    string[] msgstr;               // msgstr or msgstr[n]
    bool obsolete;                 // Lines starting with "#~"
    
    bool isHeader() const;         // Check if entry is the header
    bool hasPlural() const;        // Check if entry has plural forms
}
```

### POFile Structure

```d
struct POFile {
    POEntry header;
    POEntry[] entries;
    
    string getMetadata(string key) const;
    const(POEntry)* findEntry(string msgid) const;
    const(POEntry)* findEntry(string msgid, string context) const;
}
```

## PO File Format

The parser supports the standard Gettext PO file format:

```po
# Translator comment
#. Extracted comment from source code
#: src/main.d:42
#, fuzzy, c-format
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

## Running the Example

```bash
cd examples
dub run
```

## Dependencies

- **uim-base:core** - Core UIM functionality

## License

Apache-2.0

## Author

Ozan Nurettin Süel (aka UIManufaktur)

## Copyright

Copyright © 2018-2026, ONS
