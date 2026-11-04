/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xml.readers.helper;

import uim.xml;

@safe:

/**
 * Escapes special XML characters in a string.
 *
 * @param value The string to escape.
 * @return The escaped string with special XML characters replaced by their corresponding entities.
 * @example
 * auto escaped = escapeXml("<tag>"); // "&lt;tag&gt;"
 */
string escapeXml(string value) {
    auto result = appender!string();
    result.reserve(value.length);

    foreach (dchar c; value) {
        switch (c) {
        case '&':
            result.put("&amp;");
            break;
        case '<':
            result.put("&lt;");
            break;
        case '>':
            result.put("&gt;");
            break;
        case '"':
            result.put("&quot;");
            break;
        case '\'':
            result.put("&apos;");
            break;
        default:
            result.put(c);
            break;
        }
    }

    return result.data;
}
/// Unit tests for the escapeXml function.
unittest {
    assert(escapeXml("") == "");
    assert(escapeXml("hello") == "hello");
    assert(escapeXml("<tag>") == "&lt;tag&gt;");
    assert(escapeXml("A & B") == "A &amp; B");
    assert(escapeXml(`"quoted"`) == "&quot;quoted&quot;");
    assert(escapeXml("it's") == "it&apos;s");
    assert(escapeXml(
            "<a href=\"x\">B & C's</a>") ==
            "&lt;a href=&quot;x&quot;&gt;B &amp; C&apos;s&lt;/a&gt;");
}
