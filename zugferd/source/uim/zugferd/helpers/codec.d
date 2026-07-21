/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.zugferd.helpers.codec;

import std.array : appender;
import std.base64 : Base64;
import std.format : format;
import std.string : endsWith, indexOf, replace, strip, toLower;

import uim.zugferd.interfaces.invoice;

@safe:

private string bytesToString(const(ubyte)[] data) @trusted {
  return cast(string) data;
}

private ubyte[] stringToBytes(string data) @trusted {
  return cast(ubyte[]) data.dup;
}

private string xmlEscape(string value) {
  return value
    .replace("&", "&amp;")
    .replace("<", "&lt;")
    .replace(">", "&gt;")
    .replace("\"", "&quot;")
    .replace("'", "&apos;");
}

string zugferdProfileUrn(ZUGFeRDProfile profile) {
  final switch (profile) {
    case ZUGFeRDProfile.minimum: return "urn:factur-x.eu:1p0:minimum";
    case ZUGFeRDProfile.basicWL: return "urn:factur-x.eu:1p0:basicwl";
    case ZUGFeRDProfile.basic: return "urn:factur-x.eu:1p0:basic";
    case ZUGFeRDProfile.en16931: return "urn:cen.eu:en16931:2017";
    case ZUGFeRDProfile.extended: return "urn:factur-x.eu:1p0:extended";
    case ZUGFeRDProfile.xrechnung: return "urn:xeinkauf.de:kosit:xrechnung_3.0";
    case ZUGFeRDProfile.unknown: return "";
  }
}

ZUGFeRDProfile zugferdDetectProfile(string xmlPayload) {
  auto xml = xmlPayload.toLower();

  if (xml.indexOf("xrechnung") >= 0) {
    return ZUGFeRDProfile.xrechnung;
  }
  if (xml.indexOf("extended") >= 0) {
    return ZUGFeRDProfile.extended;
  }
  if (xml.indexOf("en16931") >= 0 || xml.indexOf("cen.eu:en16931") >= 0) {
    return ZUGFeRDProfile.en16931;
  }
  if (xml.indexOf("basicwl") >= 0) {
    return ZUGFeRDProfile.basicWL;
  }
  if (xml.indexOf("basic") >= 0) {
    return ZUGFeRDProfile.basic;
  }
  if (xml.indexOf("minimum") >= 0) {
    return ZUGFeRDProfile.minimum;
  }

  return ZUGFeRDProfile.unknown;
}

