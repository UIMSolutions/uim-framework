/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Domain rules of the catalog — pure functions, no framework or adapter dependencies.
module uim.catalog.domain.products;

import std.algorithm : all, canFind;
import std.ascii : isAlphaNum, isUpper, isDigit;
import std.math : round;
import vibe.data.json : Json;

@safe:

/// A business rule was violated (mapped to HTTP 422 by the application layer).
class CatalogRuleViolation : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__) pure nothrow {
    super(msg, file, line);
  }
}

enum ProductStatus : string {
  draft = "draft",
  active = "active",
  discontinued = "discontinued",
}

/// SKU: 3-20 characters, upper case letters, digits and '-', starting with a letter.
bool isValidSku(string sku) pure {
  return sku.length >= 3 && sku.length <= 20 && isUpper(sku[0])
    && sku.all!(c => isUpper(c) || isDigit(c) || c == '-');
}

/// Validate a product document (after the update has been merged in).
void validateProduct(Json product) {
  auto sku = "sku" in product ? product["sku"] : Json(null);
  if (sku.type != Json.Type.string || !isValidSku(sku.get!string))
    throw new CatalogRuleViolation("SKU must be 3-20 characters [A-Z0-9-] and start with a letter");

  if ("price" in product && product["price"].type != Json.Type.null_) {
    auto price = product["price"].type == Json.Type.int_ ? cast(double) product["price"].get!long : product["price"].get!double;
    if (price < 0)
      throw new CatalogRuleViolation("Price must not be negative");
  }
  if ("stock" in product && product["stock"].type == Json.Type.int_ && product["stock"].get!long < 0)
    throw new CatalogRuleViolation("Stock must not be negative");

  if ("status" in product && product["status"].type == Json.Type.string)
    if (![cast(string) ProductStatus.draft, ProductStatus.active, ProductStatus.discontinued].canFind(product["status"].get!string))
      throw new CatalogRuleViolation("Status must be draft, active or discontinued");
}

/// A status transition is allowed unless the product is discontinued.
void checkStatusTransition(string from, string to) {
  if (from == ProductStatus.discontinued && to != ProductStatus.discontinued)
    throw new CatalogRuleViolation("A discontinued product cannot be reactivated");
}

/// Apply a percentage to a price, rounded to cents.
double reprice(double price, double percent) pure {
  import std.math : copysign;

  auto cents = price * (100.0 + percent);
  // nudge against binary representation errors (19.99 * 50 = 999.4999…) so halves round up
  return round(cents + copysign(1e-7, cents)) / 100.0;
}

///
unittest {
  assert(isValidSku("BOLT-M8"));
  assert(!isValidSku("bolt"));
  assert(!isValidSku("8BOLT"));
  assert(reprice(10.0, 10) == 11.0);
  assert(reprice(19.99, -50) == 10.0);

  bool failed;
  try
    validateProduct(Json(["sku": Json("OK-1"), "price": Json(-1)]));
  catch (CatalogRuleViolation)
    failed = true;
  assert(failed);
  validateProduct(Json(["sku": Json("OK-1"), "price": Json(2.5), "status": Json("active")]));
}
