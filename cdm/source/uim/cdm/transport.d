/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdm.transport;

import std.string : startsWith;

import vibe.d : runTask;
import vibe.http.client : HTTPClientRequest, HTTPClientResponse, requestHTTP;
import vibe.http.common : HTTPMethod;
import vibe.stream.operations : readAllUTF8;

import uim.cdm;

mixin(ShowModule!());

@safe:

class UIMCdmTransport : UIMObject, ICdmTransport {
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

  private ICdmDocument cloneDocument(ICdmDocument document) {
    auto copy = CdmDocument(document.id(), document.name(), document.namespaceUri(), document.version_());
    copy.created(document.created());
    copy.metadata(document.metadata());

    foreach (entity; document.entities()) {
      auto entityCopy = CdmEntity(entity.name(), entity.description());
      entityCopy.metadata(entity.metadata());
      foreach (field; entity.fields()) {
        entityCopy.addField(CdmField(field.name(), field.dataType(), field.value()));
      }
      copy.addEntity(entityCopy);
    }

    return copy;
  }

  void sendAsync(ICdmDocument document, CdmResponseHandler handler = null) {
    if (!_connected || document is null || handler is null) {
      return;
    }

    auto requestDocument = cloneDocument(document);
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          auto payload = cdmEncodeJson(requestDocument);
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
                  auto response = cdmDecodeJson(body);
                  (() @trusted {
                    runTask(() nothrow {
                      try {
                        localHandler(response);
                      } catch (Exception) {
                      }
                    });
                  })();
                } catch (Exception) {
                  (() @trusted {
                    runTask(() nothrow {
                      try {
                        localHandler(requestDocument);
                      } catch (Exception) {
                      }
                    });
                  })();
                }
              } else {
                (() @trusted {
                  runTask(() nothrow {
                    try {
                      localHandler(requestDocument);
                    } catch (Exception) {
                    }
                  });
                })();
              }
            }
          );
        } catch (Exception) {
          (() @trusted {
            runTask(() nothrow {
              try {
                localHandler(requestDocument);
              } catch (Exception) {
              }
            });
          })();
        }
      });
    })();
  }
}

ICdmTransport CdmTransport() {
  return new UIMCdmTransport();
}

unittest {
  auto transport = CdmTransport();
  assert(transport.connect("http://localhost:8080/cdm"));
  assert(transport.connected());

  auto document = CdmDocument("CDM-1", "Mission Data Model", "urn:uim:cdm:mission");
  transport.sendAsync(document, null);

  assert(transport.disconnect());
  assert(!transport.connected());
}
