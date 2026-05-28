/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.s2000m.models.document;

import uim.s2000m;

mixin(ShowModule!());

@safe:

class UIMS2000MDocument : UIMObject, IS2000MDocument {
  private string _rawXml;
  private string _rootElement;
  private string _transactionCode;
  private S2000MChapter _chapter = S2000MChapter.unknown;
  private S2000MIssue _issue = S2000MIssue.legacy;

  string rawXml() {
    return _rawXml;
  }

  IS2000MDocument rawXml(string value) {
    _rawXml = value;
    return this;
  }

  string rootElement() {
    return _rootElement;
  }

  IS2000MDocument rootElement(string value) {
    _rootElement = value;
    return this;
  }

  string transactionCode() {
    return _transactionCode;
  }

  IS2000MDocument transactionCode(string value) {
    _transactionCode = value;
    return this;
  }

  S2000MChapter chapter() {
    return _chapter;
  }

  IS2000MDocument chapter(S2000MChapter value) {
    _chapter = value;
    return this;
  }

  S2000MIssue issue() {
    return _issue;
  }

  IS2000MDocument issue(S2000MIssue value) {
    _issue = value;
    return this;
  }

  bool isValid() {
    return _rawXml.length > 0 && _rootElement.length > 0;
  }
}

IS2000MDocument S2000MDocument() {
  return new UIMS2000MDocument();
}

unittest {
  auto doc = S2000MDocument()
    .rawXml("<S2000M></S2000M>")
    .rootElement("S2000M")
    .transactionCode("MATREQ")
    .chapter(S2000MChapter.materialSupply)
    .issue(S2000MIssue.issue80);

  assert(doc.isValid());
  assert(doc.transactionCode() == "MATREQ");
}