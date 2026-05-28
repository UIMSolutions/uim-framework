/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.s2000m.catalog;

import uim.s2000m.interfaces.document;

@safe:

S2000MDownloadArtifact[] s2000mOfficialDownloads() {
  return [
    S2000MDownloadArtifact(
      "S2000M Issue 8.0 (April 2025)",
      "https://umbraco.asd-europe.org/media/b3idjbuf/s2000m_issue_8-0.pdf?rmode=pad&v=1dc67408f3008d0",
      "Part of the 2025 S-Series block release with Chapter 1 provisioning and codification XML exchanges, plus enhanced Chapter 3 material supply templates."
    ),
    S2000MDownloadArtifact(
      "S2000M 8.0 XSD Schemas",
      "https://umbraco.asd-europe.org/media/kwudnkld/s2000m_8-0_xsd_001-00.zip?rmode=pad&v=1dca57209e59d50",
      "XSD files used as the formal contract for exchange integrity and validation against UML relationships and value libraries."
    ),
    S2000MDownloadArtifact(
      "S2000M 8.0 Data Model EAP",
      "https://umbraco.asd-europe.org/media/4ignhuzh/s2000m_8-0_data_model_001-00.eap?rmode=pad&v=1dca571ebe84eb0",
      "Enterprise Architect model file for UML interchange."
    ),
    S2000MDownloadArtifact(
      "S2000M 8.0 Data Model XMI",
      "https://umbraco.asd-europe.org/media/ejcf1spg/s2000m_8-0_data_model_001-00.xmi?rmode=pad&v=1dca571fdc86b10",
      "XMI UML model interchange for tool-independent data model usage."
    )
  ];
}