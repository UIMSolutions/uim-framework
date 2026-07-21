/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.zugferd.models.invoice;

import uim.zugferd;

mixin(ShowModule!());

@safe:

class UIMZUGFeRDInvoice : UIMObject, IZUGFeRDInvoice {
  private string _id;
  private string _issueDate;
  private string _currency = "EUR";
  private ZUGFeRDParty _seller;
  private ZUGFeRDParty _buyer;
  private ZUGFeRDInvoiceLine[] _lines;
  private ZUGFeRDTax[] _taxes;
  private double _netAmount;
  private double _taxAmount;
  private double _grossAmount;

  string id() {
    return _id;
  }

  IZUGFeRDInvoice id(string value) {
    _id = value;
    return this;
  }

  string issueDate() {
    return _issueDate;
  }

  IZUGFeRDInvoice issueDate(string value) {
    _issueDate = value;
    return this;
  }

  string currency() {
    return _currency;
  }

  IZUGFeRDInvoice currency(string value) {
    _currency = value;
    return this;
  }

  ZUGFeRDParty seller() {
    return _seller;
  }

  IZUGFeRDInvoice seller(ZUGFeRDParty value) {
    _seller = value;
    return this;
  }

  ZUGFeRDParty buyer() {
    return _buyer;
  }

  IZUGFeRDInvoice buyer(ZUGFeRDParty value) {
    _buyer = value;
    return this;
  }

  ZUGFeRDInvoiceLine[] lines() {
    return _lines.dup;
  }

  IZUGFeRDInvoice lines(const(ZUGFeRDInvoiceLine)[] value) {
    _lines = value.dup;
    return this;
  }

  IZUGFeRDInvoice addLine(ZUGFeRDInvoiceLine value) {
    if (value.id.length > 0) {
      _lines ~= value;
    }

    return this;
  }

  ZUGFeRDTax[] taxes() {
    return _taxes.dup;
  }

  IZUGFeRDInvoice taxes(const(ZUGFeRDTax)[] value) {
    _taxes = value.dup;
    return this;
  }

  IZUGFeRDInvoice addTax(ZUGFeRDTax value) {
    _taxes ~= value;
    return this;
  }

  double netAmount() {
    return _netAmount;
  }

  IZUGFeRDInvoice netAmount(double value) {
    _netAmount = value;
    return this;
  }

  double taxAmount() {
    return _taxAmount;
  }

  IZUGFeRDInvoice taxAmount(double value) {
    _taxAmount = value;
    return this;
  }

  double grossAmount() {
    return _grossAmount;
  }

  IZUGFeRDInvoice grossAmount(double value) {
    _grossAmount = value;
    return this;
  }

  bool isValid() {
    return _id.length > 0
      && _issueDate.length > 0
      && _currency.length == 3
      && _seller.name.length > 0
      && _buyer.name.length > 0
      && _lines.length > 0
      && _grossAmount >= 0;
  }
}

IZUGFeRDInvoice ZUGFeRDInvoice() {
  return new UIMZUGFeRDInvoice();
}

unittest {
  ZUGFeRDParty seller;
  seller.name = "Seller GmbH";
  seller.countryCode = "DE";

  ZUGFeRDParty buyer;
  buyer.name = "Buyer AG";
  buyer.countryCode = "DE";

  ZUGFeRDInvoiceLine line;
  line.id = "1";
  line.name = "Service";
  line.quantity = 2;
  line.netPrice = 50;
  line.lineTotal = 100;
  line.taxPercent = 19;

  auto invoice = ZUGFeRDInvoice()
    .id("INV-2026-0001")
    .issueDate("20260721")
    .currency("EUR")
    .seller(seller)
    .buyer(buyer)
    .addLine(line)
    .netAmount(100)
    .taxAmount(19)
    .grossAmount(119);

  assert(invoice.isValid());
}
