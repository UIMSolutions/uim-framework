/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.usecases.get;

import vibe.data.json : Json;

import uim.odata.interfaces.repository;
import uim.odata.types.request;

@safe:

/// Use case: retrieve a single entity by key (GET /EntitySet(key)).
class GetEntityUseCase {
    private IEntityRepository _repository;

    this(IEntityRepository repository) {
        _repository = repository;
    }

    ODataResponse execute(string entitySetName, string key) @trusted {
        if (!_repository.entitySetExists(entitySetName))
            return ODataResponse.notFound("Entity set '" ~ entitySetName ~ "' not found");

        auto entity = _repository.findByKey(entitySetName, key);
        if (entity.type == Json.Type.null_ || entity.type == Json.Type.undefined)
            return ODataResponse.notFound(
                "Entity with key '" ~ key ~ "' not found in " ~ entitySetName);

        auto result = Json.emptyObject;
        result["@odata.context"] = Json("$metadata#" ~ entitySetName ~ "/$entity");

        // merge entity properties into response
        if (entity.type == Json.Type.object) {
            foreach (string k, v; entity.byKeyValue)
                result[k] = v;
        }

        return ODataResponse.ok(result);
    }
}
