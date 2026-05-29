/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.openapi.interfaces.document;

@safe:

enum OpenAPIVersion : ubyte {
  v20 = 0,
  v30 = 1,
  v31 = 2,
  unknown = 3
}

struct OpenAPIOperation {
  string path;
  string method;
  string operationId;
  string summary;
}

interface IOpenAPIDocument {
  string raw();
  IOpenAPIDocument raw(string value);

  OpenAPIVersion version_();
  IOpenAPIDocument version_(OpenAPIVersion value);

  string title();
  IOpenAPIDocument title(string value);

  string documentVersion();
  IOpenAPIDocument documentVersion(string value);

  string[] servers();
  IOpenAPIDocument servers(const(string)[] value);
  IOpenAPIDocument addServer(string value);

  OpenAPIOperation[] operations();
  IOpenAPIDocument operations(const(OpenAPIOperation)[] value);
  IOpenAPIDocument addOperation(OpenAPIOperation value);

  bool isValid();
}

alias OpenAPIDocumentHandler = void delegate(IOpenAPIDocument document) @safe;

interface IOpenAPIService {
  IOpenAPIDocument parse(string source);
  bool validate(IOpenAPIDocument document);
  OpenAPIOperation[] operationsByMethod(IOpenAPIDocument document, string method);
  OpenAPIOperation[] operationsByPath(IOpenAPIDocument document, string path);
  bool parseAsync(string source, OpenAPIDocumentHandler handler);
}
