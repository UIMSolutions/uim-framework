/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.operations.list;

import uim.scim.schemas.resource : ScimSchemaListResponse;
import uim.scim.types.filter;

@safe:

// SCIM list / search request parameters (RFC 7644 §3.4.2)
struct ScimListRequest {
  bool       hasFilter  = false;
  ScimFilter filter;
  string     sortBy;
  string     sortOrder  = "ascending";  // "ascending" or "descending"
  int        startIndex = 1;            // 1-based per SCIM spec
  int        count      = 100;
}

// SCIM list response (RFC 7644 §3.4.2)
struct ScimListResponse(T) {
  string[] schemas      = [ScimSchemaListResponse];
  int      totalResults = 0;
  int      startIndex   = 1;
  int      itemsPerPage = 0;
  T[]      resources;
}

// Factory: no-filter list request
ScimListRequest scimListRequest(int startIndex = 1, int count = 100) nothrow {
  ScimListRequest r;
  r.startIndex = startIndex;
  r.count      = count;
  return r;
}

// Factory: filtered list request
ScimListRequest scimListFiltered(ScimFilter f, int startIndex = 1, int count = 100) nothrow {
  auto r      = scimListRequest(startIndex, count);
  r.hasFilter = true;
  r.filter    = f;
  return r;
}

// Factory: sorted list request
ScimListRequest scimListSorted(string sortBy, string sortOrder = "ascending") nothrow {
  ScimListRequest r;
  r.sortBy    = sortBy;
  r.sortOrder = sortOrder;
  return r;
}

unittest {
  auto r1 = scimListRequest();
  assert(!r1.hasFilter);
  assert(r1.startIndex == 1);

  auto r2 = scimListFiltered(ScimFilter.eq("userName", "alice"));
  assert(r2.hasFilter);
  assert(r2.filter.op == ScimFilterOp.eq);
  assert(r2.filter.value == "alice");

  ScimListResponse!string resp;
  resp.resources = ["a", "b", "c"];
  resp.totalResults = 3;
  assert(resp.totalResults == 3);
  assert(resp.resources.length == 3);
}
