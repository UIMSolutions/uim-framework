/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opcua.service;

import std.datetime : Clock, UTC;

import vibe.d : runTask;

import uim.opcua;

mixin(ShowModule!());

@safe:

class UIMOPCUAService : UIMObject, IOPCUAService {
  private OPCUAConfig _config;
  private bool _configured;

  private OPCUAReadDelegate _readProvider;
  private OPCUAWriteDelegate _writeProvider;
  private OPCUAInvokeDelegate _invokeProvider;

  bool configure(OPCUAConfig config) {
    if (config.endpointUrl.length == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  OPCUAConfig config() const {
    return _config;
  }

  bool setReadProvider(OPCUAReadDelegate provider) {
    _readProvider = provider;
    return true;
  }

  bool setWriteProvider(OPCUAWriteDelegate provider) {
    _writeProvider = provider;
    return true;
  }

  bool setInvokeProvider(OPCUAInvokeDelegate provider) {
    _invokeProvider = provider;
    return true;
  }

  OPCUANodeRead readNode(string nodeId, string attributeId = "Value") {
    if (!_configured || nodeId.length == 0) {
      return OPCUANodeReadEmpty();
    }

    if (_readProvider !is null) {
      try {
        return _readProvider(_config, nodeId, attributeId);
      } catch (Exception) {
        return OPCUANodeReadEmpty();
      }
    }

    OPCUANodeRead result;
    result.nodeId = nodeId;
    result.attributeId = attributeId;
    result.value = "uim-opcua in-memory value";
    result.dataType = "String";
    result.sourceTimestamp = Clock.currTime(UTC()).toUnixTime();
    return result;
  }

  OPCUAResult writeNode(string nodeId, string value, string dataType = "String") {
    if (!_configured) {
      return OPCUAResultErr(412, "OPC UA service is not configured.");
    }

    if (nodeId.length == 0) {
      return OPCUAResultErr(400, "nodeId is required");
    }

    if (_writeProvider !is null) {
      try {
        return _writeProvider(_config, nodeId, value, dataType);
      } catch (Exception ex) {
        return OPCUAResultErr(500, ex.msg);
      }
    }

    auto serviceResponse = opcuaBuildWriteRequest(nodeId, value, dataType) ~ "|Status=Good";
    return OPCUAResultOk(200, "OPC UA write accepted by in-memory provider", serviceResponse);
  }

  OPCUAResult invokeMethod(string methodNodeId, string objectNodeId, string[] inputArgs = null) {
    if (!_configured) {
      return OPCUAResultErr(412, "OPC UA service is not configured.");
    }

    if (methodNodeId.length == 0 || objectNodeId.length == 0) {
      return OPCUAResultErr(400, "methodNodeId and objectNodeId are required");
    }

    if (_invokeProvider !is null) {
      try {
        return _invokeProvider(_config, methodNodeId, objectNodeId, inputArgs);
      } catch (Exception ex) {
        return OPCUAResultErr(500, ex.msg);
      }
    }

    auto serviceResponse = "CALL|Method=" ~ methodNodeId ~ "|Object=" ~ objectNodeId ~ "|Status=Good";
    return OPCUAResultOk(200, "OPC UA method invocation accepted", serviceResponse);
  }

  bool readNodeAsync(string nodeId, string attributeId, OPCUANodeReadHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localNodeId = nodeId;
    auto localAttributeId = attributeId;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(readNode(localNodeId, localAttributeId));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool writeNodeAsync(string nodeId, string value, string dataType, OPCUAResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localNodeId = nodeId;
    auto localValue = value;
    auto localDataType = dataType;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(writeNode(localNodeId, localValue, localDataType));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}

IOPCUAService OPCUAService() {
  return new UIMOPCUAService();
}

unittest {
  auto service = OPCUAService();

  OPCUAConfig config;
  config.endpointUrl = "opc.tcp://192.168.1.50:4840";
  config.sessionName = "uim-opcua-session";
  assert(service.configure(config));

  auto readResult = service.readNode("ns=2;s=Machine/Speed");
  assert(readResult.nodeId.length > 0);

  auto writeResult = service.writeNode("ns=2;s=Machine/Setpoint", "1800", "Int32");
  assert(writeResult.success);

  auto callResult = service.invokeMethod("ns=2;s=Machine/Start", "ns=2;s=Machine", ["auto"]);
  assert(callResult.success);
}
