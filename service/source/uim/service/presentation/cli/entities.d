/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Generic, model driven CLI commands for every entity set and action of an
/// ODataEngine:
///
///   sets                                    entity sets, singletons and actions
///   metadata                                CSDL document
///   list   <Set> [--filter= --orderby= --select= --search= --top= --skip= --count]
///   count  <Set> [--filter= --search=]
///   get    <Set> [<key>]                    (no key for singletons)
///   create <Set> [--<property>=<value> ...] [--data=<json>|@file]
///   update <Set> [<key>] [--<property>=<value> ...] [--unset=p1,p2] [--data=...]
///   delete <Set> <key> --yes
///   invoke <Action> [--<parameter>=<value> ...] [--data=...]
module uim.service.presentation.cli.entities;

import uim.service;
import uim.service.presentation.odata.model;
import uim.service.presentation.odata.metadata;
import uim.service.presentation.odata.engine;
import uim.service.presentation.odata.values;
import uim.service.presentation.cli.args;
import uim.service.presentation.cli.table;
import uim.service.presentation.cli.app;

mixin(ShowModule!());

@safe:

private enum string[] reservedOptions = ["tenant", "user", "json", "csv", "help", "data", "yes", "unset"];

/// Register the generic entity commands of an engine on a CLI application.
void registerEntityCommands(CliApplication app, ODataEngine engine) {
  auto model = engine.model;

  ODataEntitySetDef setArg(CliContext c) {
    auto name = c.operand(0, "entity set (see 'sets')");
    auto set = model.find(name);
    if (set is null) // case insensitive convenience
      foreach (s; model.entitySets)
        if (s.name.toLower == name.toLower)
          set = s;
    if (set is null)
      throw new CliUsageError("unknown entity set '" ~ name ~ "' (see 'sets')");
    return set;
  }

  app.command("sets", "", "List entity sets, singletons and actions", (CliContext c) {
    auto data = Json.emptyArray;
    TextTable t;
    t.headers = ["Name", "Kind", "Title", "Operations"];
    foreach (s; model.entitySets) {
      auto ops = ["read"] ~ (s.insertable ? ["create"] : []) ~ (s.updatable ? ["update"] : []) ~ (s.deletable
        ? ["delete"] : []);
      t.rows ~= [s.name, s.singleton ? "singleton" : "entity set", s.displayName, ops.join(", ")];
      auto e = Json.emptyObject;
      e["name"] = s.name;
      e["kind"] = s.singleton ? "Singleton" : "EntitySet";
      e["operations"] = serializeToJson(ops);
      data ~= e;
    }
    foreach (a; model.actions) {
      t.rows ~= [a.name, "action", a.label, a.parameters.map!(p => p.name ~ ":" ~ p.type.replace("Edm.", "")).join(", ")];
      auto e = Json.emptyObject;
      e["name"] = a.name;
      e["kind"] = "Action";
      data ~= e;
    }
    return c.emit(data, t);
  }, []);

  app.command("metadata", "", "Print the OData CSDL ($metadata)", (CliContext c) {
    c.print(buildODataMetadata(model));
    return 0;
  }, []);

  app.command("list", "<Set> [--filter=EXPR] [--orderby=P [desc]] [--select=P,..] [--search=TEXT] [--top=N] [--skip=N] [--count]",
    "List entities using OData query options", (CliContext c) {
    auto set = setArg(c);
    string[string] options;
    foreach (name; ["filter", "orderby", "select", "search", "top", "skip"])
      if (c.args.has(name))
        options["$" ~ name] = c.args.opt(name);
    if (c.args.flag("count"))
      options["$count"] = "true";
    auto page = engine.query(c.request, set.name, options);

    auto columns = c.args.has("select") ? c.args.listOpt("select") : set.listColumns ~ (set.listColumns.canFind(set.key)
      ? [] : [set.key]);
    if (c.json) {
      auto data = Json.emptyObject;
      if (c.args.flag("count"))
        data["count"] = page.total;
      data["value"] = Json(page.rows);
      return c.emit(data, TextTable.init);
    }
    auto code = c.emit(Json.init, TextTable.fromRows(page.rows, columns, columns.map!(n => set.labelOf(n)).array));
    if (!c.csv)
      c.print(format("%d of %d %s\n", page.rows.length, page.total, set.displayName));
    return code;
  }, ["filter", "orderby", "select", "search", "top", "skip", "count"]);

  app.command("count", "<Set> [--filter=EXPR] [--search=TEXT]", "Count entities", (CliContext c) {
    auto set = setArg(c);
    string[string] options;
    foreach (name; ["filter", "search"])
      if (c.args.has(name))
        options["$" ~ name] = c.args.opt(name);
    auto total = engine.query(c.request, set.name, options).total;
    return c.done(Json(total), total.to!string);
  }, ["filter", "search"]);

  app.command("get", "<Set> [<key>]", "Show one entity (or a singleton)", (CliContext c) {
    auto set = setArg(c);
    auto row = engine.read(c.request, set.name, set.singleton ? "" : c.operand(1, "key"));
    return c.emit(row, TextTable.keyValue(row, set.propertyNames, (string n) => set.labelOf(n)));
  }, []);

  app.command("create", "<Set> [--<property>=<value> ...] [--data=JSON|@file]", "Create an entity", (CliContext c) {
    auto set = setArg(c);
    auto created = engine.create(c.request, set.name, payloadOf(c, set.properties, set.name));
    return c.emit(created, TextTable.keyValue(created, set.propertyNames, (string n) => set.labelOf(n)));
  });

  app.command("update", "<Set> [<key>] [--<property>=<value> ...] [--unset=P,..] [--data=JSON|@file]",
    "Update (merge) an entity", (CliContext c) {
    auto set = setArg(c);
    auto key = set.singleton ? "" : c.operand(1, "key");
    auto payload = payloadOf(c, set.properties, set.name);
    foreach (name; c.args.listOpt("unset")) {
      if (!set.hasProperty(name))
        throw new CliUsageError("unknown property '" ~ name ~ "' in --unset");
      payload[name] = Json(null);
    }
    auto updated = engine.update(c.request, set.name, key, payload);
    return c.emit(updated, TextTable.keyValue(updated, set.propertyNames, (string n) => set.labelOf(n)));
  });

  app.command("delete", "<Set> <key> --yes", "Delete an entity", (CliContext c) {
    auto set = setArg(c);
    auto key = c.operand(1, "key");
    if (!c.args.flag("yes"))
      throw new CliUsageError("refusing to delete " ~ set.entityType ~ " '" ~ key ~ "' without --yes");
    engine.remove(c.request, set.name, key);
    auto data = Json.emptyObject;
    data["deleted"] = key;
    return c.done(data, "Deleted " ~ set.entityType ~ " '" ~ key ~ "'");
  }, ["yes"]);

  app.command("invoke", "<Action> [--<parameter>=<value> ...] [--data=JSON|@file]", "Invoke an action", (CliContext c) {
    auto name = c.operand(0, "action (see 'sets')");
    auto action = model.findAction(name);
    if (action is null)
      throw new CliUsageError("unknown action '" ~ name ~ "' (see 'sets')");
    auto result = engine.invoke(c.request, action.name, payloadOf(c, action.parameters, action.name));
    if (result.isObject && !c.json)
      return c.emit(result, TextTable.keyValue(result));
    return c.done(result, result.type == Json.Type.null_ || result.type == Json.Type.undefined ? "OK" : cellText(result));
  });
}

