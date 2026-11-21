/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Infrastructure layer: configuration, security, logging and test helpers.
module uim.service.infrastructure;

public:
  import uim.service.infrastructure.configs;
  import uim.service.infrastructure.configuration;
  import uim.service.infrastructure.logging;
  import uim.service.infrastructure.security;
  import uim.service.infrastructure.tests;
  // Deprecated locations (moved to uim.service.persistence)
  import uim.service.infrastructure.repositories;
  import uim.service.infrastructure.stores;
