/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.persistence.storages.documents.memory;

import uim.service;
import uim.service.ports.storages.documents;

mixin(ShowModule!());

@safe:

/// Volatile in-process document store. Documents are cloned on the way in
/// and out so callers can never alias stored state.
class MemoryDocumentStore : IDocumentStore {
  protected Json[string][string][string] data; // collection → tenant → key → doc

  Json[] all(string collection, string tenantId) {
    Json[] result;
    if (auto byTenant = collection in data)
      if (auto docs = tenantId in *byTenant)
        foreach (doc; (*docs).byValue)
          result ~= doc.clone;
    return result;
  }

  Json get(string collection, string tenantId, string key) {
    if (auto byTenant = collection in data)
      if (auto docs = tenantId in *byTenant)
        if (auto doc = key in *docs)
          return (*doc).clone;
    return Json(null);
  }

  void put(string collection, string tenantId, string key, Json document) {
    data[collection][tenantId][key] = document.clone;
  }

  bool remove(string collection, string tenantId, string key) {
    if (auto byTenant = collection in data)
      if (auto docs = tenantId in *byTenant)
        return (*docs).remove(key);
    return false;
  }

  size_t count(string collection, string tenantId) {
    if (auto byTenant = collection in data)
      if (auto docs = tenantId in *byTenant)
        return docs.length;
    return 0;
  }

  /// Snapshot of the whole store as {collection: {tenant: {key: doc}}}.
  Json snapshot() {
    auto root = Json.emptyObject;
    foreach (collection, byTenant; data) {
      auto c = Json.emptyObject;
      foreach (tenant, docs; byTenant) {
        auto t = Json.emptyObject;
        foreach (key, doc; docs)
          t[key] = doc.clone;
        c[tenant] = t;
      }
      root[collection] = c;
    }
    return root;
  }

  /// Replace the content with a snapshot produced by snapshot().
  void restore(Json root) {
    data = null;
    if (!root.isObject)
      return;
    foreach (collection, byTenant; root.get!(Json[string]))
      if (byTenant.isObject)
        foreach (tenant, docs; byTenant.get!(Json[string]))
          if (docs.isObject)
            foreach (key, doc; docs.get!(Json[string]))
              data[collection][tenant][key] = doc.clone;
  }
}

///
unittest {
  mixin(ShowTest!("MemoryDocumentStore"));

  auto store = new MemoryDocumentStore;
  auto doc = Json.emptyObject;
  doc["name"] = "a";
  store.put("Things", "t1", "1", doc);
  doc["name"] = "changed"; // no aliasing
  assert(store.get("Things", "t1", "1")["name"].get!string == "a");
  assert(store.count("Things", "t1") == 1);
  assert(store.count("Things", "t2") == 0);
  assert(store.get("Things", "t2", "1").type == Json.Type.null_);

  auto copy = new MemoryDocumentStore;
  copy.restore(store.snapshot);
  assert(copy.all("Things", "t1").length == 1);

  assert(store.remove("Things", "t1", "1"));
  assert(!store.remove("Things", "t1", "1"));
}
