/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Generic OData v4 HTTP endpoint for SAP Fiori / UI5 (sap.ui.model.odata.v4.ODataModel).
///
///   GET    <root>/                         service document
///   GET    <root>/$metadata                CSDL with Fiori annotations
///   POST   <root>/$batch                   multipart/mixed or JSON batch
///   GET    <root>/<Set>[?$filter&$orderby&$select&$top&$skip&$skiptoken&$count&$search]
///   GET    <root>/<Set>/$count
///   GET    <root>/<Set>('<key>')
///   POST   <root>/<Set>                    if insertable
///   PATCH  <root>/<Set>('<key>')           if updatable (PUT is treated as PATCH)
///   DELETE <root>/<Set>('<key>')           if deletable
///   GET    <root>/<Singleton>              PATCH if updatable
///   POST   <root>/<Action>                 unbound action, JSON parameters
///
/// Honours "Prefer: return=minimal", "IEEE754Compatible=true" and answers
/// "X-CSRF-Token: Fetch". Change sets are executed sequentially and are not
/// atomic: providers have no transaction port.
module uim.service.presentation.odata.controller;

import vibe.http.router : URLRouter;
import vibe.http.server : HTTPServerRequest, HTTPServerResponse;
import vibe.http.common : HTTPMethod;
import vibe.stream.operations : readAllUTF8;
import vibe.textfilter.urlencode : urlDecode, urlEncode;
import uim.service;
import uim.service.ports.services.context;
import uim.service.ports.services.entitysets;
import uim.service.presentation.odata.model;
import uim.service.presentation.odata.query;
import uim.service.presentation.odata.metadata;
import uim.service.presentation.odata.resource;
import uim.service.presentation.odata.batch;
import uim.service.presentation.odata.engine;
import uim.service.infrastructure.security.context;

mixin(ShowModule!());

@safe:

class ODataController {
  protected ODataEngine engine;
  protected string root; /// service root path, e.g. "/odata/v4/demo"
  protected string defaultTenant;
  protected string metadataXml;
  protected string csrfToken;

  /// Optional token verifier (see infrastructure.security).
  ITokenVerifier verifier;

  /// Reject requests without a verified token (401).
  bool requireAuthentication;

  /// Override the RequestContext resolution (e.g. for custom headers).
  RequestContext delegate(HTTPServerRequest req) @safe contextResolver;

  /// Maximum accepted request body in bytes.
  size_t maxBodySize = 10 * 1024 * 1024;

  this(ODataEngine engine, string serviceRoot, string defaultTenant = "default") @trusted {
    import std.uuid : randomUUID;

    this.engine = engine;
    this.root = "/" ~ serviceRoot.strip("/");
    this.defaultTenant = defaultTenant;
    this.metadataXml = buildODataMetadata(engine.model);
    this.csrfToken = randomUUID.toString;
  }

  string serviceRoot() const {
    return root;
  }

  void registerRoutes(URLRouter router) {
    router.any(root, &handle);
    router.any(root ~ "/*", &handle);
  }

  // ── vibe.d entry point ──────────────────────────────────────────────────

  void handle(HTTPServerRequest req, HTTPServerResponse res) @trusted {
    ODataHttpResponse response;
    try {
      auto ctx = contextResolver !is null ? contextResolver(req) : resolveRequestContext(req.headers.get("Authorization",
          ""), req.headers.get("X-Tenant-Id", ""), req.headers.get("X-User-Id", ""), defaultTenant, verifier);
      ctx.channel = "odata";

      ODataHttpRequest r;
      r.method = req.method.to!string;
      auto fullPath = req.requestPath.toString;
      r.path = urlDecode(fullPath.length > root.length ? fullPath[root.length .. $] : "");
      r.query = parseODataQueryString(req.queryString);
      foreach (name, value; req.headers.byKeyValue)
        r.headers[name.toLower] = value;
      if (req.method != HTTPMethod.GET && req.method != HTTPMethod.HEAD && req.method != HTTPMethod.DELETE)
        r.body = req.bodyReader.readAllUTF8(false, maxBodySize);

      if (r.header("x-csrf-token").toLower == "fetch")
        res.headers["X-CSRF-Token"] = csrfToken;

      if (requireAuthentication && !ctx.authenticated)
        response = error(401, "Unauthorized", "A valid bearer token is required");
      else
        response = dispatch(ctx, r, true);
    } catch (Exception e) {
      response = toErrorResponse(e);
    }

    foreach (name, value; response.headers)
      if (name != "Content-Type")
        res.headers[name] = value;
    res.statusCode = response.status;
    if (response.status == 204 || req.method == HTTPMethod.HEAD)
      res.writeVoidBody();
    else
      res.writeBody(response.body, response.headers.get("Content-Type", "application/json"));
  }

