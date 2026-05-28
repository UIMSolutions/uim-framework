/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.grpc.interfaces.unary;

@safe:

enum GrpcStatusCode : int {
  ok = 0,
  canceled = 1,
  unknown = 2,
  invalidArgument = 3,
  deadlineExceeded = 4,
  notFound = 5,
  alreadyExists = 6,
  permissionDenied = 7,
  resourceExhausted = 8,
  failedPrecondition = 9,
  aborted = 10,
  outOfRange = 11,
  unimplemented = 12,
  internal = 13,
  unavailable = 14,
  dataLoss = 15,
  unauthenticated = 16
}

struct GrpcMetadataEntry {
  string name;
  string value;
}

alias GrpcMetadata = GrpcMetadataEntry[];

struct GrpcUnaryRequest {
  string methodPath;
  ubyte[] payload;
  GrpcMetadata metadata;
  uint timeoutMs = 5000;
}

struct GrpcUnaryResponse {
  GrpcStatusCode status = GrpcStatusCode.ok;
  string statusMessage;
  ubyte[] payload;
  GrpcMetadata metadata;

  bool ok() const {
    return status == GrpcStatusCode.ok;
  }
}

alias GrpcUnaryHandler = GrpcUnaryResponse delegate(GrpcUnaryRequest request) @safe;
alias GrpcUnaryCallback = void delegate(GrpcUnaryResponse response) @safe;

interface IGrpcUnaryChannel {
  bool registerUnary(string methodPath, GrpcUnaryHandler handler);
  bool unregisterUnary(string methodPath);
  bool hasUnary(string methodPath);

  GrpcUnaryResponse invoke(GrpcUnaryRequest request);
  void invokeAsync(GrpcUnaryRequest request, GrpcUnaryCallback callback);
}

GrpcMetadataEntry GrpcMetadataItem(string name, string value) pure nothrow @safe {
  return GrpcMetadataEntry(name, value);
}

string grpcStatusText(GrpcStatusCode code) pure nothrow @safe {
  final switch (code) {
    case GrpcStatusCode.ok: return "OK";
    case GrpcStatusCode.canceled: return "Canceled";
    case GrpcStatusCode.unknown: return "Unknown";
    case GrpcStatusCode.invalidArgument: return "Invalid argument";
    case GrpcStatusCode.deadlineExceeded: return "Deadline exceeded";
    case GrpcStatusCode.notFound: return "Not found";
    case GrpcStatusCode.alreadyExists: return "Already exists";
    case GrpcStatusCode.permissionDenied: return "Permission denied";
    case GrpcStatusCode.resourceExhausted: return "Resource exhausted";
    case GrpcStatusCode.failedPrecondition: return "Failed precondition";
    case GrpcStatusCode.aborted: return "Aborted";
    case GrpcStatusCode.outOfRange: return "Out of range";
    case GrpcStatusCode.unimplemented: return "Unimplemented";
    case GrpcStatusCode.internal: return "Internal";
    case GrpcStatusCode.unavailable: return "Unavailable";
    case GrpcStatusCode.dataLoss: return "Data loss";
    case GrpcStatusCode.unauthenticated: return "Unauthenticated";
  }
}
