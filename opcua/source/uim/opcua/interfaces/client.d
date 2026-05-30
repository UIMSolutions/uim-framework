/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opcua.interfaces.client;

@safe:

enum OPCUASecurityMode : ubyte {
  none = 0,
  sign = 1,
  signAndEncrypt = 2
}

struct OPCUAConfig {
  string endpointUrl;
  string applicationUri;
  string sessionName;
  string username;
  string password;
  OPCUASecurityMode securityMode = OPCUASecurityMode.none;
  string securityPolicyUri = "http://opcfoundation.org/UA/SecurityPolicy#None";
  uint timeoutMs = 10_000;
  bool strictMode;
}

struct OPCUANodeRead {
  string nodeId;
  string attributeId;
  string value;
  string dataType;
  long sourceTimestamp;
}

struct OPCUAResult {
  bool success;
  ushort statusCode;
  string message;
  string serviceResponse;
}

alias OPCUANodeReadHandler = void delegate(OPCUANodeRead nodeRead) @safe;
alias OPCUAResultHandler = void delegate(OPCUAResult result) @safe;

alias OPCUAReadDelegate = OPCUANodeRead delegate(
  OPCUAConfig config,
  string nodeId,
  string attributeId
) @safe;

alias OPCUAWriteDelegate = OPCUAResult delegate(
  OPCUAConfig config,
  string nodeId,
  string value,
  string dataType
) @safe;

alias OPCUAInvokeDelegate = OPCUAResult delegate(
  OPCUAConfig config,
  string methodNodeId,
  string objectNodeId,
  string[] inputArgs
) @safe;

interface IOPCUAService {
  bool configure(OPCUAConfig config);
  OPCUAConfig config() const;

  bool setReadProvider(OPCUAReadDelegate provider);
  bool setWriteProvider(OPCUAWriteDelegate provider);
  bool setInvokeProvider(OPCUAInvokeDelegate provider);

  OPCUANodeRead readNode(string nodeId, string attributeId = "Value");
  OPCUAResult writeNode(string nodeId, string value, string dataType = "String");
  OPCUAResult invokeMethod(string methodNodeId, string objectNodeId, string[] inputArgs = null);

  bool readNodeAsync(string nodeId, string attributeId, OPCUANodeReadHandler handler);
  bool writeNodeAsync(string nodeId, string value, string dataType, OPCUAResultHandler handler);
}
