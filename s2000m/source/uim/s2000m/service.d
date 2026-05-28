/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.s2000m.service;

import vibe.d : runTask;

import uim.s2000m;

mixin(ShowModule!());

@safe:

class UIMS2000MService : UIMObject, IS2000MService {
  IS2000MDocument parseXml(string xmlPayload) {
    auto doc = S2000MDocument();
    auto transactionCode = s2000mExtractTransactionCode(xmlPayload);

    doc.rawXml(xmlPayload)
      .rootElement(s2000mExtractRootElement(xmlPayload))
      .transactionCode(transactionCode)
      .issue(s2000mDetectIssue(xmlPayload))
      .chapter(s2000mChapterFromTransactionCode(transactionCode));

    return doc;
  }

  bool validateAgainstIssue(IS2000MDocument document, S2000MIssue issue) {
    if (document is null || !document.isValid()) {
      return false;
    }

    if (document.issue() == S2000MIssue.legacy) {
      return issue == S2000MIssue.legacy;
    }

    return document.issue() == issue;
  }

  void parseAsync(string xmlPayload, S2000MDocumentHandler handler) {
    if (handler is null) {
      return;
    }

    runTask(() nothrow {
      try {
        auto document = parseXml(xmlPayload);
        handler(document);
      } catch (Exception) {
      }
    });
  }

  S2000MDownloadArtifact[] recommendedDownloads() {
    return s2000mOfficialDownloads();
  }
}

IS2000MService S2000MService() {
  return new UIMS2000MService();
}

unittest {
  auto service = S2000MService();
  auto xml = `<ProvisioningMessage issue="8.0" transactionCode="P100"><item/></ProvisioningMessage>`;
  auto doc = service.parseXml(xml);
  assert(doc.rootElement() == "ProvisioningMessage");
  assert(service.validateAgainstIssue(doc, S2000MIssue.issue80));
}