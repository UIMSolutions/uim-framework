/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.interfaces.node;

@safe:

// OPC UA NodeId identifier type discriminator
enum NodeIdType : ubyte {
  numeric = 0,
  string_ = 3,
  guid    = 4,
  opaque  = 5,
}

// OPC UA NodeId — uniquely identifies a node in the address space
struct OpcNodeId {
  ushort    namespaceIndex = 0;
  NodeIdType idType        = NodeIdType.numeric;

  private ulong  _numericId = 0;
  private string _stringId;

  static OpcNodeId numeric(ushort ns, ulong id) nothrow {
    OpcNodeId n;
    n.namespaceIndex = ns;
    n.idType         = NodeIdType.numeric;
    n._numericId     = id;
    return n;
  }

  static OpcNodeId string_(ushort ns, string id) nothrow {
    OpcNodeId n;
    n.namespaceIndex = ns;
    n.idType         = NodeIdType.string_;
    n._stringId      = id;
    return n;
  }

  ulong  numericId() const nothrow { return _numericId; }
  string stringId()  const nothrow { return _stringId;  }

  bool isNull() const nothrow {
    if (idType == NodeIdType.numeric) return _numericId == 0 && namespaceIndex == 0;
    if (idType == NodeIdType.string_) return _stringId.length == 0;
    return true;
  }

  string toText() const {
    import std.conv : to;
    if (idType == NodeIdType.numeric) {
      return "ns=" ~ namespaceIndex.to!string ~ ";i=" ~ _numericId.to!string;
    }
    if (idType == NodeIdType.string_) {
      return "ns=" ~ namespaceIndex.to!string ~ ";s=" ~ _stringId;
    }
    return "ns=" ~ namespaceIndex.to!string ~ ";opaque";
  }

  bool opEquals(const OpcNodeId other) const nothrow {
    if (namespaceIndex != other.namespaceIndex) return false;
    if (idType != other.idType) return false;
    if (idType == NodeIdType.numeric) return _numericId == other._numericId;
    if (idType == NodeIdType.string_) return _stringId  == other._stringId;
    return false;
  }

  size_t toHash() const nothrow {
    size_t h = namespaceIndex;
    if (idType == NodeIdType.numeric) {
      h ^= _numericId;
    } else {
      foreach (c; _stringId) h = h * 31 + c;
    }
    return h;
  }

  unittest {
    auto a = OpcNodeId.numeric(0, 84);
    auto b = OpcNodeId.numeric(0, 84);
    auto c = OpcNodeId.numeric(1, 84);
    assert(a == b);
    assert(a != c);
    assert(a.toText == "ns=0;i=84");

    auto s = OpcNodeId.string_(1, "MyNode");
    assert(s.idType == NodeIdType.string_);
    assert(s.toText == "ns=1;s=MyNode");
  }
}

// OPC UA well-known root NodeIds (numeric, ns=0)
enum OpcRootNodeId : ulong {
  rootFolder    = 84,
  objectsFolder = 85,
  typesFolder   = 86,
  viewsFolder   = 87,
}

// OPC UA node class bitmask
enum NodeClass : uint {
  unspecified   = 0,
  object_       = 1,
  variable_     = 2,
  method_       = 4,
  objectType    = 8,
  variableType  = 16,
  referenceType = 32,
  dataType      = 64,
  view          = 128,
}

// OPC UA attribute identifiers (Part 4, Table 1)
enum OpcAttribute : uint {
  nodeId                  = 1,
  nodeClass               = 2,
  browseName              = 3,
  displayName             = 4,
  description             = 5,
  writeMask               = 6,
  userWriteMask           = 7,
  isAbstract              = 8,
  symmetric               = 9,
  inverseName             = 10,
  containsNoLoops         = 11,
  eventNotifier           = 12,
  value                   = 13,
  dataType                = 14,
  valueRank               = 15,
  arrayDimensions         = 16,
  accessLevel             = 17,
  userAccessLevel         = 18,
  minimumSamplingInterval = 19,
  historizing             = 20,
  executable              = 21,
  userExecutable          = 22,
}

// OPC UA qualified name (namespace-indexed browse name)
struct QualifiedName {
  ushort namespaceIndex;
  string name;

  bool opEquals(const QualifiedName other) const nothrow {
    return namespaceIndex == other.namespaceIndex && name == other.name;
  }
}

// OPC UA localized text
struct LocalizedText {
  string locale;
  string text;
}

// Minimal node contract
interface INode {
  OpcNodeId      nodeId()      @safe;
  NodeClass      nodeClass()   @safe;
  QualifiedName  browseName()  @safe;
  LocalizedText  displayName() @safe;
  LocalizedText  description() @safe;
}
