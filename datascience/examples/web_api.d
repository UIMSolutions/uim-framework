#!/usr/bin/env dub
/+ dub.sdl:
name "datascience_web_example"
description "Web API example with vibe.d"
dependency "uim-framework:datascience" version="*"
dependency "vibe-d" version="~>0.10.3"
+/
module datascience.examples.web_api;

import std.stdio;
import vibe.d;
import uim.datascience.web;

shared static this() {
  writeln("Starting Data Science API Server on http://localhost:8080/api/datascience/");
  
  auto settings = new HTTPServerSettings;
  settings.port = 8080;
  settings.bindAddresses = ["::1", "127.0.0.1"];
  
  auto router = new URLRouter();
  router.registerRestInterface(new DataScienceAPI());




}  listenHTTP(settings, router);    router.registerRestInterface(new ModelServingAPI());