  // ── protocol dispatch (shared by top-level requests and $batch) ─────────

  ODataHttpResponse dispatch(const RequestContext ctx, ODataHttpRequest r, bool topLevel = false) {
    try {
      auto path = r.path.strip("/");
      if (path.length == 0) {
        requireMethod(r, "GET", "HEAD");
        return json(200, buildODataServiceDocument(engine.model, root ~ "/$metadata"));
      }
      if (path == "$metadata") {
        requireMethod(r, "GET", "HEAD");
        auto res = ODataHttpResponse(200);
        res.headers["Content-Type"] = "application/xml";
        res.headers["OData-Version"] = "4.0";
        res.body = metadataXml;
        return res;
      }
      if (path == "$batch") {
        if (!topLevel)
          throw new EntitySetException(400, "InvalidBatch", "Nested $batch requests are not allowed");
        requireMethod(r, "POST");
        return executeBatch(ctx, r);
      }

      auto resource = parseODataResource(path);
      if (engine.model.findAction(resource.name) !is null) {
        requireMethod(r, "POST");
        return invokeAction(ctx, resource.name, r);
      }

      auto set = engine.setOf(resource.name);
      bool ieee = ieee754Compatible(r);
      switch (r.method) {
      case "GET", "HEAD":
        if (set.singleton)
          return entity(200, set, engine.read(ctx, set.name, ""), ieee);
        if (resource.hasKey)
          return entity(200, set, engine.read(ctx, set.name, resource.key), ieee);
        return collection(ctx, set, r, resource.countOnly, ieee);

      case "POST":
        if (resource.hasKey || set.singleton)
          throw EntitySetException.notSupported("POST on " ~ path);
        auto created = engine.create(ctx, set.name, parseBody(r));
        auto location = root ~ "/" ~ set.name ~ "(" ~ formatODataKey(keyString(created[set.key]),
          isNumericKey(set)) ~ ")";
        auto res = preferMinimal(r) ? noContent() : entity(201, set, created, ieee);
        res.headers["Location"] = location;
        res.headers["OData-EntityId"] = location;
        return res;

      case "PATCH", "PUT", "MERGE":
        if (!resource.hasKey && !set.singleton)
          throw EntitySetException.notSupported(r.method ~ " on a collection");
        auto updated = engine.update(ctx, set.name, resource.key, parseBody(r));
        return preferMinimal(r) ? noContent() : entity(200, set, updated, ieee);

      case "DELETE":
        if (!resource.hasKey)
          throw EntitySetException.notSupported("DELETE on a collection");
        engine.remove(ctx, set.name, resource.key);
        return noContent();

      default:
        throw new EntitySetException(405, "MethodNotAllowed", "Method " ~ r.method ~ " is not allowed");
      }
    } catch (Exception e) {
      return toErrorResponse(e);
    }
  }

  // ── reading ─────────────────────────────────────────────────────────────

