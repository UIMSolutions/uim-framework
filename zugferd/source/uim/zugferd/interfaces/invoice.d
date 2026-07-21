/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.zugferd.interfaces.invoice;

@safe:

enum ZUGFeRDProfile : ubyte {
  minimum = 0,
  basicWL = 1,
  basic = 2,
  en16931 = 3,
  extended = 4,
  xrechnung = 5,
  unknown = 255
}

struct ZUGFeRDParty {
  string name;
  string endpointId;
  string endpointSchemeId;
  string vatIdentifier;
  string street;
  string city;
  string postalCode;
  string countryCode;
}

struct ZUGFeRDInvoiceLine {
  string id;
  string name;
  string description;
  string unitCode = "C62";
  double quantity;
  double netPrice;
  double lineTotal;
  double taxPercent;
}

struct ZUGFeRDTax {
  string categoryCode = "S";
  string typeCode = "VAT";
  double taxableAmount;
  double taxAmount;
  double percent;
}

struct ZUGFeRDAttachmentInfo {
  bool attached;
  string fileName;
  string mimeType;
}

interface IZUGFeRDInvoice {
  string id();
  IZUGFeRDInvoice id(string value);

  string issueDate();
  IZUGFeRDInvoice issueDate(string value);

  string currency();
  IZUGFeRDInvoice currency(string value);

  ZUGFeRDParty seller();
  IZUGFeRDInvoice seller(ZUGFeRDParty value);

  ZUGFeRDParty buyer();
  IZUGFeRDInvoice buyer(ZUGFeRDParty value);

  ZUGFeRDInvoiceLine[] lines();
  IZUGFeRDInvoice lines(const(ZUGFeRDInvoiceLine)[] value);
  IZUGFeRDInvoice addLine(ZUGFeRDInvoiceLine value);

  ZUGFeRDTax[] taxes();
  IZUGFeRDInvoice taxes(const(ZUGFeRDTax)[] value);
  IZUGFeRDInvoice addTax(ZUGFeRDTax value);

  double netAmount();
  IZUGFeRDInvoice netAmount(double value);

  double taxAmount();
  IZUGFeRDInvoice taxAmount(double value);

  double grossAmount();
  IZUGFeRDInvoice grossAmount(double value);

  bool isValid();
}

alias ZUGFeRDXmlHandler = void delegate(string xml) @safe;

interface IZUGFeRDService {
  bool validate(IZUGFeRDInvoice invoice);
  string buildXml(IZUGFeRDInvoice invoice, ZUGFeRDProfile profile = ZUGFeRDProfile.en16931);
  ubyte[] embedXmlInPdf(const(ubyte)[] pdfPayload, string xmlPayload, string fileName = "factur-x.xml");
  string extractXmlFromPdf(const(ubyte)[] payload);
  ZUGFeRDProfile detectProfile(string xmlPayload);
  bool buildXmlAsync(IZUGFeRDInvoice invoice, ZUGFeRDProfile profile, ZUGFeRDXmlHandler handler);
}
