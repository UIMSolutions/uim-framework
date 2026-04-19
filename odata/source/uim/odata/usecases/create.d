/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.usecases.create;

import vibe.data.json : Json;

import uim.odata.interfaces.repository;
import uim.odata.types.request;

@safe:

/// Use case: create a new entity (POST /EntitySet).
class CreateEntityUseCase {
    private IEntityRepository _repository;

    this(IEntityRepository repository) {
        _repository = repository;
    }

    ODataResponse execute(string entitySetName, Json body_) @trusted {
        if (!_repository.entitySetExists(entitySetName))
            return ODataResponse.notFound("Entity set '" ~ entitySetName ~ "' not found");

        if (body_.type != Json.Type.object)
            return ODataResponse.badRequest("Request body must be a JSON object");

        auto created = _repository.create(entitySetName, body_);

        auto result = Json.emptyObject;
        result["@odata.context"] = Json("$metadata#" ~ entitySetName ~ "/$entity");

        if (created.type == Json.Type.object) {
            foreach (string k, v; created.byKeyValue)
                result[k] = v;
        }

        return ODataResponse.created(result);
    }
}