  protected ODataHttpResponse collection(const RequestContext ctx, ODataEntitySetDef set,
      ODataHttpRequest r, bool countOnly, bool ieee) {
    auto query = parseODataQuery((name) => r.query.get(name, ""), set.propertyNames, set.key);
    auto page = engine.query(ctx, set.name, query);

    if (countOnly) {
      auto res = ODataHttpResponse(200);
      res.headers["Content-Type"] = "text/plain";
      res.headers["OData-Version"] = "4.0";
      res.body = page.total.to!string;
      return res;
    }

    auto context = root ~ "/$metadata#" ~ set.name;
    if (query.select.length > 0)
      context ~= "(" ~ query.select.join(",") ~ ")";

    auto payload = Json.emptyObject;
    payload["@odata.context"] = context;
    if (query.count)
      payload["@odata.count"] = ieee ? Json(page.total.to!string) : Json(page.total);
    auto value = Json.emptyArray;
    foreach (row; page.rows)
      value ~= toWire(set, row, ieee);
    payload["value"] = value;
    if (page.nextSkip > 0)
      payload["@odata.nextLink"] = nextLink(set, r.query, page.nextSkip);
    return json(200, payload, ieee);
  }

  protected string nextLink(ODataEntitySetDef set, string[string] query, size_t skip) {
    string[] parts;
    foreach (name; query.keys.sort)
      if (name != "$skiptoken" && name != "$skip")
        parts ~= urlEncode(name) ~ "=" ~ urlEncode(query[name]);
    parts ~= "$skiptoken=" ~ skip.to!string;
    return set.name ~ "?" ~ parts.join("&");
  }

  // ── actions ─────────────────────────────────────────────────────────────

  protected ODataHttpResponse invokeAction(const RequestContext ctx, string name, ODataHttpRequest r) {
    auto action = engine.model.findAction(name);
    auto params = r.body.strip.length > 0 ? parseBody(r) : Json.emptyObject;
    auto result = engine.invoke(ctx, name, params);
    if (action.returnType.length == 0 || result.type == Json.Type.null_ || result.type == Json.Type.undefined)
      return noContent();

    auto payload = Json.emptyObject;
    auto typeName = action.returnEdmType;
    payload["@odata.context"] = root ~ "/$metadata#" ~ typeName;
    if (result.isObject && !action.returnsCollection)
      foreach (k, v; result.get!(Json[string]))
        payload[k] = v;
    else
      payload["value"] = result;
    return json(200, payload);
  }

  // ── $batch ──────────────────────────────────────────────────────────────

  protected ODataHttpResponse executeBatch(const RequestContext ctx, ODataHttpRequest r) {
    auto type = r.header("content-type").toLower;
    if (type.startsWith("application/json"))
      return executeJsonBatch(ctx, r);
    if (!type.startsWith("multipart/mixed"))
      throw new EntitySetException(415, "UnsupportedMediaType", "$batch expects multipart/mixed or application/json");

    auto items = parseBatch(r.body, r.header("content-type"), &resolveTarget);
    ODataBatchResult[] results;
    foreach (item; items) {
      if (!item.isChangeSet) {
        // OData 4.01: a modifying request outside a change set is its own atomicity group (UI5 sends these)
        results ~= ODataBatchResult(false, dispatch(ctx, item.request));
        continue;
      }
      // change set: executed in order; on the first failure the whole
      // change set is answered with that single error response
      ODataHttpResponse[] responses;
      string[string] locations; // Content-ID → location
      ODataHttpResponse failure;
      bool failed;
      foreach (op; item.changeSet) {
        if (op.method == "GET")
          throw new EntitySetException(400, "InvalidBatch", "GET is not allowed inside a change set");
        if (op.path.startsWith("$")) {
          auto slash = op.path.indexOf('/');
          auto id = op.path[1 .. slash < 0 ? $ : slash];
          if (auto loc = id in locations)
            op.path = *loc ~ (slash < 0 ? "" : op.path[slash .. $]);
        }
        auto res = dispatch(ctx, op);
        res.contentId = op.contentId;
        if (res.status >= 400) {
          failure = res;
          failed = true;
          break;
        }
        if (op.contentId.length > 0 && "Location" in res.headers)
          locations[op.contentId] = res.headers["Location"][root.length .. $].strip("/");
        responses ~= res;
      }
      results ~= failed ? ODataBatchResult(false, failure) : ODataBatchResult(true, ODataHttpResponse.init, responses);
    }

    string boundary;
    auto res = ODataHttpResponse(200);
    res.body = formatBatchResponse(results, boundary);
    res.headers["Content-Type"] = "multipart/mixed; boundary=" ~ boundary;
    res.headers["OData-Version"] = "4.0";
    return res;
  }

