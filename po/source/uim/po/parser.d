/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.po.parser;

import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.exception;

@safe:

/**
 * Represents a single message entry in a PO file
 */
struct POEntry {
    string[] translatorComments;      // Lines starting with "# "
    string[] extractedComments;       // Lines starting with "#. "
    string[] references;              // Lines starting with "#: "
    string[] flags;                   // Lines starting with "#, "
    string[] previousContext;         // Lines starting with "#| msgctxt"
    string[] previousId;              // Lines starting with "#| msgid"
    string context;                   // msgctxt
    string msgid;                     // msgid
    string msgidPlural;               // msgid_plural
    string[] msgstr;                  // msgstr or msgstr[n]
    bool obsolete;                    // Lines starting with "#~"
    
    /**
     * Checks if this entry represents the header
     */
    bool isHeader() const pure nothrow {
        return msgid.length == 0;
    }
    
    /**
     * Checks if this entry has a plural form
     */
    bool hasPlural() const pure nothrow {
        return msgidPlural.length > 0;
    }
}

/**
 * Represents a parsed PO file with all its entries
 */
struct POFile {
    POEntry header;
    POEntry[] entries;
    
    /**
     * Gets the value of a metadata field from the header
     */
    string getMetadata(string key) const {
        if (header.msgstr.length == 0) return null;
        
        foreach (line; header.msgstr) {
            if (line.startsWith(key ~ ":")) {
                return line[key.length + 1 .. $].strip;
            }
        }
        return null;
    }
    
    /**
     * Finds the index of an entry by msgid
     * Returns: The index of the entry, or -1 if not found
     */
    ptrdiff_t findEntryIndex(string msgid) const pure nothrow @safe {
        foreach (i, ref entry; entries) {
            if (entry.msgid == msgid) {
                return i;
            }
        }
        return -1;
    }
    
    /**
     * Finds the index of an entry by msgid and context
     * Returns: The index of the entry, or -1 if not found
     */
    ptrdiff_t findEntryIndex(string msgid, string context) const pure nothrow @safe {
        foreach (i, ref entry; entries) {
            if (entry.msgid == msgid && entry.context == context) {
                return i;
            }
        }
        return -1;
    }
    
    /**
     * Finds an entry by msgid
     * Returns: Pointer to the entry, or null if not found
     */
    inout(POEntry)* findEntry(string msgid) inout @trusted {
        auto idx = findEntryIndex(msgid);
        if (idx >= 0) {
            return &entries[idx];
        }
        return null;
    }
    
    /**
     * Finds an entry by msgid and context
     * Returns: Pointer to the entry, or null if not found
     */
    inout(POEntry)* findEntry(string msgid, string context) inout @trusted {
        auto idx = findEntryIndex(msgid, context);
        if (idx >= 0) {
            return &entries[idx];
        }
        return null;
    }
}

/**
 * Exception thrown when PO file parsing fails
 */
class POParseException : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) pure nothrow @nogc @safe {
        super(msg, file, line);
    }
}

/**
 * Parser for PO (Portable Object) files
 */
class POParser {
    private string[] lines;
    private size_t currentLine;
    
    /**
     * Parse a PO file from a string
     */
    static POFile parse(string content) @trusted {
        auto parser = new POParser(content);
        return parser.parseFile();
    }
    
    /**
     * Parse a PO file from a file path
     */
    static POFile parseFile(string filename) @trusted {
        import std.file : readText;
        return parse(readText(filename));
    }
    
    private this(string content) @trusted {
        lines = content.split("\n");
        currentLine = 0;
    }
    
    private POFile parseFile() @trusted {
        POFile result;
        POEntry[] allEntries;
        
        while (currentLine < lines.length) {
            skipEmptyLines();
            if (currentLine >= lines.length) break;
            
            auto entry = parseEntry();
            if (entry.isHeader) {
                result.header = entry;
            } else {
                allEntries ~= entry;
            }
        }
        
        result.entries = allEntries;
        return result;
    }
    
