# UIM-ZUGFERD

`uim-zugferd` is a D/vibe.d library for creating and processing hybrid PDF e-invoices based on **Factur-X / ZUGFeRD** profiles.

## Scope

The library focuses on practical integration workflows:

- Build CrossIndustryInvoice XML payloads from typed invoice models.
- Detect ZUGFeRD/Factur-X profile from XML payloads.
- Embed XML into PDF payloads (attachment marker strategy for app-level exchange).
- Extract embedded XML from processed PDF payloads.

## Standards Context

The implementation targets the Factur-X/ZUGFeRD ecosystem and profile semantics commonly used for:

- `MINIMUM`
- `BASIC WL`
- `BASIC`
- `EN 16931`
- `EXTENDED`
- `XRECHNUNG`

References:

- https://www.ferd-net.de/publikationen-produkte/publikationen/detailseite/zugferd-25-english
- https://github.com/zugferd

## Installation

From the monorepo root, `zugferd` is already included as a subpackage.

Standalone dependency declaration:

```sdl
dependency "uim-framework:zugferd" version="*"
```

## Quick Start

```d
import uim.zugferd;

void main() {
  ZUGFeRDParty seller;
  seller.name = "Seller GmbH";

  ZUGFeRDParty buyer;
  buyer.name = "Buyer AG";

  ZUGFeRDInvoiceLine line;
  line.id = "1";
  line.name = "Consulting";
  line.quantity = 2;
  line.netPrice = 100;
  line.lineTotal = 200;
  line.taxPercent = 19;

  auto invoice = ZUGFeRDInvoice()
    .id("INV-2026-001")
    .issueDate("20260721")
    .currency("EUR")
    .seller(seller)
    .buyer(buyer)
    .addLine(line)
    .netAmount(200)
    .taxAmount(38)
    .grossAmount(238);

  auto service = ZUGFeRDService();
  auto xml = service.buildXml(invoice, ZUGFeRDProfile.en16931);

  auto inputPdf = cast(ubyte[]) "%PDF-1.7\n".dup;
  auto outputPdf = service.embedXmlInPdf(inputPdf, xml, "factur-x.xml");
  auto extracted = service.extractXmlFromPdf(outputPdf);

  assert(extracted.length > 0);
}
```

## Package Structure

- `source/uim/zugferd/interfaces/invoice.d`
- `source/uim/zugferd/models/invoice.d`
- `source/uim/zugferd/helpers/codec.d`
- `source/uim/zugferd/service.d`

## Limitations

- PDF embedding currently uses a deterministic marker strategy suitable for app workflows, not full PDF/A-3 object graph rewriting.
- XML generation is intentionally compact and can be extended per CIUS/XRechnung business rules.

## Testing

Run from module folder:

```bash
dub test
```

Run full monorepo integration checks from repository root:

```bash
dub test
```
