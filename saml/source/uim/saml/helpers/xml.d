/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.saml.helpers.xml;

import std.array  : appender;
import std.string : indexOf;

@safe:

// ---------------------------------------------------------------------------
// XML attribute / text value escaping (XML 1.0 §2.3)
// ---------------------------------------------------------------------------

/// Escape a string for use inside an XML attribute value (double-quoted)
string samlXmlEscapeAttr(string value) {
  auto buf = appender!string;
  buf.reserve(value.length + 16);
  foreach (char c; value) {
    switch (c) {
      case '&':  buf ~= "&amp;";  break;
      case '<':  buf ~= "&lt;";   break;
      case '>':  buf ~= "&gt;";   break;
      case '"':  buf ~= "&quot;"; break;
      case '\'': buf ~= "&#39;";  break;
      default:   buf ~= c;
    }
  }
  return buf.data;
}

/// Escape a string for use as XML element text content
string samlXmlEscapeText(string value) {
  auto buf = appender!string;
  buf.reserve(value.length + 8);
  foreach (char c; value) {
    switch (c) {
      case '&': buf ~= "&amp;"; break;
      case '<': buf ~= "&lt;";  break;
      case '>': buf ~= "&gt;";  break;
      default:  buf ~= c;
    }
  }
  return buf.data;
}

// ---------------------------------------------------------------------------
// Simple XML element / attribute extraction
// These helpers work on well-formed SAML XML and handle namespace prefixes
// (e.g. <saml:Issuer> and <Issuer> are both matched by localName "Issuer").
// ---------------------------------------------------------------------------

/// Return text content of the first element with the given local name.
/// Returns "" when not found or element is empty / self-closing.
string samlXmlTextContent(string xml, string localName) {
  size_t pos = 0;
  while (pos < xml.length) {
    ptrdiff_t lt = xml.indexOf('<', pos);
    if (lt < 0) return "";

    size_t ltPos = cast(size_t) lt;
    if (ltPos + 1 >= xml.length) return "";

    char next = xml[ltPos + 1];
    if (next == '/' || next == '!' || next == '?') { pos = ltPos + 2; continue; }

    // Extract the local part of the tag name
    size_t nameStart = ltPos + 1;
    size_t nameEnd   = nameStart;
    while (nameEnd < xml.length) {
      char c = xml[nameEnd];
      if (c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '>' || c == '/') break;
      nameEnd++;
    }
    string tagName  = xml[nameStart .. nameEnd];
    ptrdiff_t colon = tagName.indexOf(':');
    string localTag = colon >= 0 ? tagName[colon + 1 .. $] : tagName;

    if (localTag != localName) { pos = ltPos + 1; continue; }

    // Find end of opening tag
    ptrdiff_t gt = xml.indexOf('>', ltPos);
    if (gt < 0) return "";

    size_t gtPos = cast(size_t) gt;
    // Self-closing?
    if (gtPos > 0 && xml[gtPos - 1] == '/') { pos = gtPos + 1; continue; }

    // Return text content up to next '<'
    size_t contentStart = gtPos + 1;
    ptrdiff_t nextLt    = xml.indexOf('<', contentStart);
    if (nextLt < 0) return xml[contentStart .. $];
    return xml[contentStart .. cast(size_t) nextLt];
  }
  return "";
}

/// Return the value of the named attribute from the first element with the
/// given local name (or any element if localName is empty string "").
string samlXmlAttrValue(string xml, string localName, string attrName) {
  size_t pos = 0;
  while (pos < xml.length) {
    ptrdiff_t lt = xml.indexOf('<', pos);
    if (lt < 0) return "";

    size_t ltPos = cast(size_t) lt;
    if (ltPos + 1 >= xml.length) return "";

    char next = xml[ltPos + 1];
    if (next == '/' || next == '!' || next == '?') { pos = ltPos + 2; continue; }

    size_t nameStart = ltPos + 1;
    size_t nameEnd   = nameStart;
    while (nameEnd < xml.length) {
      char c = xml[nameEnd];
      if (c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '>' || c == '/') break;
      nameEnd++;
    }
    string tagName  = xml[nameStart .. nameEnd];
    ptrdiff_t colon = tagName.indexOf(':');
    string localTag = colon >= 0 ? tagName[colon + 1 .. $] : tagName;

    if (localName.length > 0 && localTag != localName) { pos = ltPos + 1; continue; }

    // Found the element — extract the full opening tag up to '>'
    ptrdiff_t gt = xml.indexOf('>', ltPos);
    if (gt < 0) return "";

    string tagContent = xml[ltPos .. cast(size_t) gt + 1];

    // Look for attrName="..." or attrName='...'
    foreach (q; [`"`, `'`]) {
      string pattern = attrName ~ "=" ~ q;
      ptrdiff_t attrIdx = tagContent.indexOf(pattern);
      if (attrIdx < 0) continue;

      size_t valueStart = cast(size_t)(attrIdx + cast(ptrdiff_t) pattern.length);
      ptrdiff_t valueEnd = tagContent.indexOf(q, valueStart);
      if (valueEnd < 0) continue;

      return tagContent[valueStart .. cast(size_t) valueEnd];
    }

    pos = cast(size_t) gt + 1;
  }
  return "";
}

