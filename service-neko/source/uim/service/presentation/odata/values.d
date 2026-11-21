/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Conversion between user typed text (CLI options, GUI entries) and the JSON
/// representation of EDM typed values.
module uim.service.presentation.odata.values;

import uim.service;
import uim.service.ports.services.entitysets : EntitySetException;
import uim.service.presentation.odata.model;

mixin(ShowModule!());

@safe:

/// Parse text into the JSON value of a property. Collections are comma
/// separated; complex values are JSON. Throws EntitySetException (400).
Json parseODataValue(const ODataPropertyDef def, string text) @trusted {
  auto t = text.strip;
  string what = "'" ~ def.name ~ "'";

  if (def.collection) {
    if (t.startsWith("["))
      return parseJsonString(t);
    auto item = ODataPropertyDef(def.name, def.type, true);
    auto values = Json.emptyArray;
    foreach (part; t.split(",").map!(s => s.strip).filter!(s => s.length > 0))
      values ~= parseODataValue(item, part);
    return values;
  }
  if (!def.isPrimitive)
    return t.length == 0 ? Json(null) : parseJsonString(t);

  if (t.length == 0 && def.type != Edm.string_)
    return Json(null);
  try {
    switch (def.type) {
    case Edm.boolean:
      auto b = t.toLower;
      if (["true", "yes", "1", "on", "x"].canFind(b))
        return Json(true);
      if (["false", "no", "0", "off", ""].canFind(b))
        return Json(false);
      throw new EntitySetException(400, "BadRequest", what ~ " expects true or false, got '" ~ text ~ "'");
    case Edm.int32, Edm.int64:
      return Json(t.to!long);
    case Edm.decimal, Edm.double_:
      auto d = t.to!double;
      return d == cast(long) d && !t.canFind(".") ? Json(cast(long) d) : Json(d);
    case Edm.dateTimeOffset:
      // accept "2026-11-09", "2026-11-09 10:00" and full ISO 8601
      auto v = t.replace(" ", "T");
      if (v.length == 10)
        v ~= "T00:00:00";
      if (v.length == 16)
        v ~= ":00";
      if (!v.endsWith("Z") && v.length >= 19 && !v[19 .. $].canFind('+') && !v[19 .. $].canFind('-'))
        v ~= "Z";
      return Json(SysTime.fromISOExtString(v).toUTC.toISOExtString);
    default:
      return Json(text);
    }
  } catch (EntitySetException e) {
    throw e;
  } catch (Exception e) {
    throw new EntitySetException(400, "BadRequest", what ~ " expects " ~ def.type ~ ", got '" ~ text ~ "'");
  }
}

/// Text for editing a value (inverse of parseODataValue).
string formatODataValue(const ODataPropertyDef def, Json value) {
  switch (value.type) {
  case Json.Type.null_, Json.Type.undefined:
    return "";
  case Json.Type.string:
    return value.get!string;
  case Json.Type.array:
    if (!def.isPrimitive)
      return value.toString;
    return value.get!(Json[]).map!(v => v.type == Json.Type.string ? v.get!string : v.toString).join(", ");
  default:
    return value.toString;
  }
}

///
unittest {
  mixin(ShowTest!("parseODataValue"));

  assert(parseODataValue(ODataPropertyDef("n", Edm.int32), "42").get!long == 42);
  assert(parseODataValue(ODataPropertyDef("b", Edm.boolean), "yes").get!bool);
  assert(parseODataValue(ODataPropertyDef("d", Edm.decimal), "1.5").get!double == 1.5);
  assert(parseODataValue(ODataPropertyDef("d", Edm.decimal), "2").get!long == 2);
  assert(parseODataValue(ODataPropertyDef("n", Edm.int32), "").type == Json.Type.null_);
  assert(parseODataValue(ODataPropertyDef("t", Edm.dateTimeOffset), "2026-11-09").get!string == "2026-11-09T00:00:00Z");
  auto tags = ODataPropertyDef("tags", Edm.string_, true, true);
  assert(parseODataValue(tags, "a, b").length == 2);
  assert(formatODataValue(tags, parseODataValue(tags, "a, b")) == "a, b");

  bool failed;
  try
    parseODataValue(ODataPropertyDef("n", Edm.int32), "x");
  catch (EntitySetException e)
    failed = e.status == 400;
  assert(failed);
}
