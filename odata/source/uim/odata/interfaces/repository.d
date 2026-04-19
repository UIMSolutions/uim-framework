/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.interfaces.repository;

import vibe.data.json : Json;

import uim.odata.types.queryoptions;

/// Outbound port — abstracts entity persistence.
/// Implement this interface to connect OData to any storage back-end
/// (database, file system, remote service, etc.).
interface IEntityRepository {
    /// Returns all entities in the given entity set.
    Json[] findAll(string entitySetName);

    /// Returns entities filtered / paged according to query options.
    Json[] findWithOptions(string entitySetName, QueryOptions options);

    /// Returns a single entity identified by its key, or Json(null).
    Json findByKey(string entitySetName, string key);

    /// Creates a new entity and returns the stored representation.
    Json create(string entitySetName, Json entity);

    /// Full replacement update (PUT semantics).
    Json update(string entitySetName, string key, Json entity);

    /// Partial update (PATCH / MERGE semantics).
    Json patch(string entitySetName, string key, Json partialEntity);

    /// Deletes an entity. Returns true when the entity existed and was removed.
    bool remove(string entitySetName, string key);

    /// Returns the total count of entities in an entity set.
    ulong count(string entitySetName);

    /// Checks whether an entity set is registered / known.
    bool entitySetExists(string entitySetName);
}