/// Build a payload from --data and --<property>=<value> options.
private Json payloadOf(CliContext c, const ODataPropertyDef[] properties, string target) @trusted {
  Json payload = Json.emptyObject;
  auto data = c.args.opt("data");
  if (data.length > 0) {
    if (data.startsWith("@")) {
      import std.file : readText;

      data = readText(data[1 .. $]);
    }
    payload = parseJsonString(data);
    if (!payload.isObject)
      throw new CliUsageError("--data must be a JSON object");
  }
  foreach (name, text; c.args.options) {
    if (reservedOptions.canFind(name) || c.globalOptions.canFind(name))
      continue;
    auto found = properties.find!(p => p.name == name);
    if (found.empty)
      throw new CliUsageError("unknown property '" ~ name ~ "' of " ~ target);
    payload[name] = parseODataValue(found.front, text);
  }
  return payload;
}

///
unittest {
  mixin(ShowTest!("registerEntityCommands"));

  import uim.service.application.services.documents : DocumentEntitySetProvider;
  import uim.service.persistence.storages.documents.memory : MemoryDocumentStore;

  auto m = new ODataServiceModel("uim.test", "TestService");
  m.entitySet("Items", "Item").tenantAware().property("name", Edm.string_, "Name", false)
    .property("qty", Edm.int32, "Quantity").collection("tags").writable();
  m.action("Echo", Edm.string_).parameter("text", Edm.string_, false);

  auto engine = new ODataEngine(m);
  engine.provide("Items", new DocumentEntitySetProvider(new MemoryDocumentStore, "Items"));
  engine.handle("Echo", (const RequestContext ctx, Json p) @safe => p["text"]);

  string out_;
  auto app = new CliApplication("demo-cli", "Demo", (string s) @safe { out_ ~= s; });
  app.globalOption("data-file", "<path>", "app specific option");
  registerEntityCommands(app, engine);

  assert(app.run(["sets"]) == 0 && out_.canFind("Items") && out_.canFind("Echo"));
  out_ = "";
  assert(app.run(["create", "Items", "--name=Bolt", "--qty=5", "--tags=a,b", "--json"]) == 0, out_);
  auto id = parseJsonString(out_)["id"].get!string;
  assert(parseJsonString(out_)["tags"].length == 2);

  assert(app.run(["create", "items", "--name=Nut", "--qty=1", "--data-file=x"]) == 0); // case insensitive, global option
  out_ = "";
  assert(app.run(["list", "Items", "--filter=qty gt 2", "--count"]) == 0);
  assert(out_.canFind("Bolt") && !out_.canFind("Nut") && out_.canFind("1 of 1"));

  out_ = "";
  assert(app.run(["count", "Items", "--tenant=other"]) == 0 && out_ == "0\n");

  assert(app.run(["update", "Items", id, "--qty=7", "--unset=tags"]) == 0);
  out_ = "";
  assert(app.run(["get", "Items", id, "--json"]) == 0);
  assert(parseJsonString(out_)["qty"].get!long == 7);

  assert(app.run(["create", "Items", "--qty=x", "--name=a"]) == 1); // type error → 400 → exit 1
  assert(app.run(["create", "Items", "--bogus=1"]) == 2);
  assert(app.run(["list", "Items", "--filter=nope eq 1"]) == 2);
  assert(app.run(["delete", "Items", id]) == 2); // --yes missing
  assert(app.run(["delete", "Items", id, "--yes"]) == 0);
  assert(app.run(["get", "Items", id]) == 1);

  out_ = "";
  assert(app.run(["invoke", "Echo", "--text=hi"]) == 0 && out_ == "hi\n");
  out_ = "";
  assert(app.run(["metadata"]) == 0 && out_.canFind("<edmx:Edmx"));
}
