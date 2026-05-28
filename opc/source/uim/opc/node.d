/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.node;

import uim.opc;

mixin(ShowModule!());

@safe:

// Concrete in-process node — backing type for the loopback server
class UIMOpcNode : UIMObject, INode {
  private OpcNodeId     _nodeId;
  private NodeClass     _nodeClass;
  private QualifiedName _browseName;
  private LocalizedText _displayName;
  private LocalizedText _description;

  this(OpcNodeId nodeId,
       NodeClass nodeClass,
       QualifiedName browseName,
       LocalizedText displayName,
       LocalizedText description = LocalizedText("", "")) {
    _nodeId      = nodeId;
    _nodeClass   = nodeClass;
    _browseName  = browseName;
    _displayName = displayName;
    _description = description;
  }

  OpcNodeId     nodeId()      { return _nodeId;      }
  NodeClass     nodeClass()   { return _nodeClass;   }
  QualifiedName browseName()  { return _browseName;  }
  LocalizedText displayName() { return _displayName; }
  LocalizedText description() { return _description; }

  unittest {
    auto n = new UIMOpcNode(
      OpcNodeId.numeric(0, 1001),
      NodeClass.variable_,
      QualifiedName(1, "Temperature"),
      LocalizedText("en", "Temperature")
    );
    assert(n.nodeId == OpcNodeId.numeric(0, 1001));
    assert(n.nodeClass == NodeClass.variable_);
    assert(n.browseName.name == "Temperature");
  }
}

auto OpcNode(OpcNodeId nodeId,
             NodeClass nodeClass,
             QualifiedName browseName,
             LocalizedText displayName,
             LocalizedText description = LocalizedText("", "")) {
  return new UIMOpcNode(nodeId, nodeClass, browseName, displayName, description);
}
