#!/usr/bin/env dub
/+ dub.sdl:
    name "po-example"
    dependency "uim-base:po" path=".."
+/
module po.examples.example;

import std.stdio;
import uim.po;

void main() {
    // Example PO content
    string poContent = `
# Translator comment
#. Extracted comment
#: src/main.d:42
#, fuzzy
msgid ""
msgstr ""
"Project-Id-Version: MyProject 1.0\\n"
"Report-Msgid-Bugs-To: bugs@example.com\\n"































































































}    }        writeln("Error parsing PO file: ", e.msg);    } catch (POParseException e) {                }            writefln("Translation of 'File' (menu context): %s", fileEntry.msgstr[0]);        if (fileEntry !is null) {        auto fileEntry = poFile.findEntry("File", "menu");                }            writefln("Translation of 'Hello, World!': %s", entry.msgstr[0]);        if (entry !is null) {        auto entry = poFile.findEntry("Hello, World!");        writeln("=== Looking up translations ===");        // Example: Look up a specific translation                }            writeln();                        }                writeln("  msgstr: ", entry.msgstr[0]);            } else {                }                    writefln("  msgstr[%d]: %s", j, str);                foreach (j, str; entry.msgstr) {                writeln("  msgid_plural: ", entry.msgidPlural);            if (entry.hasPlural) {                        writeln("  msgid: ", entry.msgid);                        }                writeln("  Context: ", entry.context);            if (entry.context.length > 0) {                        }                writeln("  Flags: ", entry.flags);            if (entry.flags.length > 0) {                        }                writeln("  References: ", entry.references);            if (entry.references.length > 0) {                        }                writeln("  Extracted comments: ", entry.extractedComments);            if (entry.extractedComments.length > 0) {                        }                writeln("  Translator comments: ", entry.translatorComments);            if (entry.translatorComments.length > 0) {                        writefln("Entry %d:", i + 1);        foreach (i, entry; poFile.entries) {                writeln();        writefln("Found %d entries:", poFile.entries.length);        // Display all entries                writeln();        writeln("  Content-Type: ", poFile.getMetadata("Content-Type"));        writeln("  Language: ", poFile.getMetadata("Language"));        writeln("  Project: ", poFile.getMetadata("Project-Id-Version"));        writeln("Header metadata:");        // Display header information                writeln("=== PO File Parser Example ===\n");                auto poFile = POParser.parse(poContent);        // Parse the PO content    try {`;msgstr "%d Ergebnisse gefunden"msgid "Found %d results"#, c-format#: src/utils.d:15 src/helpers.d:23#. This is extracted from the code# Translation with multiple commentsmsgstr[1] "%d Elemente"msgstr[0] "Ein Element"msgid_plural "%d items"msgid "One item"# Plural formsmsgstr "Datei"msgid "File"msgctxt "menu"# Translation with contextmsgstr "Hallo, Welt!"msgid "Hello, World!"# Simple translation"Language: de\\n"
"Content-Type: text/plain; charset=UTF-8\\n"