/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.usecases.update;

import vibe.data.json : Json;

import uim.odata.interfaces.repository;
import uim.odata.types.request;

@safe:

/// Use case: update an entity — full (PUT) or partial (PATCH).
class UpdateEntityUseCase {
    private IEntityRepository _repository;

    this(IEntityRepository repository) {
        _repository = repository;
    }

    /// Full replacement update (PUT /EntitySet(key)).
    ODataResponse execute(string entitySetName, string key, Json body_) @trusted {
        if (!_repository.entitySetExists(entitySetName))
            return ODataResponse.notFound("Entity set '" ~ entitySetName ~ "' not found");

        if (body_.type != Json.Type.object)
            return ODataResponse.badRequest("Request body must be a JSON object");

        auto existing = _repository.findByKey(entitySetName, key);
        if (existing.type == Json.Type.null_ || existing.type == Json.Type.undefined)
            return ODataResponse.notFound(
                "Entity with key '" ~ key ~ "' not found in " ~ entitySetName);

        auto updated = _repository.update(entitySetName, key, body_);

        auto result = Json.emptyObject;
        result["@odata.context"] = Json("$metadata#" ~ entitySetName ~ "/$entity");
        if (updated.type == Json.Type.object) {
            foreach (string k, v; updated.byKeyValue)
                result[k] = v;
        }

        return ODataResponse.ok(result);
    }

    /// Partial update (PATCH /EntitySet(key)).
    ODataResponse executePatch(string entitySetName, string key, Json body_) @trusted {
        if (!_repository.entitySetExists(entitySetName))
            return ODataResponse.notFound("Entity set '" ~ entitySetName ~ "' not found");

        if (body_.type != Json.Type.object)
            return ODataResponse.badRequest("Request body must be a JSON object");

        auto existing = _repository.findByKey(entitySetName, key);
        if (existing.type == Json.Type.null_ || existing.type == Json.Type.undefined)
            return ODataResponse.notFound(
                "Entity with key '" ~ key ~ "' not found in " ~ entitySetName);

        auto patched = _repository.patch(entitySetName, key, body_);

        auto result = Json.emptyObject;
        result["@odata.context"] = Json("$metadata#" ~ entitySetName ~ "/$entity");
        if (patched.type == Json.Type.object) {
            foreach (string k, v; patched.byKeyValue)
                result[k] = v;
        }

        return ODataResponse.ok(result);
    }
}
