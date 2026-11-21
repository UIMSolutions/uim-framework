/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// OData resource path parsing (the part after the service root).
module uim.service.presentation.odata.resource;

import uim.service;
import uim.service.ports.services.entitysets : EntitySetException;

mixin(ShowModule!());

@safe:

/// The parsed resource path.
struct ODataResource {
  string name; /// entity set, singleton or action ("" = service document)
  string key; /// entity key, if addressed
  bool hasKey;
  bool countOnly; /// <Set>/$count
}

/// Parse "Items", "Items/$count", "Items('a')", "Items(42)", "Items(id='a')", "Action()".
/// The path must already be URL decoded.
ODataResource parseODataResource(string path) {
  ODataResource r;
  auto p = path.strip.strip("/");
  if (p.endsWith("/$count")) {
    r.countOnly = true;
    p = p[0 .. $ - "/$count".length];
  }
  if (p.canFind("/"))
    throw new EntitySetException(400, "UnsupportedPath", "Navigation and property paths are not supported: " ~ path);

  auto open = p.indexOf('(');
  if (open < 0) {
    r.name = p;
    return r;
  }
  if (!p.endsWith(")"))
    throw new EntitySetException(400, "InvalidKey", "Invalid key in " ~ path);

  r.name = p[0 .. open];
  auto key = p[open + 1 .. $ - 1].strip;
  if (key.length == 0) // "Action()" — no key
    return r;

  // single named key "id='a'" (composite keys are not supported)
  auto eq = key.indexOf('=');
  if (eq >= 0 && (key.indexOf('\'') < 0 || eq < key.indexOf('\''))) {
    if (key.canFind(","))
      throw new EntitySetException(400, "InvalidKey", "Composite keys are not supported: " ~ path);
    key = key[eq + 1 .. $].strip;
  }
  if (key.length >= 2 && key[0] == '\'' && key[$ - 1] == '\'')
    key = key[1 .. $ - 1].replace("''", "'");
  else if (key.canFind("'"))
    throw new EntitySetException(400, "InvalidKey", "Invalid key literal in " ~ path);
  r.key = key;
  r.hasKey = true;
  return r;
}

/// Format a key for a URL: strings are quoted, numeric keys are not.
string formatODataKey(string key, bool numeric) {
  return numeric ? key : "'" ~ key.replace("'", "''") ~ "'";
}

///
unittest {
  mixin(ShowTest!("parseODataResource"));

  auto r = parseODataResource("/Items");
  assert(r.name == "Items" && !r.hasKey && !r.countOnly);

  r = parseODataResource("Items('a''b')");
  assert(r.name == "Items" && r.hasKey && r.key == "a'b");

  r = parseODataResource("Items(id='x=y')");
  assert(r.key == "x=y");

  r = parseODataResource("Items('k=v')");
  assert(r.key == "k=v");

  r = parseODataResource("Items(42)");
  assert(r.key == "42");

  r = parseODataResource("Items/$count");
  assert(r.countOnly && r.name == "Items");

  r = parseODataResource("Recalculate()");
  assert(r.name == "Recalculate" && !r.hasKey);

  assert(parseODataResource("").name == "");

  foreach (bad; ["Items('a')/name", "Items('a'", "Items(a='1',b='2')"]) {
    bool failed;
    try
      parseODataResource(bad);
    catch (EntitySetException)
      failed = true;
    assert(failed, bad);
  }

  assert(formatODataKey("a'b", false) == "'a''b'");
  assert(formatODataKey("7", true) == "7");
}
