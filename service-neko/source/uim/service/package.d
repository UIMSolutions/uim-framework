/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Umbrella module of the service library.
///
/// The protocol adapters are opt-in and must be imported explicitly, so their
/// names never clash with service specific adapters:
///   import uim.service.presentation.odata;  // OData v4 (Fiori)
///   import uim.service.presentation.cli;    // command line
///   import uim.service.presentation.gui;    // GtkD desktop GUI
module uim.service;

public {
  import uim.oop;
  // import uim.services;

  import uim.service.application;
  import uim.service.classes;
  import uim.service.domain;
  import uim.service.exceptions;
  import uim.service.helpers;
  import uim.service.interfaces;
  import uim.service.mixins;
  import uim.service.ports;
  import uim.service.persistence;
  import uim.service.presentation;
  import uim.service.tests;
  import uim.service.udas;
}
