/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.address.space;

import uim.opc.interfaces.node;
import uim.opc.types.variant;
import uim.opc.types.status;

@safe:

// Direction for Browse
enum BrowseDirection : uint {
  forward  = 0,
  inverse  = 1,
  both     = 2,
}

// Describes a Browse request for a single node
struct BrowseDescription {
  OpcNodeId       nodeId;
  BrowseDirection browseDirection    = BrowseDirection.forward;
  NodeClass       nodeClassMask      = NodeClass.unspecified;  // 0 = all
  bool            includeSubtypes    = true;
}

// A single reference returned from Browse
struct ReferenceDescription {
  OpcNodeId       nodeId;
  OpcNodeId       referenceTypeId;
  NodeClass       nodeClass;
  QualifiedName   browseName;
  LocalizedText   displayName;
  bool            isForward;
}

// Result of a Browse call
struct BrowseResult {
  OpcStatus             status;
  ReferenceDescription[] references;
}

// Item to read — identifies one attribute on one node
struct ReadValueId {
  OpcNodeId    nodeId;
  OpcAttribute attributeId = OpcAttribute.value;
}

// Read result — value + quality + timestamps
struct DataValue {
  OpcVariant value;
  OpcStatus  status;
  long       sourceTimestampMs = 0;
  long       serverTimestampMs = 0;

  bool good()     const nothrow { return status.good();      }
  bool bad()      const nothrow { return status.bad();       }
  bool uncertain() const nothrow { return status.uncertain(); }
}

// Write request — node attribute + new value
struct WriteValue {
  OpcNodeId    nodeId;
  OpcAttribute attributeId = OpcAttribute.value;
  OpcVariant   value;
}

// Method call argument
struct Argument {
  string     name;
  OpcVariant value;
}

// Method call result
struct CallResult {
  OpcStatus   status;
  OpcVariant[] outputArguments;
}

// Address space contract — browse, read, write, call
interface IAddressSpace {
  BrowseResult browse(BrowseDescription desc)   @safe;
  DataValue    read(ReadValueId item)            @safe;
  OpcStatus    write(WriteValue item)            @safe;
  CallResult   call(OpcNodeId objectId,
                    OpcNodeId methodId,
                    Argument[] inputArgs)        @safe;
  bool         addNode(INode node)               @safe;
  bool         removeNode(OpcNodeId nodeId)      @safe;
  INode        findNode(OpcNodeId nodeId)        @safe;
}
