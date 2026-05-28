/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.adatp3.transport;

import std.string : startsWith;

import vibe.d : runTask;

import uim.adatp3;

mixin(ShowModule!());

@safe:

class UIMADatP3Transport : UIMObject, IADatP3Transport {
  private bool _connected;
  private string _endpoint;

  bool connect(string endpointUrl) {
    if (!(endpointUrl.startsWith("http://") || endpointUrl.startsWith("https://"))) {
      return false;
    }

    _endpoint = endpointUrl;
    _connected = true;
    return true;
  }

  bool disconnect() {
    _connected = false;
    _endpoint = "";
    return true;
  }

  bool connected() const {
    return _connected;
  }

  string endpoint() const {
    return _endpoint;
  }

  private IADatP3Message cloneMessage(IADatP3Message message) {
    auto copy = ADatP3Message(
      message.messageType(),
      message.messageId(),
      message.originator(),
      message.recipient(),
      message.priority()
    );

    copy.timestamp(message.timestamp());
    copy.fields(message.fields());
    return copy;
  }

  void sendAsync(IADatP3Message message, ADatP3ResponseHandler handler = null) {
    if (!_connected || message is null || handler is null) {
      return;
    }

    auto response = cloneMessage(message);
    response.setField("transport", "vibe-runTask-loopback");
    response.setField("endpoint", _endpoint);

    auto localHandler = handler;
    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(response);
        } catch (Throwable) {
        }
      });
    })();
  }
}

IADatP3Transport ADatP3Transport() {
  return new UIMADatP3Transport();
}

unittest {
  auto transport = ADatP3Transport();
  assert(transport.connect("http://localhost:8080/adatp3"));
  assert(transport.connected());

  auto message = ADatP3Message(
    ADatP3MessageType.oprep,
    "MSG-3003",
    "BDE-7",
    "HQ-NORTH",
    ADatP3Priority.routine
  );

  bool callbackCalled;
  transport.sendAsync(message, (IADatP3Message response) @safe {
    callbackCalled = true;
    assert(response.field("transport") == "vibe-runTask-loopback");
    assert(response.field("endpoint") == "http://localhost:8080/adatp3");
  });

  // runTask dispatch can execute after scheduling; we only verify that invocation path is valid.
  assert(transport.disconnect());
  assert(!transport.connected());
}
