/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.interfaces.session;

import uim.opc.types.status;
import uim.opc.interfaces.node;

@safe:

// OPC UA security mode
enum SecurityMode : uint {
  invalid        = 0,
  none_          = 1,
  sign           = 2,
  signAndEncrypt = 3,
}

// OPC UA endpoint descriptor
struct OpcEndpoint {
  string       endpointUrl;
  SecurityMode securityMode        = SecurityMode.none_;
  string       securityPolicyUri   = "http://opcfoundation.org/UA/SecurityPolicy#None";
  string       transportProfileUri = "http://opcfoundation.org/UA-Profile/Transport/uatcp-uasc-uabinary";

  unittest {
    auto ep = OpcEndpoint("opc.tcp://localhost:4840/");
    assert(ep.endpointUrl == "opc.tcp://localhost:4840/");
    assert(ep.securityMode == SecurityMode.none_);
  }
}

// OPC UA user identity token
struct OpcUserIdentity {
  string username;
  string password;
  bool   anonymous;

  static OpcUserIdentity anonymous_() nothrow {
    return OpcUserIdentity("", "", true);
  }

  static OpcUserIdentity userPassword(string user, string pass) nothrow {
    return OpcUserIdentity(user, pass, false);
  }
}

// Session contract
interface IOpcSession {
  string     sessionId()  @safe;
  bool       isActive()   @safe;
  OpcStatus  activate(OpcUserIdentity identity)  @safe;
  OpcStatus  close()      @safe;
}

// Client connection contract
interface IOpcClient {
  OpcStatus       connect(OpcEndpoint endpoint)     @safe;
  OpcStatus       disconnect()                       @safe;
  bool            isConnected()                      @safe;
  string          endpointUrl()                      @safe;
  IOpcSession     createSession()                    @safe;
}
