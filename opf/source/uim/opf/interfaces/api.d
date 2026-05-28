/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opf.interfaces.api;

@safe:

enum OPFResourceType : ubyte {
  order = 0,
  transport = 1,
  warehouse = 2,
  shipment = 3,
  document = 4,
  inventory = 5,
  custom = 6
}

enum OPFHttpMethod : ubyte {
  get = 0,
  post = 1,
  put = 2,
  patch = 3,
  delete_ = 4
}

struct OPFApiResponse {
  ushort statusCode;
  string body;
  string[string] headers;
}

interface IOPFResource {
  string id();
  IOPFResource id(string value);

  OPFResourceType resourceType();
  IOPFResource resourceType(OPFResourceType value);

  string status();
  IOPFResource status(string value);

  string payload();
  IOPFResource payload(string value);

  string[string] metadata();
  IOPFResource metadata(string[string] value);
  IOPFResource setMetadata(string key, string value);

  bool isValid();
}

alias OPFResponseHandler = void delegate(OPFApiResponse response) @safe;

interface IOPFService {
  bool connect(string baseUrl);
  bool disconnect();
  bool connected() const;
  string baseUrl() const;

  bool upsertResource(IOPFResource resource);
  IOPFResource resourceById(string resourceId);
  IOPFResource[] resources();
  IOPFResource[] resourcesByType(OPFResourceType value);

  OPFApiResponse request(OPFHttpMethod method, string path, string body = "", string[string] headers = null);
  bool requestAsync(OPFHttpMethod method, string path, OPFResponseHandler handler, string body = "", string[string] headers = null);
}
