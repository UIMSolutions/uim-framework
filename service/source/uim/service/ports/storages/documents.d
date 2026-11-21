/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Driven port for a tenant partitioned JSON document store
/// (collection → tenant → key → document).
module uim.service.ports.storages.documents;

import uim.service;

mixin(ShowModule!());

@safe:

interface IDocumentStore {
  /// All documents of a collection for a tenant (unordered).
  Json[] all(string collection, string tenantId);

  /// One document, or Json(null).
  Json get(string collection, string tenantId, string key);

  /// Insert or replace a document.
  void put(string collection, string tenantId, string key, Json document);

  /// Remove a document; returns false if it did not exist.
  bool remove(string collection, string tenantId, string key);

  /// Number of documents of a collection for a tenant.
  size_t count(string collection, string tenantId);
}
