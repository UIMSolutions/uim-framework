/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.s2000m.interfaces.document;

@safe:

enum S2000MChapter : ushort {
  unknown = 0,
  provisioning = 1,
  procurementPlanning = 2,
  materialSupply = 3,
  invoicing = 4
}

enum S2000MIssue : string {
  issue80 = "8.0",
  issue71 = "7.1",
  issue70 = "7.0",
  legacy = "legacy"
}

struct S2000MDownloadArtifact {
  string title;
  string url;
  string description;
}

interface IS2000MDocument {
  string rawXml();
  IS2000MDocument rawXml(string value);

  string rootElement();
  IS2000MDocument rootElement(string value);

  string transactionCode();
  IS2000MDocument transactionCode(string value);

  S2000MChapter chapter();
  IS2000MDocument chapter(S2000MChapter value);

  S2000MIssue issue();
  IS2000MDocument issue(S2000MIssue value);

  bool isValid();
}

alias S2000MDocumentHandler = void delegate(IS2000MDocument document);

interface IS2000MService {
  IS2000MDocument parseXml(string xmlPayload);
  bool validateAgainstIssue(IS2000MDocument document, S2000MIssue issue);
  void parseAsync(string xmlPayload, S2000MDocumentHandler handler);
  S2000MDownloadArtifact[] recommendedDownloads();
}