  /// OData 4.01 JSON batch: {"requests":[{"id","method","url","headers","body"}]}
  protected ODataHttpResponse executeJsonBatch(const RequestContext ctx, ODataHttpRequest r) @trusted {
    auto payload = parseBody(r);
    if ("requests" !in payload || payload["requests"].type != Json.Type.array)
      throw EntitySetException.invalid("JSON batch requires a 'requests' array");
    if (payload["requests"].length > 1000)
      throw new EntitySetException(413, "BatchTooLarge", "A batch must not contain more than 1000 operations");

    auto responses = Json.emptyArray;
    foreach (item; payload["requests"]) {
      ODataHttpRequest op;
      op.method = item["method"].opt!string("GET").toUpper;
      resolveTarget(item["url"].opt!string(""), op.path, op.query);
      if ("headers" in item && item["headers"].isObject)
        foreach (k, v; item["headers"].get!(Json[string]))
          op.headers[k.toLower] = v.type == Json.Type.string ? v.get!string : v.toString;
      if ("body" in item && item["body"].type != Json.Type.null_)
        op.body = item["body"].toString;
      auto res = dispatch(ctx, op);

      auto entry = Json.emptyObject;
      entry["id"] = item["id"].opt!string("");
      entry["status"] = res.status;
      auto headers = Json.emptyObject;
      foreach (k, v; res.headers)
        headers[k.toLower] = v;
      entry["headers"] = headers;
      if (res.body.length > 0)
        entry["body"] = res.headers.get("Content-Type", "").startsWith("application/json") ? parseJsonString(res.body)
          : Json(res.body);
      responses ~= entry;
    }
    auto result = Json.emptyObject;
    result["responses"] = responses;
    return json(200, result);
  }

  /// Turn a batch request target (relative, absolute path or URL) into a service relative path + query.
  protected void resolveTarget(string target, out string path, out string[string] query) {
    auto t = target.strip;
    auto scheme = t.indexOf("://");
    if (scheme > 0) {
      auto slash = t.indexOf('/', scheme + 3);
      t = slash < 0 ? "/" : t[slash .. $];
    }
    auto q = t.indexOf('?');
    auto rawPath = q < 0 ? t : t[0 .. q];
    query = q < 0 ? null : parseODataQueryString(t[q + 1 .. $]);
    path = urlDecode(rawPath);
    if (path.startsWith(root ~ "/") || path == root)
      path = path[root.length .. $];
    path = path.strip("/");
  }

  // ── helpers ─────────────────────────────────────────────────────────────

  protected static void requireMethod(ODataHttpRequest r, string[] allowed...) {
    if (!allowed.canFind(r.method))
      throw new EntitySetException(405, "MethodNotAllowed", "Method " ~ r.method ~ " is not allowed here");
  }

  protected static bool isNumericKey(ODataEntitySetDef set) {
    auto t = set.propertyOf(set.key).type;
    return t == Edm.int32 || t == Edm.int64;
  }

  protected static bool preferMinimal(ODataHttpRequest r) {
    return r.header("prefer").toLower.canFind("return=minimal");
  }

  protected static bool ieee754Compatible(ODataHttpRequest r) {
    return r.header("accept").canFind("IEEE754Compatible=true") || r.header("content-type")
      .canFind("IEEE754Compatible=true");
  }

  protected Json parseBody(ODataHttpRequest r) @trusted {
    if (r.body.strip.length == 0)
      throw EntitySetException.invalid("Request body is empty");
    Json body;
    try
      body = parseJsonString(r.body);
    catch (Exception e)
      throw EntitySetException.invalid("Request body is not valid JSON: " ~ e.msg);
    if (body.type != Json.Type.object)
      throw EntitySetException.invalid("Request body must be a JSON object");
    return body;
  }

