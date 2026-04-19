/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.interfaces.modelprovider;

import uim.odata.types.model;

/// Outbound port — provides the Entity Data Model at runtime.
/// Implement this to load EDM metadata from configuration, code-first
/// definitions, or a remote $metadata endpoint.
interface IEdmModelProvider {
    EdmModel getModel();
}
