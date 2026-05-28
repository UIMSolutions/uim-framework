/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.grpc.message;

import uim.grpc;

mixin(ShowModule!());

@safe:

GrpcUnaryRequest GrpcRequest(
  string methodPath,
  const(ubyte)[] payload = null,
  GrpcMetadata metadata = null,
  uint timeoutMs = 5000
) {
  GrpcUnaryRequest request;
  request.methodPath = grpcNormalizeMethodPath(methodPath);
  request.payload = payload.dup;
  request.metadata = metadata.dup;
  request.timeoutMs = timeoutMs;
  return request;
}

GrpcUnaryResponse GrpcResponse(
  GrpcStatusCode status,
  string statusMessage = "",
  const(ubyte)[] payload = null,
  GrpcMetadata metadata = null
) {
  GrpcUnaryResponse response;
  response.status = status;
  response.statusMessage = statusMessage.length ? statusMessage : grpcStatusText(status);
  response.payload = payload.dup;
  response.metadata = metadata.dup;
  return response;
}

GrpcUnaryResponse GrpcOk(const(ubyte)[] payload = null, GrpcMetadata metadata = null) {
  return GrpcResponse(GrpcStatusCode.ok, grpcStatusText(GrpcStatusCode.ok), payload, metadata);
}

GrpcUnaryResponse GrpcError(GrpcStatusCode status, string statusMessage = "") {
  auto message = statusMessage.length ? statusMessage : grpcStatusText(status);
  return GrpcResponse(status, message, null, null);
}

unittest {
  auto request = GrpcRequest("demo.Greeter/SayHello", [cast(ubyte) 1, 2], null, 1200);
  assert(request.methodPath == "/demo.Greeter/SayHello");
  assert(request.timeoutMs == 1200);
  assert(request.payload.length == 2);

  auto response = GrpcOk([cast(ubyte) 9]);
  assert(response.ok());
  assert(response.payload.length == 1);

  auto err = GrpcError(GrpcStatusCode.unimplemented);
  assert(!err.ok());
}
