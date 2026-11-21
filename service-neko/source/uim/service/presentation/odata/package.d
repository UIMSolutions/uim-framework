/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Generic OData v4 adapter (opt-in: import uim.service.presentation.odata explicitly).
///
/// ---
/// auto engine = new ODataEngine(model).provide("Products", provider);
/// new ODataController(engine, "/odata/v4/demo").registerRoutes(router);
/// ---
module uim.service.presentation.odata;

public:
  import uim.service.presentation.odata.model;
  import uim.service.presentation.odata.query;
  import uim.service.presentation.odata.metadata;
  import uim.service.presentation.odata.resource;
  import uim.service.presentation.odata.batch;
  import uim.service.presentation.odata.engine;
  import uim.service.presentation.odata.values;
  import uim.service.presentation.odata.controller;

