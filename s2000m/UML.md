/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-S2000M UML Description

## Overview

The UIM-S2000M library models S2000M exchange payload metadata and provides service-oriented parsing helpers for D projects using vibe.d runtime patterns.

The architecture aligns with official S2000M download artifacts by exposing Issue 8.0 metadata and associated model/schema artifact links (PDF, XSD, EAP, XMI).

## Core Types

```plantuml
@startuml S2000M_Core

enum S2000MChapter {
  unknown
  provisioning
  procurementPlanning
  materialSupply
  invoicing
}

enum S2000MIssue {
  issue80
  issue71
  issue70
  legacy
}

interface IS2000MDocument {
  + rawXml(): string
  + rootElement(): string
  + transactionCode(): string
  + chapter(): S2000MChapter
  + issue(): S2000MIssue
  + isValid(): bool
}

interface IS2000MService {
  + parseXml(xmlPayload: string): IS2000MDocument
  + validateAgainstIssue(document: IS2000MDocument, issue: S2000MIssue): bool
  + parseAsync(xmlPayload: string, handler: S2000MDocumentHandler): void
  + recommendedDownloads(): S2000MDownloadArtifact[]
}

class UIMS2000MDocument {
  - _rawXml: string
  - _rootElement: string
  - _transactionCode: string
  - _chapter: S2000MChapter
  - _issue: S2000MIssue
}

class UIMS2000MService

class S2000MDownloadArtifact {
  + title: string
  + url: string
  + description: string
}

UIMS2000MDocument ..|> IS2000MDocument
UIMS2000MService ..|> IS2000MService
UIMS2000MService --> UIMS2000MDocument : builds
UIMS2000MService --> S2000MDownloadArtifact : provides catalog

@enduml
```

## Helper Layer

```plantuml
@startuml S2000M_Helpers

class XmlHelpers {
  + s2000mExtractRootElement(xmlPayload: string): string
  + s2000mExtractTransactionCode(xmlPayload: string): string
  + s2000mDetectIssue(xmlPayload: string): S2000MIssue
  + s2000mChapterFromTransactionCode(code: string): S2000MChapter
}

class DownloadCatalog {
  + s2000mOfficialDownloads(): S2000MDownloadArtifact[]
}

UIMS2000MService --> XmlHelpers : parse and infer
UIMS2000MService --> DownloadCatalog : return references

@enduml
```

## Sequence

```plantuml
@startuml S2000M_Parse

actor Application
participant Service as "UIMS2000MService"
participant Helpers as "uim.s2000m.helpers.xml"
participant Document as "UIMS2000MDocument"

Application -> Service: parseXml(xmlPayload)
Service -> Helpers: extract root, transaction, issue
Helpers --> Service: parsed metadata
Service -> Document: set fields
Document --> Service: IS2000MDocument
Service --> Application: parsed document

Application -> Service: recommendedDownloads()
Service --> Application: S2000M 8.0 artifact list

@enduml
```