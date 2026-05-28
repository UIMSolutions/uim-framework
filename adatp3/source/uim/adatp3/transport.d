/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.adatp3.transport;

import std.conv : to;
import std.string : startsWith;

import vibe.d : runTask;
import vibe.http.client : HTTPClientRequest, HTTPClientResponse, requestHTTP;
import vibe.http.common : HTTPMethod;
import vibe.stream.operations : readAllUTF8;

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

  private IADatP3Message makeTransportResponse(IADatP3Message source, string transportState) {
    auto response = cloneMessage(source);
    response.setField("transport", "vibe-http");
    response.setField("endpoint", _endpoint);
    response.setField("transportState", transportState);
    return response;
  }

  void sendAsync(IADatP3Message message, ADatP3ResponseHandler handler = null) {
    if (!_connected || message is null || handler is null) {
      return;
    }

    auto requestMessage = cloneMessage(message);

    auto localHandler = handler;
    (() @trusted {
      runTask(() nothrow {
        IADatP3Message callbackMessage;

        try {
          auto payload = adatp3EncodeJson(requestMessage);

          (() @trusted {
            requestHTTP(
              _endpoint,
              (scope HTTPClientRequest req) {
                req.method = HTTPMethod.POST;
                req.headers["Accept"] = "application/json";
                req.writeBody(cast(const(ubyte)[]) payload, "application/json; charset=UTF-8");
              },
              (scope HTTPClientResponse res) {
                auto body = res.bodyReader.readAllUTF8();

                if (res.statusCode >= 200 && res.statusCode < 300 && body.length > 0) {
                  try {
                    callbackMessage = adatp3DecodeJson(body);
                    callbackMessage.setField("transport", "vibe-http");
                    callbackMessage.setField("endpoint", _endpoint);
                    callbackMessage.setField("transportState", "ok");
                    callbackMessage.setField("httpStatus", res.statusCode.to!string);
                    return;
                  } catch (Exception decodeEx) {
                    callbackMessage = makeTransportResponse(requestMessage, "decode_error");
                    callbackMessage.setField("httpStatus", res.statusCode.to!string);
                    callbackMessage.setField("transportError", decodeEx.msg);
                    return;
                  }
                }

                callbackMessage = makeTransportResponse(requestMessage, "http_error");
                callbackMessage.setField("httpStatus", res.statusCode.to!string);
                if (body.length > 0) {
                  callbackMessage.setField("httpBody", body);
                }
              }
            );
          })();

          if (callbackMessage is null) {
            callbackMessage = makeTransportResponse(requestMessage, "empty_response");
          }

          try {
            localHandler(callbackMessage);
          } catch (Exception) {
          }
        } catch (Exception ex) {
          try {
            localHandler(requestMessage);
          } catch (Exception) {
          }
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

  transport.sendAsync(message, null);

  assert(message.messageId() == "MSG-3003");
  assert(transport.disconnect());
  assert(!transport.connected());
}
