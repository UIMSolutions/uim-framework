/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datasources.transforms.transformer;

import uim.datasources;

mixin(ShowModule!());

@safe:

/**
 * Data transformation interface
 */
interface ITransformer {
  /**
   * Transform a single value
   */
  Json transform(Json value) @safe;

  /**
   * Transform multiple values
   */
  Json[] transformArray(Json[] values) @safe;
}

/**
 * Field mapper for data transformation
 */
class FieldMapper : UIMObject {
  protected string _from;
  protected string _to;
  protected ITransformer _transformer;

  this(string from, string to, ITransformer transformer = null) {
    super();
    _from = from;
    _to = to;
    _transformer = transformer;
  }

  string fromField() { return _from; }
  string toField() { return _to; }

  Json mapValue(Json value) {
    if (_transformer !is null) {
      return _transformer.transform(value);
    }
    return value;
  }
}

/**
 * Data transformer for mapping/transforming records
 */
class DataTransformer : UIMObject {
  protected FieldMapper[] _mappings;

  this() {
    super();
  }

  void addMapping(string from, string to) {
    _mappings ~= new FieldMapper(from, to);
  }

  void addMappingWithTransformer(string from, string to, ITransformer transformer) {
    _mappings ~= new FieldMapper(from, to, transformer);
  }

  Json transformRecord(Json record) {
    Json result = Json.emptyObject();

    if (record.type == Json.Type.object) {
      foreach (key, value; record.byKeyValue()) {
        bool mapped = false;
        foreach (mapping; _mappings) {
          if (mapping.fromField() == key) {
            result[mapping.toField()] = mapping.mapValue(value);
            mapped = true;
            break;
          }
        }
        if (!mapped) {
          result[key] = value;
        }
      }
    }

    return result;
  }

  Json[] transformRecords(Json[] records) {
    Json[] results;
    foreach (record; records) {
      results ~= transformRecord(record);
    }
    return results;
  }

  void reset() {
    _mappings = [];
  }
}

/**
 * String transformation helper
 */
class StringTransformer : UIMObject, ITransformer {
  enum TransformType {
    UpperCase,
    LowerCase,
    Trim,
    Capitalize
  }

  protected TransformType _type;

  this(TransformType type) {
    super();
    _type = type;
  }

  Json transform(Json value) {
    if (value.type != Json.Type.string) {
      return value;
    }

    string str = value.get!string;

    final switch (_type) {
      case TransformType.UpperCase:
        import std.string : toUpper;
        return Json(str.toUpper());
      case TransformType.LowerCase:
        import std.string : toLower;
        return Json(str.toLower());
      case TransformType.Trim:
        import std.string : strip;
        return Json(str.strip());
      case TransformType.Capitalize:
        if (str.length > 0) {
          import std.string : toUpper;
          return Json(str[0].toUpper() ~ str[1..$]);
        }
        return Json(str);
    }
  }

  Json[] transformArray(Json[] values) {
    Json[] results;
    foreach (value; values) {
      results ~= transform(value);
    }
    return results;
  }
}

/**
 * Number formatting transformer
 */
class NumberTransformer : UIMObject, ITransformer {
  protected int _decimalPlaces = 2;

  this(int decimals = 2) {
    super();
    _decimalPlaces = decimals;
  }

  Json transform(Json value) {
    if (value.type == Json.Type.float_ || value.type == Json.Type.int_) {
      double num = value.to!double;
      import std.format : format;
      string formatted = format("%.*f", _decimalPlaces, num);
      return Json(formatted);
    }
    return value;
  }

  Json[] transformArray(Json[] values) {
    Json[] results;
    foreach (value; values) {
      results ~= transform(value);
    }
    return results;
  }
}
