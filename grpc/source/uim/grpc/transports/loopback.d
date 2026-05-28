/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.grpc.transports.loopback;

import uim.grpc;

mixin(ShowModule!());

@safe:

class UIMGrpcLoopbackTransport : UIMObject {
  private UIMGrpcUnaryChannel _channel;

  this(UIMGrpcUnaryChannel channel = null) {
    super();
    _channel = channel is null ? GrpcUnaryChannel() : channel;
  }

  UIMGrpcUnaryChannel channel() {
    return _channel;
  }

  GrpcUnaryResponse unary(GrpcUnaryRequest request) {
    return _channel.invoke(request);
  }

  void unaryAsync(GrpcUnaryRequest request, GrpcUnaryCallback callback) {
    _channel.invokeAsync(request, callback);
  }
}

unittest {
  auto transport = new UIMGrpcLoopbackTransport();

  assert(transport.channel().registerUnary("/demo.Echo/Ping", (GrpcUnaryRequest request) {
    return GrpcOk(request.payload);
  }));

  auto response = transport.unary(GrpcRequest("/demo.Echo/Ping", [cast(ubyte) 1]));
  assert(response.ok());
}
