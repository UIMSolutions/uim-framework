/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.s2000m.helpers.xml;

import std.algorithm : canFind, startsWith;
import std.regex : matchFirst;
import std.string : indexOf, stripLeft;

import uim.s2000m.interfaces.document;

@safe:

string s2000mExtractRootElement(string xmlPayload) {
  auto data = xmlPayload.stripLeft();
  if (data.startsWith("<?xml")) {
    auto idx = indexOf(data, "?>");
    if (idx >= 0 && cast(size_t) (idx + 2) < data.length) {
      data = data[idx + 2 .. $].stripLeft();
    }
  }

  auto rootMatch = matchFirst(data, `<\s*([A-Za-z_][A-Za-z0-9_\-\.:]*)`);
  if (rootMatch.empty || rootMatch.captures.length < 2) {
    return "";
  }

  return rootMatch.captures[1];
}

string s2000mExtractTransactionCode(string xmlPayload) {
  auto attrMatch = matchFirst(xmlPayload, `transactionCode\s*=\s*"([^"]+)"`);
  if (!attrMatch.empty && attrMatch.captures.length >= 2) {
    return attrMatch.captures[1];
  }

  auto elementMatch = matchFirst(xmlPayload, `<\s*transactionCode\s*>\s*([^<]+)`);
  if (!elementMatch.empty && elementMatch.captures.length >= 2) {
    return elementMatch.captures[1];
  }

  return "";
}

S2000MIssue s2000mDetectIssue(string xmlPayload) {
  if (!matchFirst(xmlPayload, `issue\s*=\s*"8\.0"`).empty || !matchFirst(xmlPayload, `issueNumber\s*=\s*"8\.0"`).empty) {
    return S2000MIssue.issue80;
  }

  if (!matchFirst(xmlPayload, `issue\s*=\s*"7\.1"`).empty || !matchFirst(xmlPayload, `issueNumber\s*=\s*"7\.1"`).empty) {
    return S2000MIssue.issue71;
  }

  if (!matchFirst(xmlPayload, `issue\s*=\s*"7\.0"`).empty || !matchFirst(xmlPayload, `issueNumber\s*=\s*"7\.0"`).empty) {
    return S2000MIssue.issue70;
  }

  return S2000MIssue.legacy;
}

S2000MChapter s2000mChapterFromTransactionCode(string transactionCode) {
  if (transactionCode.length == 0) {
    return S2000MChapter.unknown;
  }

  auto transactionUpper = transactionCode.dup;
  foreach (i; 0 .. transactionUpper.length) {
    auto c = transactionUpper[i];
    if (c >= 'a' && c <= 'z') {
      transactionUpper[i] = cast(char) (c - 32);
    }
  }

  if (transactionUpper.startsWith("P")) {
    return S2000MChapter.provisioning;
  }

  if (transactionUpper.startsWith("PP")) {
    return S2000MChapter.procurementPlanning;
  }

  if (transactionUpper.startsWith("M") || transactionUpper.canFind("SUPPLY")) {
    return S2000MChapter.materialSupply;
  }

  if (transactionUpper.startsWith("I") || transactionUpper.canFind("INVOICE")) {
    return S2000MChapter.invoicing;
  }

  return S2000MChapter.unknown;
}

unittest {
  auto xml = `<?xml version="1.0"?><MaterialRequest issue="8.0" transactionCode="MATREQ"><item/></MaterialRequest>`;
  assert(s2000mExtractRootElement(xml) == "MaterialRequest");
  assert(s2000mExtractTransactionCode(xml) == "MATREQ");
  assert(s2000mDetectIssue(xml) == S2000MIssue.issue80);
  assert(s2000mChapterFromTransactionCode("MATREQ") == S2000MChapter.materialSupply);
}