/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.zugferd.service;

import vibe.d : runTask;

import uim.zugferd;

mixin(ShowModule!());

@safe:

class UIMZUGFeRDService : UIMObject, IZUGFeRDService {
  bool validate(IZUGFeRDInvoice invoice) {
    return invoice !is null && invoice.isValid();
  }

  string buildXml(IZUGFeRDInvoice invoice, ZUGFeRDProfile profile = ZUGFeRDProfile.en16931) {
    return zugferdBuildCiiXml(invoice, profile);
  }

  ubyte[] embedXmlInPdf(const(ubyte)[] pdfPayload, string xmlPayload, string fileName = "factur-x.xml") {
    return zugferdEmbedXmlInPdf(pdfPayload, xmlPayload, fileName);
  }

  string extractXmlFromPdf(const(ubyte)[] payload) {
    return zugferdExtractXmlFromPdf(payload);
  }

  ZUGFeRDProfile detectProfile(string xmlPayload) {
    return zugferdDetectProfile(xmlPayload);
  }

  bool buildXmlAsync(IZUGFeRDInvoice invoice, ZUGFeRDProfile profile, ZUGFeRDXmlHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localInvoice = invoice;
    auto localProfile = profile;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(buildXml(localInvoice, localProfile));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}

IZUGFeRDService ZUGFeRDService() {
  return new UIMZUGFeRDService();
}

unittest {
  ZUGFeRDParty seller;
  seller.name = "Seller GmbH";

  ZUGFeRDParty buyer;
  buyer.name = "Buyer AG";

  ZUGFeRDInvoiceLine line;
  line.id = "1";
  line.name = "Subscription";
  line.quantity = 3;
  line.netPrice = 10;
  line.lineTotal = 30;
  line.taxPercent = 19;

  auto invoice = ZUGFeRDInvoice()
    .id("INV-2")
    .issueDate("20260721")
    .currency("EUR")
    .seller(seller)
    .buyer(buyer)
    .addLine(line)
    .netAmount(30)
    .taxAmount(5.70)
    .grossAmount(35.70);

  auto service = ZUGFeRDService();
  assert(service.validate(invoice));

  auto xml = service.buildXml(invoice, ZUGFeRDProfile.en16931);
  assert(xml.length > 0);

  auto pdf = cast(ubyte[]) "%PDF-1.7\n".dup;
  auto packed = service.embedXmlInPdf(pdf, xml, "factur-x.xml");
  auto unpacked = service.extractXmlFromPdf(packed);
  assert(unpacked.length > 0);
}
