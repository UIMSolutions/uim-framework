/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.interfaces.config;

import uim.service;

mixin(ShowModule!());

@safe:
interface IUIMConfig {
  string serviceName();
  void serviceName(string name);

  string serviceVersion();
  void serviceVersion(string vers);

  string host();
  void host(string host);

  ushort port();
  void port(ushort port);

  string basePath();
  void basePath(string basePath);

  bool requireAuthToken();
  void requireAuthToken(bool required);

  string authToken();
  void authToken(string token);

  string[string] customHeaders();
  void customHeaders(string[string] headers);

  string customHeader(string key);
  void customHeader(string key, string value);

  void validate();
}
