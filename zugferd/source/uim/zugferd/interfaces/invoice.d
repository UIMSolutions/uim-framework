/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.zugferd.interfaces.invoice;

@safe:

/// ZUGFeRDProfile enum defines the different profiles of ZUGFeRD invoices. 
enum ZUGFeRDProfile : ubyte {
  minimum = 0, // ZUGFeRD 1.0 minimum profile
  basicWL = 1, // ZUGFeRD 1.0 basic profile with line items
  basic = 2, // ZUGFeRD 1.0 basic profile without line items
  en16931 = 3, // ZUGFeRD 2.0 / Factur-X / EN 16931 profile
  extended = 4, // ZUGFeRD 2.0 extended profile
  facturX = 4, // Factur-X profile (same as extended)
  xrechnung = 5, // XRechnung profile
  unknown = 255 // Unknown profile
}

/// ZUGFeRDParty struct represents a party involved in the invoice, such as the seller or buyer.  
struct ZUGFeRDParty {
  string name; // Name of the party (e.g., company name) 
  string endpointId; // Endpoint ID (e.g., for electronic invoicing)
  string endpointSchemeId; // Scheme ID for the endpoint (e.g., "GLN" for Global Location Number)
  string vatIdentifier; // VAT identifier of the party (e.g., "DE123456789")
  string street; // Street address of the party (e.g., "Main Street 1")
  string city; // City of the party (e.g., "Berlin")
  string postalCode; // Postal code of the party (e.g., "10115")
  string countryCode; // Country code of the party (e.g., "DE")
}

/// ZUGFeRDInvoiceLine struct represents a line item in the invoice, including details such as quantity, price, and tax.
struct ZUGFeRDInvoiceLine {
  string id; // Unique identifier for the line item (e.g., "1", "2", etc.)
  string name; // Name or description of the product or service (e.g., "Widget A")
  string description; // Additional description of the product or service (e.g., "High-quality widget")
  string unitCode = "C62"; // Unit code for the quantity (e.g., "C62" for pieces)
  double quantity; // Quantity of the product or service (e.g., 10.0)
  double netPrice; // Net price per unit of the product or service (e.g., 19.99)
  double grossPrice; // Gross price per unit of the product or service (e.g., 23.79)
  double taxAmount; // Tax amount for the line item (e.g., 3.80)
  double taxPercent; // Tax percentage for the line item (e.g., 19.0)
  double lineTotal; // Total amount for the line item (e.g., 237.90)
  double lineTotalWithTax; // Total amount for the line item including tax (e.g., 237.90 + 3.80)
  string taxCategoryCode; // Tax category code for the line item (e.g., "S" for standard rate)
  string taxTypeCode; // Tax type code for the line item (e.g., "VAT" for value-added tax)
  double taxableAmount; // Taxable amount for the line item (e.g., 237.90)
  double taxAmountForLine; // Tax amount for the line item (e.g., 3.80)
  double taxPercentForLine; // Tax percentage for the line item (e.g., 19.0)
  double grossAmountForLine; // Gross amount for the line item (e.g., 237.90 + 3.80)
}

/// ZUGFeRDTax struct represents a tax entry in the invoice, including details such as category, type, and amounts.
struct ZUGFeRDTax {
  string categoryCode = "S"; // Tax category code (e.g., "S" for standard rate)
  string typeCode = "VAT"; // Tax type code (e.g., "VAT" for value-added tax)
  double taxableAmount; // Taxable amount for the tax entry (e.g., 237.90)
  double taxAmount; // Tax amount for the tax entry (e.g., 3.80)
  double percent; // Tax percentage for the tax entry (e.g., 19.0)
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
