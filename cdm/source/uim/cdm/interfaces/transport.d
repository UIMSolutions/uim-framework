/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdm.interfaces.transport;

import uim.cdm.interfaces.document;

@safe:

alias CdmResponseHandler = void delegate(ICdmDocument response) @safe;

interface ICdmTransport {
  bool connect(string endpointUrl);
  bool disconnect();

  bool connected() const;
  string endpoint() const;

  void sendAsync(ICdmDocument document, CdmResponseHandler handler = null);
}