  /// Convert Int64/Decimal values to strings for IEEE754Compatible clients.
  protected static Json toWire(ODataEntitySetDef set, Json row, bool ieee) {
    if (!ieee || !row.isObject)
      return row;
    auto copy = row.clone;
    foreach (p; set.properties)
      if (p.isIeee754Sensitive && p.name in copy && (copy[p.name].type == Json.Type.int_
          || copy[p.name].type == Json.Type.float_))
        copy[p.name] = copy[p.name].toString;
    return copy;
  }

  protected ODataHttpResponse entity(int status, ODataEntitySetDef set, Json row, bool ieee) {
    auto payload = Json.emptyObject;
    payload["@odata.context"] = root ~ "/$metadata#" ~ set.name ~ (set.singleton ? "" : "/$entity");
    foreach (k, v; toWire(set, row, ieee).get!(Json[string]))
      payload[k] = v;
    return json(status, payload, ieee);
  }

  protected static ODataHttpResponse json(int status, Json payload, bool ieee = false) {
    auto res = ODataHttpResponse(status);
    res.headers["Content-Type"] = "application/json;odata.metadata=minimal" ~ (ieee ? ";IEEE754Compatible=true" : "");
    res.headers["OData-Version"] = "4.0";
    res.body = serializeODataPayload(payload);
    return res;
  }

  protected static ODataHttpResponse noContent() {
    auto res = ODataHttpResponse(204);
    res.headers["OData-Version"] = "4.0";
    return res;
  }

  protected static ODataHttpResponse error(int status, string code, string message) {
    auto err = Json.emptyObject;
    err["code"] = code;
    err["message"] = message;
    auto payload = Json.emptyObject;
    payload["error"] = err;
    return json(status, payload);
  }

  protected static ODataHttpResponse toErrorResponse(Exception e) @trusted {
    if (auto ee = cast(EntitySetException) e)
      return error(ee.status, ee.code, ee.msg);
    if (auto qe = cast(ODataQueryException) e)
      return error(400, "InvalidQuery", qe.msg);
    logError("odata: %s", e.toString);
    return error(500, "InternalError", "Internal server error");
  }
}

/// Serialize a payload with the OData control information first, as required
/// by the OData JSON format (@odata.context, then @odata.count / nextLink).
string serializeODataPayload(Json payload) @trusted {
  if (!payload.isObject)
    return payload.toString;
  enum string[] leading = ["@odata.context", "@odata.count", "@odata.nextLink"];
  string[] parts;
  foreach (key; leading)
    if (key in payload)
      parts ~= Json(key).toString ~ ":" ~ payload[key].toString;
  auto map = payload.get!(Json[string]);
  foreach (key; map.keys.sort) // deterministic member order
    if (!leading.canFind(key) && key != "value")
      parts ~= Json(key).toString ~ ":" ~ map[key].toString;
  if ("value" in payload)
    parts ~= `"value":` ~ payload["value"].toString;
  return "{" ~ parts.join(",") ~ "}";
}

