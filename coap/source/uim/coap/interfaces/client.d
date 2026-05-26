/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.interfaces.client;

import uim.coap.interfaces.message;

mixin(ShowModule!());

@safe:

alias CoAPResponseHandler = void delegate(ICoAPMessage response) @safe;

interface ICoAPClient {
  bool connect(string endpointUrl);
  bool disconnect();

  bool request(
    CoAPCode method,
    string path,
    const(ubyte)[] payload,
    CoAPResponseHandler handler = null
  );

  bool connected() const;
  string endpoint() const;
}
