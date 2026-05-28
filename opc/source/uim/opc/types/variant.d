/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.types.variant;

@safe:

// OPC UA built-in data type identifiers (Part 6, Table 1)
enum OpcDataType : uint {
  null_         = 0,
  boolean_      = 1,
  sbyte_        = 2,
  byte_         = 3,
  int16         = 4,
  uint16        = 5,
  int32         = 6,
  uint32        = 7,
  int64         = 8,
  uint64        = 9,
  float_        = 10,
  double_       = 11,
  string_       = 12,
  dateTime      = 13,
  guid          = 14,
  byteString    = 15,
  xmlElement    = 16,
  nodeId        = 17,
  expandedNodeId = 18,
  statusCode    = 19,
  qualifiedName = 20,
  localizedText = 21,
  extensionObject = 22,
  dataValue     = 23,
  variant       = 24,
  diagnosticInfo = 25,
}

// Tagged variant — stores exactly one OPC UA scalar value
struct OpcVariant {
  OpcDataType type = OpcDataType.null_;

  private long   _intVal   = 0;
  private double _floatVal = 0.0;
  private string _textVal;
  private ubyte[] _bytesVal;

  // --- factories ---

  static OpcVariant boolean_(bool v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.boolean_;
    r._intVal = v ? 1 : 0;
    return r;
  }

  static OpcVariant sbyte_(byte v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.sbyte_;
    r._intVal = v;
    return r;
  }

  static OpcVariant byte_(ubyte v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.byte_;
    r._intVal = v;
    return r;
  }

  static OpcVariant int16(short v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.int16;
    r._intVal = v;
    return r;
  }

  static OpcVariant uint16(ushort v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.uint16;
    r._intVal = v;
    return r;
  }

  static OpcVariant int32(int v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.int32;
    r._intVal = v;
    return r;
  }

  static OpcVariant uint32(uint v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.uint32;
    r._intVal = cast(long) v;
    return r;
  }

  static OpcVariant int64(long v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.int64;
    r._intVal = v;
    return r;
  }

  static OpcVariant uint64(ulong v) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.uint64;
    r._intVal = cast(long) v;
    return r;
  }

  static OpcVariant float_(float v) nothrow {
    OpcVariant r;
    r.type      = OpcDataType.float_;
    r._floatVal = v;
    return r;
  }

  static OpcVariant double_(double v) nothrow {
    OpcVariant r;
    r.type      = OpcDataType.double_;
    r._floatVal = v;
    return r;
  }

  static OpcVariant string_(string v) nothrow {
    OpcVariant r;
    r.type     = OpcDataType.string_;
    r._textVal = v;
    return r;
  }

  static OpcVariant dateTime(long unixMs) nothrow {
    OpcVariant r;
    r.type    = OpcDataType.dateTime;
    r._intVal = unixMs;
    return r;
  }

  static OpcVariant byteString(ubyte[] v) nothrow {
    OpcVariant r;
    r.type      = OpcDataType.byteString;
    r._bytesVal = v;
    return r;
  }

  static OpcVariant null_() nothrow {
    OpcVariant r;
    r.type = OpcDataType.null_;
    return r;
  }

  // --- accessors ---

  bool    asBoolean() const nothrow { return _intVal != 0; }
  long    asInt()     const nothrow { return _intVal;      }
  double  asFloat()   const nothrow { return _floatVal;    }
  string  asString()  const nothrow { return _textVal;     }
  ubyte[] asBytes()   const nothrow @trusted { return cast(ubyte[]) _bytesVal; }
  bool    isNull()    const nothrow { return type == OpcDataType.null_; }

  unittest {
    auto b = OpcVariant.boolean_(true);
    assert(b.type == OpcDataType.boolean_);
    assert(b.asBoolean == true);

    auto i = OpcVariant.int32(42);
    assert(i.asInt == 42);

    auto f = OpcVariant.double_(3.14);
    assert(f.asFloat > 3.0);

    auto s = OpcVariant.string_("hello");
    assert(s.asString == "hello");

    auto n = OpcVariant.null_();
    assert(n.isNull);
  }
}
