#!/usr/bin/env dub
/+ dub.sdl:
name "engineering_web_api"
description "uim-engineering REST API server"
dependency "uim-framework:engineering" version="*"
dependency "vibe-d" version="~>0.10.3"
+/
module engineering.examples.web_api;

import std.stdio;
import vibe.d;
import uim.engineering.web;

shared static this() {
    writeln("Starting Engineering API Server on http://localhost:8080/api/engineering/");

    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];

    auto router = new URLRouter();
    router.registerRestInterface(new EngineeringAPI());



}    listenHTTP(settings, router);