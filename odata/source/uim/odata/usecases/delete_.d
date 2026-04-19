/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.usecases.delete_;

import vibe.data.json : Json;

import uim.odata.interfaces.repository;
import uim.odata.types.request;

@safe:

/// Use case: delete an entity (DELETE /EntitySet(key)).
class DeleteEntityUseCase {
    private IEntityRepository _repository;

    this(IEntityRepository repository) {
        _repository = repository;
    }

    ODataResponse execute(string entitySetName, string key) {
        if (!_repository.entitySetExists(entitySetName))
            return ODataResponse.notFound("Entity set '" ~ entitySetName ~ "' not found");

        auto removed = _repository.remove(entitySetName, key);
        if (!removed)
            return ODataResponse.notFound(
                "Entity with key '" ~ key ~ "' not found in " ~ entitySetName);

        return ODataResponse.noContent();
    }
}
