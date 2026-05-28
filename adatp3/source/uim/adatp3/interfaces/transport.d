/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.adatp3.interfaces.transport;

import uim.adatp3.interfaces.message;

@safe:

alias ADatP3ResponseHandler = void delegate(IADatP3Message response) @safe;

interface IADatP3Transport {
  bool connect(string endpointUrl);
  bool disconnect();

  bool connected() const;
  string endpoint() const;

  void sendAsync(IADatP3Message message, ADatP3ResponseHandler handler = null);
}
