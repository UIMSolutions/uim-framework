/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Application layer: entity-set providers (driving ports) on top of the
/// document store (driven port), with the domain rules plugged in.
module uim.catalog.application.catalog;

import uim.service;
import uim.catalog.domain.products;

@safe:

class CatalogApplication {
  DocumentEntitySetProvider products;
  DocumentEntitySetProvider categories;
  DelegateEntitySetProvider statistics;
  protected IDocumentStore store;

  this(IDocumentStore store) {
    this.store = store;
    products = new DocumentEntitySetProvider(store, "Products");
    categories = new DocumentEntitySetProvider(store, "Categories");

    products.beforeSave = (const RequestContext ctx, Json existing, ref Json doc) @safe {
      if ("status" !in doc || doc["status"].type == Json.Type.null_)
        doc["status"] = cast(string) ProductStatus.draft;
      if (existing.type != Json.Type.null_ && "status" in existing)
        ruled(() { checkStatusTransition(existing["status"].get!string, doc["status"].get!string); });
      if ("categoryId" in doc && doc["categoryId"].type == Json.Type.string && doc["categoryId"].get!string.length > 0
        && categories.get(ctx, doc["categoryId"].get!string).type == Json.Type.null_)
        throw new EntitySetException(422, "BusinessRuleViolation", "Unknown category '" ~ doc["categoryId"].get!string ~ "'");
      foreach (other; products.list(ctx)) // SKU is unique per tenant
        if (other["sku"] == doc["sku"] && other["id"] != doc["id"])
          throw EntitySetException.conflict("SKU '" ~ doc["sku"].get!string ~ "' is already used");
      ruled(() { validateProduct(doc); });
    };

    categories.beforeRemove = (const RequestContext ctx, Json category) @safe {
      foreach (p; products.list(ctx))
        if ("categoryId" in p && p["categoryId"] == category["id"])
          throw new EntitySetException(422, "BusinessRuleViolation", "Category is still used by product " ~ p["sku"].get!string);
    };

    statistics = new DelegateEntitySetProvider;
    statistics.onGet = (const RequestContext ctx, string key) @safe => statisticsOf(ctx);
  }

  /// Aggregated figures of the tenant (singleton "Statistics").
  Json statisticsOf(const RequestContext ctx) {
    auto all = products.list(ctx);
    long active, stock;
    double value = 0;
    foreach (p; all) {
      if (p["status"].opt!string("") == ProductStatus.active)
        active++;
      auto s = p["stock"].type == Json.Type.int_ ? p["stock"].get!long : 0;
      stock += s;
      value += s * numberOf(p["price"]);
    }
    auto stats = Json.emptyObject;
    stats["tenantId"] = ctx.tenantId;
    stats["products"] = all.length;
    stats["activeProducts"] = active;
    stats["categories"] = categories.list(ctx).length;
    stats["unitsInStock"] = stock;
    stats["stockValue"] = value;
    return stats;
  }

  /// Action "Reprice": change the price of all active products (optionally of one category).
  Json repriceProducts(const RequestContext ctx, Json params) {
    auto percent = numberOf(params["percent"]);
    if (percent <= -100 || percent > 1000)
      throw new EntitySetException(422, "BusinessRuleViolation", "percent must be within (-100, 1000]");
    auto category = params["categoryId"].opt!string("");
    long changed;
    foreach (p; products.list(ctx)) {
      if (p["status"].opt!string("") != ProductStatus.active || (category.length && p["categoryId"].opt!string("") != category))
        continue;
      auto patch = Json.emptyObject;
      patch["price"] = reprice(numberOf(p["price"]), percent);
      products.update(ctx, p["id"].get!string, patch);
      changed++;
    }
    auto result = Json.emptyObject;
    result["changed"] = changed;
    result["percent"] = percent;
    return result;
  }

  private static double numberOf(Json v) {
    switch (v.type) {
    case Json.Type.int_:
      return cast(double) v.get!long;
    case Json.Type.float_:
      return v.get!double;
    case Json.Type.string:
      try
        return v.get!string.to!double;
      catch (Exception)
        return 0;
    default:
      return 0;
    }
  }

  private static void ruled(scope void delegate() @safe check) {
    try
      check();
    catch (CatalogRuleViolation e)
      throw new EntitySetException(422, "BusinessRuleViolation", e.msg);
  }
}
