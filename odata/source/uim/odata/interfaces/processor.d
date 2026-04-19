/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.interfaces.processor;

import uim.odata.types.request;

/// Inbound port — the application-level OData request processor.
/// The HTTP adapter (router) converts raw HTTP into an ODataRequest,
/// passes it here, and translates the ODataResponse back to HTTP.
interface IODataProcessor {
    ODataResponse process(ODataRequest request);
}