string zugferdBuildCiiXml(IZUGFeRDInvoice invoice, ZUGFeRDProfile profile) {
  if (invoice is null || !invoice.isValid()) {
    return "";
  }

  auto lines = invoice.lines();
  auto taxes = invoice.taxes();

  auto xml = appender!string();
  xml.put("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
  xml.put("<rsm:CrossIndustryInvoice xmlns:rsm=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100\" ");
  xml.put("xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100\" ");
  xml.put("xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100\">\n");

  xml.put("  <rsm:ExchangedDocumentContext>\n");
  xml.put("    <ram:GuidelineSpecifiedDocumentContextParameter>\n");
  xml.put(format("      <ram:ID>%s</ram:ID>\n", xmlEscape(zugferdProfileUrn(profile))));
  xml.put("    </ram:GuidelineSpecifiedDocumentContextParameter>\n");
  xml.put("  </rsm:ExchangedDocumentContext>\n");

  xml.put("  <rsm:ExchangedDocument>\n");
  xml.put(format("    <ram:ID>%s</ram:ID>\n", xmlEscape(invoice.id())));
  xml.put("    <ram:TypeCode>380</ram:TypeCode>\n");
  xml.put("    <ram:IssueDateTime><udt:DateTimeString format=\"102\">");
  xml.put(xmlEscape(invoice.issueDate()));
  xml.put("</udt:DateTimeString></ram:IssueDateTime>\n");
  xml.put("  </rsm:ExchangedDocument>\n");

  xml.put("  <rsm:SupplyChainTradeTransaction>\n");

  foreach (line; lines) {
    xml.put("    <ram:IncludedSupplyChainTradeLineItem>\n");
    xml.put("      <ram:AssociatedDocumentLineDocument>\n");
    xml.put(format("        <ram:LineID>%s</ram:LineID>\n", xmlEscape(line.id)));
    xml.put("      </ram:AssociatedDocumentLineDocument>\n");

    xml.put("      <ram:SpecifiedTradeProduct>\n");
    xml.put(format("        <ram:Name>%s</ram:Name>\n", xmlEscape(line.name)));
    if (line.description.length > 0) {
      xml.put(format("        <ram:Description>%s</ram:Description>\n", xmlEscape(line.description)));
    }
    xml.put("      </ram:SpecifiedTradeProduct>\n");

    xml.put("      <ram:SpecifiedLineTradeAgreement>\n");
    xml.put("        <ram:NetPriceProductTradePrice>\n");
    xml.put(format("          <ram:ChargeAmount>%.2f</ram:ChargeAmount>\n", line.netPrice));
    xml.put("        </ram:NetPriceProductTradePrice>\n");
    xml.put("      </ram:SpecifiedLineTradeAgreement>\n");

    xml.put("      <ram:SpecifiedLineTradeDelivery>\n");
    xml.put(format("        <ram:BilledQuantity unitCode=\"%s\">%.3f</ram:BilledQuantity>\n", xmlEscape(line.unitCode), line.quantity));
    xml.put("      </ram:SpecifiedLineTradeDelivery>\n");

    xml.put("      <ram:SpecifiedLineTradeSettlement>\n");
    xml.put("        <ram:ApplicableTradeTax>\n");
    xml.put("          <ram:TypeCode>VAT</ram:TypeCode>\n");
    xml.put("          <ram:CategoryCode>S</ram:CategoryCode>\n");
    xml.put(format("          <ram:RateApplicablePercent>%.2f</ram:RateApplicablePercent>\n", line.taxPercent));
    xml.put("        </ram:ApplicableTradeTax>\n");
    xml.put("        <ram:SpecifiedTradeSettlementLineMonetarySummation>\n");
    xml.put(format("          <ram:LineTotalAmount>%.2f</ram:LineTotalAmount>\n", line.lineTotal));
    xml.put("        </ram:SpecifiedTradeSettlementLineMonetarySummation>\n");
    xml.put("      </ram:SpecifiedLineTradeSettlement>\n");
    xml.put("    </ram:IncludedSupplyChainTradeLineItem>\n");
  }

  xml.put("    <ram:ApplicableHeaderTradeAgreement>\n");
  xml.put(format("      <ram:SellerTradeParty><ram:Name>%s</ram:Name></ram:SellerTradeParty>\n", xmlEscape(invoice.seller().name)));
  xml.put(format("      <ram:BuyerTradeParty><ram:Name>%s</ram:Name></ram:BuyerTradeParty>\n", xmlEscape(invoice.buyer().name)));
  xml.put("    </ram:ApplicableHeaderTradeAgreement>\n");

  xml.put("    <ram:ApplicableHeaderTradeSettlement>\n");
  xml.put(format("      <ram:InvoiceCurrencyCode>%s</ram:InvoiceCurrencyCode>\n", xmlEscape(invoice.currency())));

  foreach (tax; taxes) {
    xml.put("      <ram:ApplicableTradeTax>\n");
    xml.put(format("        <ram:CalculatedAmount>%.2f</ram:CalculatedAmount>\n", tax.taxAmount));
    xml.put(format("        <ram:TypeCode>%s</ram:TypeCode>\n", xmlEscape(tax.typeCode)));
    xml.put(format("        <ram:BasisAmount>%.2f</ram:BasisAmount>\n", tax.taxableAmount));
    xml.put(format("        <ram:CategoryCode>%s</ram:CategoryCode>\n", xmlEscape(tax.categoryCode)));
    xml.put(format("        <ram:RateApplicablePercent>%.2f</ram:RateApplicablePercent>\n", tax.percent));
    xml.put("      </ram:ApplicableTradeTax>\n");
  }

  xml.put("      <ram:SpecifiedTradeSettlementHeaderMonetarySummation>\n");
  xml.put(format("        <ram:LineTotalAmount>%.2f</ram:LineTotalAmount>\n", invoice.netAmount()));
  xml.put(format("        <ram:TaxBasisTotalAmount>%.2f</ram:TaxBasisTotalAmount>\n", invoice.netAmount()));
  xml.put(format("        <ram:TaxTotalAmount>%.2f</ram:TaxTotalAmount>\n", invoice.taxAmount()));
  xml.put(format("        <ram:GrandTotalAmount>%.2f</ram:GrandTotalAmount>\n", invoice.grossAmount()));
  xml.put(format("        <ram:DuePayableAmount>%.2f</ram:DuePayableAmount>\n", invoice.grossAmount()));
  xml.put("      </ram:SpecifiedTradeSettlementHeaderMonetarySummation>\n");
  xml.put("    </ram:ApplicableHeaderTradeSettlement>\n");

  xml.put("  </rsm:SupplyChainTradeTransaction>\n");
  xml.put("</rsm:CrossIndustryInvoice>\n");

  return xml.data;
}

ubyte[] zugferdEmbedXmlInPdf(const(ubyte)[] pdfPayload, string xmlPayload, string fileName = "factur-x.xml") {
  auto basePdf = bytesToString(pdfPayload);
  if (basePdf.length == 0 || xmlPayload.length == 0) {
    return [];
  }

  auto encoded = Base64.encode(cast(ubyte[]) xmlPayload.dup);
  auto builder = appender!string();
  builder.put(basePdf);

  if (!basePdf.endsWith("\n")) {
    builder.put("\n");
  }

  builder.put("%UIM-ZUGFERD-ATTACHMENT-BEGIN\n");
  builder.put(format("%%FileName:%s\n", fileName));
  builder.put("%MimeType:text/xml\n");
  builder.put(format("%%Data:%s\n", encoded));
  builder.put("%UIM-ZUGFERD-ATTACHMENT-END\n");

  return stringToBytes(builder.data);
}

string zugferdExtractXmlFromPdf(const(ubyte)[] payload) {
  auto raw = bytesToString(payload);
  auto marker = "%Data:";
  auto start = raw.indexOf(marker);
  if (start < 0) {
    return "";
  }

  auto dataStart = start + marker.length;
  auto dataEnd = raw.indexOf("\n", dataStart);
  if (dataEnd < 0) {
    dataEnd = cast(int) raw.length;
  }

  auto encoded = raw[dataStart .. dataEnd].strip();
  if (encoded.length == 0) {
    return "";
  }

  auto decoded = Base64.decode(encoded);
  return bytesToString(decoded);
}
