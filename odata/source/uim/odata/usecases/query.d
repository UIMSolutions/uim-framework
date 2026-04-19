/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.usecases.query;

import vibe.data.json : Json;

import uim.odata.interfaces.repository;
import uim.odata.types.queryoptions;
import uim.odata.types.request;

@safe:

/// Use case: query an entity set (GET /EntitySet).
///
/// Applies $filter, $orderby, $top, $skip, $select, and $count query options
/// via the repository port, then wraps the result in the OData JSON envelope.
class QueryEntitiesUseCase {
    private IEntityRepository _repository;

    this(IEntityRepository repository) {
        _repository = repository;
    }

    /// Execute the query and return an OData collection response.
    ODataResponse execute(string entitySetName, QueryOptions options) @trusted {
        if (!_repository.entitySetExists(entitySetName))
            return ODataResponse.notFound("Entity set '" ~ entitySetName ~ "' not found");

        auto entities = _repository.findWithOptions(entitySetName, options);

        auto result = Json.emptyObject;
        result["@odata.context"] = Json("$metadata#" ~ entitySetName);

        if (options.count)
            result["@odata.count"] = Json(cast(long) _repository.count(entitySetName));

        auto arr = Json.emptyArray;
        foreach (entity; entities)
            arr ~= entity;
        result["value"] = arr;

        return ODataResponse.ok(result);
    }

    /// Execute $count only (GET /EntitySet/$count).
    ODataResponse executeCount(string entitySetName) @trusted {
        if (!_repository.entitySetExists(entitySetName))
            return ODataResponse.notFound("Entity set '" ~ entitySetName ~ "' not found");

        auto c = _repository.count(entitySetName);
        return ODataResponse.ok(Json(cast(long) c));
    }
}