/// Return the outer XML of all elements with the given local name at any depth.
/// Simple depth-counting: handles nested same-name elements correctly.
string[] samlXmlElements(string xml, string localName) {
  string[] result;
  size_t   pos = 0;

  while (pos < xml.length) {
    ptrdiff_t lt = xml.indexOf('<', pos);
    if (lt < 0) break;

    size_t ltPos = cast(size_t) lt;
    if (ltPos + 1 >= xml.length) break;

    char next = xml[ltPos + 1];
    if (next == '/' || next == '!' || next == '?') { pos = ltPos + 2; continue; }

    size_t nameStart = ltPos + 1;
    size_t nameEnd   = nameStart;
    while (nameEnd < xml.length) {
      char c = xml[nameEnd];
      if (c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '>' || c == '/') break;
      nameEnd++;
    }
    string tagName  = xml[nameStart .. nameEnd];
    ptrdiff_t colon = tagName.indexOf(':');
    string localTag = colon >= 0 ? tagName[colon + 1 .. $] : tagName;

    if (localTag != localName) { pos = ltPos + 1; continue; }

    // Found a matching opening tag
    ptrdiff_t gt = xml.indexOf('>', ltPos);
    if (gt < 0) break;

    size_t gtPos = cast(size_t) gt;

    // Self-closing?
    if (gtPos > 0 && xml[gtPos - 1] == '/') {
      result ~= xml[ltPos .. gtPos + 1];
      pos = gtPos + 1;
      continue;
    }

    // Depth-track to find matching closing tag
    size_t searchPos = gtPos + 1;
    int depth = 1;
    while (depth > 0 && searchPos < xml.length) {
      ptrdiff_t nextLt = xml.indexOf('<', searchPos);
      if (nextLt < 0) break;

      size_t nlt = cast(size_t) nextLt;
      if (nlt + 1 >= xml.length) break;

      if (xml[nlt + 1] == '/') {
        // Closing tag
        size_t closeNameStart = nlt + 2;
        size_t closeNameEnd   = closeNameStart;
        while (closeNameEnd < xml.length) {
          char c = xml[closeNameEnd];
          if (c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '>') break;
          closeNameEnd++;
        }
        string closeName  = xml[closeNameStart .. closeNameEnd];
        ptrdiff_t ccolon  = closeName.indexOf(':');
        string closeLocal = ccolon >= 0 ? closeName[ccolon + 1 .. $] : closeName;
        if (closeLocal == localName) {
          depth--;
          if (depth == 0) {
            ptrdiff_t closeGt = xml.indexOf('>', nlt);
            if (closeGt >= 0) {
              result ~= xml[ltPos .. cast(size_t) closeGt + 1];
              pos = cast(size_t) closeGt + 1;
            }
            break;
          }
        }
        searchPos = nlt + 1;
      } else if (xml[nlt + 1] != '!' && xml[nlt + 1] != '?') {
        // Opening tag — check for same local name, increment depth if not self-closing
        size_t openNameEnd = nlt + 1;
        while (openNameEnd < xml.length) {
          char c = xml[openNameEnd];
          if (c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '>' || c == '/') break;
          openNameEnd++;
        }
        string openName  = xml[nlt + 1 .. openNameEnd];
        ptrdiff_t ocolon = openName.indexOf(':');
        string openLocal = ocolon >= 0 ? openName[ocolon + 1 .. $] : openName;

        ptrdiff_t openGt = xml.indexOf('>', nlt);
        if (openLocal == localName && openGt >= 0 && xml[cast(size_t) openGt - 1] != '/') {
          depth++;
        }
        searchPos = nlt + 1;
      } else {
        searchPos = nlt + 1;
      }
    }

    if (depth > 0) break;  // Malformed XML
  }
  return result;
}

// ---------------------------------------------------------------------------
// Unit tests
// ---------------------------------------------------------------------------

unittest {
  string xml = `<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol">` ~
               `<saml:Issuer>https://idp.example.com</saml:Issuer>` ~
               `<samlp:Status><samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/></samlp:Status>` ~
               `</samlp:Response>`;

  assert(samlXmlTextContent(xml, "Issuer")    == "https://idp.example.com");
  assert(samlXmlTextContent(xml, "Missing")   == "");
  assert(samlXmlAttrValue(xml, "StatusCode", "Value") == "urn:oasis:names:tc:SAML:2.0:status:Success");

  assert(samlXmlEscapeAttr(`a"b&c<d>e`) == "a&quot;b&amp;c&lt;d&gt;e");
  assert(samlXmlEscapeText("a&b<c>d")   == "a&amp;b&lt;c&gt;d");
}