    private POEntry parseEntry() @trusted {
        POEntry entry;
        
        // Parse comments
        while (currentLine < lines.length && lines[currentLine].strip.startsWith("#")) {
            parseComment(entry, lines[currentLine].strip);
            currentLine++;
        }
        
        // Parse context
        if (currentLine < lines.length && lines[currentLine].strip.startsWith("msgctxt")) {
            entry.context = parseString("msgctxt");
        }
        
        // Parse msgid
        if (currentLine < lines.length && lines[currentLine].strip.startsWith("msgid")) {
            entry.msgid = parseString("msgid");
        }
        
        // Parse msgid_plural
        if (currentLine < lines.length && lines[currentLine].strip.startsWith("msgid_plural")) {
            entry.msgidPlural = parseString("msgid_plural");
        }
        
        // Parse msgstr or msgstr[n]
        if (currentLine < lines.length && lines[currentLine].strip.startsWith("msgstr")) {
            if (entry.hasPlural) {
                entry.msgstr = parsePluralStrings();
            } else {
                entry.msgstr = [parseString("msgstr")];
            }
        }
        
        return entry;
    }
    
    private void parseComment(ref POEntry entry, string line) @trusted {
        if (line.startsWith("#~")) {
            entry.obsolete = true;
        } else if (line.startsWith("#.")) {
            entry.extractedComments ~= line[2 .. $].strip;
        } else if (line.startsWith("#:")) {
            auto refs = line[2 .. $].strip.split();
            entry.references ~= refs;
        } else if (line.startsWith("#,")) {
            auto flags = line[2 .. $].strip.split(",");
            foreach (flag; flags) {
                entry.flags ~= flag.strip;
            }
        } else if (line.startsWith("#|")) {
            // Previous context or msgid
            auto content = line[2 .. $].strip;
            if (content.startsWith("msgctxt")) {
                entry.previousContext ~= content;
            } else if (content.startsWith("msgid")) {
                entry.previousId ~= content;
            }
        } else if (line.startsWith("#")) {
            entry.translatorComments ~= line[1 .. $].strip;
        }
    }
    
    private string parseString(string keyword) @trusted {
        string result;
        
        if (currentLine >= lines.length) {
            return result;
        }
        
        string line = lines[currentLine].strip;
        
        // Check if line starts with the keyword
        if (!line.startsWith(keyword)) {
            return result;
        }
        
        // Extract the initial string
        auto afterKeyword = line[keyword.length .. $].strip;
        if (afterKeyword.length > 0) {
            result = unescapeString(afterKeyword);
        }
        currentLine++;
        
        // Continue with continuation lines
        while (currentLine < lines.length) {
            line = lines[currentLine].strip;
            if (!line.startsWith("\"")) {
                break;
            }
            result ~= unescapeString(line);
            currentLine++;
        }
        
        return result;
    }
    
    private string[] parsePluralStrings() @trusted {
        string[] results;
        int index = 0;
        
        while (currentLine < lines.length) {
            string line = lines[currentLine].strip;
            
            if (!line.startsWith("msgstr[")) {
                break;
            }
            
            // Parse msgstr[n]
            auto bracketEnd = line.indexOf(']');
            if (bracketEnd == -1) break;
            
            auto indexStr = line[7 .. bracketEnd];
            auto parsedIndex = to!int(indexStr);
            
            auto afterBracket = line[bracketEnd + 1 .. $].strip;
            string value = unescapeString(afterBracket);
            currentLine++;
            
            // Continue with continuation lines
            while (currentLine < lines.length) {
                line = lines[currentLine].strip;
                if (!line.startsWith("\"")) {
                    break;
                }
                value ~= unescapeString(line);
                currentLine++;
            }
            
            // Ensure array is large enough
            while (results.length <= parsedIndex) {
                results ~= "";
            }
            results[parsedIndex] = value;
        }
        
        return results;
    }
    
    private string unescapeString(string str) @trusted pure {
        str = str.strip;
        
        // Remove surrounding quotes
        if (str.startsWith("\"") && str.endsWith("\"")) {
            str = str[1 .. $ - 1];
        }
        
        // Unescape common escape sequences
        str = str.replace("\\n", "\n");
        str = str.replace("\\t", "\t");
        str = str.replace("\\r", "\r");
        str = str.replace("\\\"", "\"");
        str = str.replace("\\\\", "\\");
        
        return str;
    }
    
    private void skipEmptyLines() @safe pure nothrow {
        while (currentLine < lines.length && lines[currentLine].strip.length == 0) {
            currentLine++;
        }
    }
}
