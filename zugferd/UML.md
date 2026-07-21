# UIM-ZUGFERD UML Description

## Overview

The UIM-ZUGFERD library provides a compact architecture to model invoice data, build Factur-X/ZUGFeRD XML, and package XML with PDF payloads for hybrid invoice exchange.

## Core Types

```plantuml
@startuml ZUGFeRD_Core

enum ZUGFeRDProfile {
  minimum
  basicWL
  basic
  en16931
  extended
  xrechnung
  unknown
}

struct ZUGFeRDParty {
  + name: string
  + endpointId: string
  + endpointSchemeId: string
  + vatIdentifier: string
  + street: string
  + city: string
  + postalCode: string
  + countryCode: string
}

struct ZUGFeRDInvoiceLine {
  + id: string
  + name: string
  + description: string
  + unitCode: string
  + quantity: double
  + netPrice: double
  + lineTotal: double
  + taxPercent: double
}

struct ZUGFeRDTax {
  + categoryCode: string
  + typeCode: string
  + taxableAmount: double
  + taxAmount: double
  + percent: double
}

interface IZUGFeRDInvoice {
  + id(): string
  + issueDate(): string
  + currency(): string
  + seller(): ZUGFeRDParty
  + buyer(): ZUGFeRDParty
  + lines(): ZUGFeRDInvoiceLine[]
  + taxes(): ZUGFeRDTax[]
  + netAmount(): double
  + taxAmount(): double
  + grossAmount(): double
  + isValid(): bool
}

interface IZUGFeRDService {
  + validate(invoice: IZUGFeRDInvoice): bool
  + buildXml(invoice: IZUGFeRDInvoice, profile: ZUGFeRDProfile): string
  + embedXmlInPdf(pdfPayload: ubyte[], xmlPayload: string, fileName: string): ubyte[]
  + extractXmlFromPdf(payload: ubyte[]): string
  + detectProfile(xmlPayload: string): ZUGFeRDProfile
  + buildXmlAsync(invoice: IZUGFeRDInvoice, profile: ZUGFeRDProfile, handler): bool
}

class UIMZUGFeRDInvoice
class UIMZUGFeRDService

UIMZUGFeRDInvoice ..|> IZUGFeRDInvoice
UIMZUGFeRDService ..|> IZUGFeRDService

@enduml
```

## Helper Layer

```plantuml
@startuml ZUGFeRD_Helpers

class CodecHelpers {
  + zugferdProfileUrn(profile: ZUGFeRDProfile): string
  + zugferdDetectProfile(xmlPayload: string): ZUGFeRDProfile
  + zugferdBuildCiiXml(invoice: IZUGFeRDInvoice, profile: ZUGFeRDProfile): string
  + zugferdEmbedXmlInPdf(pdfPayload: ubyte[], xmlPayload: string, fileName: string): ubyte[]
  + zugferdExtractXmlFromPdf(payload: ubyte[]): string
}

UIMZUGFeRDService --> CodecHelpers : XML and packaging operations

@enduml
```

## Sequence

```plantuml
@startuml ZUGFeRD_Sequence

actor Application
participant Service as "UIMZUGFeRDService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "ZUGFeRDXmlHandler"

Application -> Service: buildXml(invoice, en16931)
Service -> Helpers: zugferdBuildCiiXml
Helpers --> Service: XML payload
Service --> Application: XML payload

Application -> Service: embedXmlInPdf(pdf, xml, "factur-x.xml")
Service -> Helpers: zugferdEmbedXmlInPdf
Helpers --> Service: hybrid payload
Service --> Application: hybrid payload

Application -> Service: buildXmlAsync(invoice, profile, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(xml)

@enduml
```
