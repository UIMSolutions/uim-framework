/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.grpc.channel;

import vibe.d : runTask;

import uim.grpc;

mixin(ShowModule!());

@safe:

class UIMGrpcUnaryChannel : UIMObject, IGrpcUnaryChannel {
  private GrpcUnaryHandler[string] _handlers;

  bool registerUnary(string methodPath, GrpcUnaryHandler handler) {
    auto normalized = grpcNormalizeMethodPath(methodPath);
    if (normalized.length == 0 || handler is null) {
      return false;
    }

    _handlers[normalized] = handler;
    return true;
  }

  bool unregisterUnary(string methodPath) {
    auto normalized = grpcNormalizeMethodPath(methodPath);
    if (normalized.length == 0) {
      return false;
    }

    return _handlers.remove(normalized);
  }

  bool hasUnary(string methodPath) {
    auto normalized = grpcNormalizeMethodPath(methodPath);
    if (normalized.length == 0) {
      return false;
    }

    return (normalized in _handlers) !is null;
  }

  GrpcUnaryResponse invoke(GrpcUnaryRequest request) {
    auto normalized = grpcNormalizeMethodPath(request.methodPath);
    if (normalized.length == 0) {
      return GrpcError(GrpcStatusCode.invalidArgument, "Missing gRPC method path");
    }

    auto handler = normalized in _handlers;
    if (handler is null) {
      return GrpcError(GrpcStatusCode.unimplemented, "Method not registered: " ~ normalized);
    }

    GrpcUnaryRequest normalizedRequest = request;
    normalizedRequest.methodPath = normalized;

    try {
      return (*handler)(normalizedRequest);
    } catch (Exception ex) {
      return GrpcError(GrpcStatusCode.internal, ex.msg);
    }
  }

  void invokeAsync(GrpcUnaryRequest request, GrpcUnaryCallback callback) @trusted {
    if (callback is null) {
      return;
    }

    auto localRequest = request;
    auto localCallback = callback;

    runTask(() nothrow {
      GrpcUnaryResponse response;
      try {
        response = invoke(localRequest);
      } catch (Exception ex) {
        response = GrpcError(GrpcStatusCode.internal, ex.msg);
      }

      try {
        localCallback(response);
      } catch (Exception) {
      }
    });
  }
}

auto GrpcUnaryChannel() {
  return new UIMGrpcUnaryChannel();
}

unittest {
  auto channel = GrpcUnaryChannel();

  assert(channel.registerUnary("/demo.Greeter/SayHello", (GrpcUnaryRequest request) {
    return GrpcOk(request.payload);
  }));

  auto response = channel.invoke(GrpcRequest("demo.Greeter/SayHello", [cast(ubyte) 7, 8, 9]));
  assert(response.ok());
  assert(response.payload == [cast(ubyte) 7, 8, 9]);

  auto missing = channel.invoke(GrpcRequest("/demo.Greeter/Unknown", null));
  assert(missing.status == GrpcStatusCode.unimplemented);
}
