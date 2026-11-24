/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// The EDM model of the catalog — the single description that drives the
/// OData endpoint, the CLI and the GtkD GUI.
module uim.catalog.presentation.odata;

import uim.service;
import uim.service.presentation.odata;
import uim.catalog.application.catalog;

@safe:

ODataServiceModel catalogModel() {
  auto m = new ODataServiceModel("uim.catalog", "CatalogService", "Product Catalog");

  m.entitySet("Products", "Product")
    .tenantAware()
    .property("sku", Edm.string_, "SKU", false)
    .property("name", Edm.string_, "Name", false)
    .property("description", Edm.string_, "Description")
    .property("categoryId", Edm.string_, "Category")
    .property("price", Edm.decimal, "Price")
    .property("currency", Edm.string_, "Currency")
    .property("stock", Edm.int32, "Stock")
    .property("status", Edm.string_, "Status")
    .property("releaseDate", Edm.date, "Release Date")
    .collection("tags", Edm.string_, "Tags")
    .immutableProps("sku")
    .writable()
    .titled("Product", "Products", "name", "sku")
    .columns("sku", "name", "price", "currency", "stock", "status")
    .filters("sku", "name", "status", "categoryId")
    .scopes("Read", "Write");

  m.entitySet("Categories", "Category")
    .tenantAware()
    .property("name", Edm.string_, "Name", false)
    .property("description", Edm.string_, "Description")
    .writable()
    .titled("Category", "Categories", "name")
    .columns("name", "description")
    .scopes("Read", "Write");

  m.singletonSet("Statistics", "Statistic")
    .keyed("tenantId")
    .property("tenantId", Edm.string_, "Tenant", false)
    .property("products", Edm.int32, "Products")
    .property("activeProducts", Edm.int32, "Active Products")
    .property("categories", Edm.int32, "Categories")
    .property("unitsInStock", Edm.int64, "Units in Stock")
    .property("stockValue", Edm.decimal, "Stock Value")
    .titled("Statistic", "Statistics", "tenantId")
    .scopes("Read", "");

  m.complexType("RepriceResult").property("changed", Edm.int32, "Changed Products").property("percent", Edm.decimal, "Percent");
  m.action("Reprice", "RepriceResult")
    .parameter("percent", Edm.decimal, false)
    .parameter("categoryId", Edm.string_)
    .labelled("Change prices of active products")
    .requires("Write");
  return m;
}

/// Bind the model to the application.
ODataEngine catalogEngine(CatalogApplication app, size_t maxPageSize = 0) {
  auto engine = new ODataEngine(catalogModel());
  engine.provide("Products", app.products)
    .provide("Categories", app.categories)
    .provide("Statistics", app.statistics)
    .handle("Reprice", (const RequestContext ctx, Json params) @safe => app.repriceProducts(ctx, params));
  engine.maxPageSize = maxPageSize;
  engine.verify();
  return engine;
}

///
unittest {
  auto app = new CatalogApplication(new MemoryDocumentStore);
  auto engine = catalogEngine(app);
  auto ctx = RequestContext.local("t1", "test", "tester");

  auto cat = engine.create(ctx, "Categories", parseJsonString(`{"name":"Fasteners"}`));
  auto p = engine.create(ctx, "Products", parseJsonString(`{"sku":"BOLT-M8","name":"Bolt","price":2,"stock":10,"categoryId":"`
      ~ cat["id"].get!string ~ `"}`));
  assert(p["status"].get!string == "draft");

  int status(scope void delegate() @safe dg) {
    try
      dg();
    catch (EntitySetException e)
      return e.status;
    return 0;
  }

  assert(status(() { engine.create(ctx, "Products", parseJsonString(`{"sku":"BOLT-M8","name":"Dup"}`)); }) == 409);
  assert(status(() { engine.create(ctx, "Products", parseJsonString(`{"sku":"bad","name":"x"}`)); }) == 422);
  assert(status(() { engine.create(ctx, "Products", parseJsonString(`{"sku":"NUT-1","name":"x","categoryId":"nope"}`)); }) == 422);
  assert(status(() { engine.remove(ctx, "Categories", cat["id"].get!string); }) == 422);

  engine.update(ctx, "Products", p["id"].get!string, parseJsonString(`{"status":"active"}`));
  auto result = engine.invoke(ctx, "Reprice", parseJsonString(`{"percent":50}`));
  assert(result["changed"].get!long == 1);
  assert(engine.read(ctx, "Products", p["id"].get!string)["price"].get!double == 3.0);

  auto stats = engine.read(ctx, "Statistics", "");
  assert(stats["products"].get!long == 1 && stats["stockValue"].get!double == 30.0);

  engine.update(ctx, "Products", p["id"].get!string, parseJsonString(`{"status":"discontinued"}`));
  assert(status(() { engine.update(ctx, "Products", p["id"].get!string, parseJsonString(`{"status":"active"}`)); }) == 422);
}
