/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.server;

import uim.opc;

mixin(ShowModule!());

@safe:

// Read handler: given a NodeId returns a DataValue (or a bad status)
alias ReadHandler  = DataValue delegate(OpcNodeId nodeId) @safe;
// Write handler: given a NodeId and new value returns OpcStatus
alias WriteHandler = OpcStatus delegate(OpcNodeId nodeId, OpcVariant value) @safe;
// Method handler: given objectId, methodId, input args returns CallResult
alias MethodHandler = CallResult delegate(OpcNodeId objectId,
                                          OpcNodeId methodId,
                                          Argument[] inputArgs) @safe;

// In-process OPC UA loopback server — implements IAddressSpace
// Useful for unit testing, simulation, and service-first development.
class UIMOpcLoopbackServer : UIMObject, IAddressSpace {
  private INode[string]      _nodes;
  private ReadHandler[string]  _readHandlers;
  private WriteHandler[string] _writeHandlers;
  private MethodHandler[string] _methodHandlers;

  // Subscriptions created on this server
  private UIMOpcSubscription[] _subscriptions;

  // Register a node in the address space
  bool addNode(INode node) {
    if (node is null) return false;
    _nodes[node.nodeId.toText] = node;
    return true;
  }

  // Remove a node by NodeId (also clears its read/write handlers)
  bool removeNode(OpcNodeId nodeId) {
    _readHandlers.remove(nodeId.toText);
    _writeHandlers.remove(nodeId.toText);
    return _nodes.remove(nodeId.toText);
  }

  // Find a node by NodeId
  INode findNode(OpcNodeId nodeId) {
    auto p = nodeId.toText in _nodes;
    return p !is null ? *p : null;
  }

  // Register a read handler for a specific node
  void registerRead(OpcNodeId nodeId, ReadHandler handler) {
    _readHandlers[nodeId.toText] = handler;
  }

  // Register a write handler for a specific node
  void registerWrite(OpcNodeId nodeId, WriteHandler handler) {
    _writeHandlers[nodeId.toText] = handler;
  }

  // Register a method handler for a method node
  void registerMethod(OpcNodeId methodId, MethodHandler handler) {
    _methodHandlers[methodId.toText] = handler;
  }

  // IAddressSpace — Browse
  BrowseResult browse(BrowseDescription desc) {
    BrowseResult result;
    result.status = opcGoodStatus();

    foreach (key, node; _nodes) {
      if (desc.nodeClassMask != NodeClass.unspecified &&
          (node.nodeClass & desc.nodeClassMask) == 0) {
        continue;
      }
      ReferenceDescription ref_;
      ref_.nodeId      = node.nodeId;
      ref_.nodeClass   = node.nodeClass;
      ref_.browseName  = node.browseName;
      ref_.displayName = node.displayName;
      ref_.isForward   = true;
      result.references ~= ref_;
    }
    return result;
  }

  // IAddressSpace — Read
  DataValue read(ReadValueId item) {
    auto handlerPtr = item.nodeId.toText in _readHandlers;
    if (handlerPtr !is null) {
      return (*handlerPtr)(item.nodeId);
    }
    // No handler: check if node exists and return null variant
    auto nodePtr = item.nodeId.toText in _nodes;
    if (nodePtr is null) {
      return DataValue(OpcVariant.null_(),
                       opcBadStatus(OpcStatusCode.badNodeIdUnknown, "Node not found"),
                       0, 0);
    }
    return DataValue(OpcVariant.null_(), opcGoodStatus(), 0, 0);
  }

  // IAddressSpace — Write
  OpcStatus write(WriteValue item) {
    auto handlerPtr = item.nodeId.toText in _writeHandlers;
    if (handlerPtr !is null) {
      return (*handlerPtr)(item.nodeId, item.value);
    }
    auto nodePtr = item.nodeId.toText in _nodes;
    if (nodePtr is null) {
      return opcBadStatus(OpcStatusCode.badNodeIdUnknown, "Node not found");
    }
    return opcBadStatus(OpcStatusCode.badNotWritable, "No write handler registered");
  }

  // IAddressSpace — Call
  CallResult call(OpcNodeId objectId, OpcNodeId methodId, Argument[] inputArgs) {
    auto handlerPtr = methodId.toText in _methodHandlers;
    if (handlerPtr !is null) {
      return (*handlerPtr)(objectId, methodId, inputArgs);
    }
    return CallResult(
      opcBadStatus(OpcStatusCode.badMethodInvalid, "Method not registered"),
      []
    );
  }

  // Create and register a subscription on this server
  UIMOpcSubscription createSubscription(double publishingIntervalMs = 1000.0) {
    auto sub = new UIMOpcSubscription(publishingIntervalMs);
    _subscriptions ~= sub;
    return sub;
  }

  // Publish a data change to all subscriptions (simulates the server push)
  void publishDataChange(OpcNodeId nodeId, OpcDataValue value) {
    foreach (sub; _subscriptions) {
      sub.notifyDataChange(nodeId, value);
    }
  }

  unittest {
    auto server = new UIMOpcLoopbackServer();

    // Add a variable node
    auto tempId = OpcNodeId.numeric(1, 1001);
    auto node = new UIMOpcNode(
      tempId,
      NodeClass.variable_,
      QualifiedName(1, "Temperature"),
      LocalizedText("en", "Temperature")
    );
    assert(server.addNode(node));

    // Register read handler
    server.registerRead(tempId, (OpcNodeId nid) {
      return DataValue(OpcVariant.double_(22.5), opcGoodStatus(), 0, 0);
    });

    // Register write handler
    double stored = 0.0;
    server.registerWrite(tempId, (OpcNodeId nid, OpcVariant v) {
      stored = v.asFloat;
      return opcGoodStatus();
    });

    // Read
    auto dv = server.read(ReadValueId(tempId, OpcAttribute.value));
    assert(dv.good);
    assert(dv.value.asFloat > 22.0);

    // Write
    auto ws = server.write(WriteValue(tempId, OpcAttribute.value, OpcVariant.double_(25.0)));
    assert(ws.good);
    assert(stored > 24.0);

    // Browse
    auto br = server.browse(BrowseDescription(tempId));
    assert(br.status.good);
    assert(br.references.length == 1);

    // Remove node
    assert(server.removeNode(tempId));
    auto dv2 = server.read(ReadValueId(tempId, OpcAttribute.value));
    assert(dv2.bad);

    // Subscription + data change notification
    auto server2 = new UIMOpcLoopbackServer();
    auto nodeId2 = OpcNodeId.numeric(1, 2001);
    auto sub = server2.createSubscription(500.0);
    auto params = MonitoringParameters(100.0, 5, true);
    auto item = sub.monitor(nodeId2, OpcAttribute.value, params);

    bool notified;
    item.setCallback((OpcNodeId nid, OpcDataValue val) {
      notified = true;
    });

    auto changed = OpcDataValue(OpcVariant.int32(77), opcGoodStatus(), 0, 0);
    server2.publishDataChange(nodeId2, changed);
    assert(notified);
  }
}

auto OpcLoopbackServer() {
  return new UIMOpcLoopbackServer();
}