///
unittest {
  mixin(ShowTest!("ODataController"));

  import uim.service.application.services.documents : DocumentEntitySetProvider;
  import uim.service.persistence.storages.documents.memory : MemoryDocumentStore;

  auto m = new ODataServiceModel("uim.test", "TestService");
  m.entitySet("Items", "Item").tenantAware().property("name", Edm.string_, "Name", false)
    .property("qty", Edm.int64).writable();
  m.action("Reset", Edm.int32);

  auto store = new MemoryDocumentStore;
  auto engine = new ODataEngine(m);
  engine.provide("Items", new DocumentEntitySetProvider(store, "Items"));
  engine.handle("Reset", (const RequestContext ctx, Json p) @safe => Json(0));
  engine.maxPageSize = 2;
  engine.verify();

  auto c = new ODataController(engine, "/odata/v4/test");
  RequestContext ctx;
  ctx.tenantId = "t1";

  ODataHttpRequest req(string method, string path, string body = "", string[string] query = null) {
    ODataHttpRequest r;
    r.method = method;
    r.path = path;
    r.body = body;
    r.query = query;
    return r;
  }

  assert(c.dispatch(ctx, req("GET", "")).body.startsWith(`{"@odata.context":"/odata/v4/test/$metadata"`));
  auto meta = c.dispatch(ctx, req("GET", "$metadata"));
  assert(meta.headers["Content-Type"] == "application/xml" && meta.body.canFind("EntityContainer"));

  auto created = c.dispatch(ctx, req("POST", "Items", `{"name":"a","qty":3}`));
  assert(created.status == 201, created.body);
  auto id = parseJsonString(created.body)["id"].get!string;
  assert(created.headers["Location"] == "/odata/v4/test/Items('" ~ id ~ "')");

  c.dispatch(ctx, req("POST", "Items", `{"name":"b","qty":1}`));
  c.dispatch(ctx, req("POST", "Items", `{"name":"c","qty":2}`));
  assert(c.dispatch(ctx, req("POST", "Items", `{"qty":2}`)).status == 400); // name is mandatory

  auto page = parseJsonString(c.dispatch(ctx, req("GET", "Items", "", ["$orderby": "name", "$count": "true"])).body);
  assert(page["@odata.count"].get!long == 3);
  assert(page["value"].length == 2 && page["value"][0]["name"].get!string == "a");
  assert(page["@odata.nextLink"].get!string.canFind("$skiptoken=2"));

  assert(c.dispatch(ctx, req("GET", "Items/$count", "", ["$filter": "qty gt 1"])).body == "2");
  assert(c.dispatch(ctx, req("GET", "Items", "", ["$filter": "bogus eq 1"])).status == 400);

  auto patched = c.dispatch(ctx, req("PATCH", "Items('" ~ id ~ "')", `{"qty":9}`));
  assert(parseJsonString(patched.body)["qty"].get!long == 9);
  auto ieee = req("GET", "Items('" ~ id ~ "')");
  ieee.headers["accept"] = "application/json;IEEE754Compatible=true";
  assert(parseJsonString(c.dispatch(ctx, ieee).body)["qty"].get!string == "9");

  assert(c.dispatch(ctx, req("DELETE", "Items('" ~ id ~ "')")).status == 204);
  assert(c.dispatch(ctx, req("GET", "Items('" ~ id ~ "')")).status == 404);
  assert(c.dispatch(ctx, req("POST", "Reset")).status == 200);
  assert(c.dispatch(ctx, req("GET", "Reset")).status == 405);
  assert(c.dispatch(ctx, req("GET", "Nope")).status == 404);

  // other tenant sees nothing
  RequestContext other;
  other.tenantId = "t2";
  assert(c.dispatch(other, req("GET", "Items/$count")).body == "0");

  // multipart $batch with a read and a change set
  auto batch = req("POST", "$batch",
    "--b\r\nContent-Type: application/http\r\n\r\nGET Items?$top=1 HTTP/1.1\r\n\r\n\r\n"
      ~ "--b\r\nContent-Type: multipart/mixed; boundary=cs\r\n\r\n"
      ~ "--cs\r\nContent-Type: application/http\r\nContent-ID: 1\r\n\r\n"
      ~ "POST /odata/v4/test/Items HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"z\"}\r\n"
      ~ "--cs\r\nContent-Type: application/http\r\nContent-ID: 2\r\n\r\n"
      ~ "PATCH $1 HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"qty\":7}\r\n"
      ~ "--cs--\r\n--b--\r\n");
  batch.headers["content-type"] = "multipart/mixed; boundary=b";
  auto batchRes = c.dispatch(ctx, batch, true);
  assert(batchRes.status == 200, batchRes.body);
  assert(batchRes.body.canFind("HTTP/1.1 201 Created"));
  assert(batchRes.body.canFind(`"qty":7`));

  // JSON batch
  auto jsonBatch = req("POST", "$batch", `{"requests":[{"id":"r1","method":"get","url":"Items?$filter=name eq 'z'"}]}`);
  jsonBatch.headers["content-type"] = "application/json";
  auto jb = parseJsonString(c.dispatch(ctx, jsonBatch, true).body);
  assert(jb["responses"][0]["status"].get!long == 200);
  assert(jb["responses"][0]["body"]["value"][0]["qty"].get!long == 7);
}
