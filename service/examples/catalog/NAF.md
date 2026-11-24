# NAF v4 — Catalog Reference Service

| View | Content |
|---|---|
| **C1 Capability** | Maintain products and categories; reprice active products; catalog statistics |
| **NSV-1 Services** | OData v4 `/odata/v4/catalog` (Products, Categories, Statistics, Reprice), `/health`; CLI `uim-catalog-cli`; GUI `uim-catalog-gui` |
| **NOV-2 Flows** | Browser → approuter (XSUAA login, CSRF) → backend OData; admin shell → CLI → shared store; desktop → GUI → shared store |
| **NLV-1 Data** | Product (sku*, name*, price, currency, stock, status, categoryId, tags, releaseDate) — Category (name*, description) — Statistic (singleton, derived) |
| **NPV-1 Deployment** | CF: `catalog-srv` (binary buildpack), `catalog-approuter` (Node.js), `catalog-xsuaa` (managed service) |
| **NSOV Rules** | SKU `[A-Z][A-Z0-9-]{2,19}`, unique per tenant, immutable; price/stock ≥ 0; discontinued is final; categories in use cannot be deleted |
| **Security** | Scopes `$XSAPPNAME.Read` / `.Write`; role collections CatalogViewer / CatalogManager; RS256 token validation in the backend |
