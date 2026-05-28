/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oas.interfaces.document;

@safe:

enum OASVersion : ubyte {
  v20 = 0,
  v30 = 1,
  v31 = 2,
  unknown = 3
}

struct OASEndpoint {
  string path;
  string method;
  string summary;
}

interface IOASDocument {
  string raw();
  IOASDocument raw(string value);

  OASVersion version_();
  IOASDocument version_(OASVersion value);

  string title();
  IOASDocument title(string value);

  string documentVersion();
  IOASDocument documentVersion(string value);

  OASEndpoint[] endpoints();
  IOASDocument endpoints(const(OASEndpoint)[] value);
  IOASDocument addEndpoint(OASEndpoint endpoint);

  bool isValid();
}

alias OASDocumentHandler = void delegate(IOASDocument document) @safe;

interface IOASService {
  IOASDocument parse(string source);
  bool validate(IOASDocument document);
  OASEndpoint[] findByMethod(IOASDocument document, string method);
  bool parseAsync(string source, OASDocumentHandler handler);
}
