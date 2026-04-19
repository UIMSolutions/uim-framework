/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.classes.repository;

import std.algorithm.iteration : filter;
import std.algorithm.sorting : sort;
import std.array : array;
import std.conv : to;

import vibe.data.json : Json;

import uim.odata.interfaces.repository;
import uim.odata.types.queryoptions;

@safe:

/// Secondary (driven) adapter — in-memory entity repository for testing,
/// prototyping, or as a reference implementation of the IEntityRepository port.
class InMemoryEntityRepository : IEntityRepository {
    private Json[][string] _storage;
    private string[string] _keyProperties; // entity set name -> key property name

    /// Register an entity set with the name of its key property.
    void registerEntitySet(string name, string keyProperty = "Id") {
        if (name !in _storage)
            _storage[name] = [];
        _keyProperties[name] = keyProperty;
    }

    // -- IEntityRepository ------------------------------------------------

    override bool entitySetExists(string entitySetName) {
        return (entitySetName in _storage) !is null;
    }

    override Json[] findAll(string entitySetName) {
        if (auto p = entitySetName in _storage)
            return *p;
        return [];
    }

    override Json[] findWithOptions(string entitySetName, QueryOptions options) @trusted {
        auto all = findAll(entitySetName);
        Json[] result = all.dup;

        // $filter — basic field comparison (field eq 'value' / field eq number)
        if (options.hasFilter)
            result = applyFilter(result, options.filter);

        // $orderby
        if (options.hasOrderBy)
            result = applyOrderBy(result, options.orderby);

        // $skip
        if (options.skip > 0 && options.skip < result.length)
            result = result[options.skip .. $];
        else if (options.skip >= result.length)
            result = [];

        // $top
        if (options.hasTop && options.top < result.length)
            result = result[0 .. options.top];

        // $select
        if (options.hasSelect)
            result = applySelect(result, options.select);

        return result;
    }

    override Json findByKey(string entitySetName, string key) @trusted {
        auto keyProp = _keyProperties.get(entitySetName, "Id");
        foreach (entity; findAll(entitySetName)) {
            if (jsonValueAsString(entity[keyProp]) == key)
                return entity;
        }
        return Json(null);
    }

    override Json create(string entitySetName, Json entity) @trusted {
        if (auto p = entitySetName in _storage) {
            *p ~= entity;
            return entity;
        }
        return Json(null);
    }

    override Json update(string entitySetName, string key, Json entity) @trusted {
        auto keyProp = _keyProperties.get(entitySetName, "Id");
        if (auto p = entitySetName in _storage) {
            foreach (ref existing; *p) {
                if (jsonValueAsString(existing[keyProp]) == key) {
                    existing = entity;
                    return entity;
                }
            }
        }
        return Json(null);
    }

    override Json patch(string entitySetName, string key, Json partialEntity) @trusted {
        auto keyProp = _keyProperties.get(entitySetName, "Id");
        if (auto p = entitySetName in _storage) {
            foreach (ref existing; *p) {
                if (jsonValueAsString(existing[keyProp]) == key) {
                    // merge partial into existing
                    if (partialEntity.type == Json.Type.object) {
                        foreach (string k, v; partialEntity.byKeyValue)
                            existing[k] = v;
                    }
                    return existing;
                }
            }
        }
        return Json(null);
    }

    override bool remove(string entitySetName, string key) @trusted {
        auto keyProp = _keyProperties.get(entitySetName, "Id");
        if (auto p = entitySetName in _storage) {
            auto before = (*p).length;
            *p = (*p).filter!(
                e => jsonValueAsString(e[keyProp]) != key
            ).array;
            return (*p).length < before;
        }
        return false;
    }

    override ulong count(string entitySetName) {
        if (auto p = entitySetName in _storage)
            return cast(ulong)(*p).length;
        return 0;
    }
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

/// Extracts the string representation of a Json value for key comparison.
private string jsonValueAsString(Json v) @trusted {
    if (v.type == Json.Type.undefined || v.type == Json.Type.null_)
        return "";
    if (v.type == Json.Type.string)
        return v.get!string;
    return v.toString();
}

/// Very simple $filter evaluation: supports "Property eq Value".
private Json[] applyFilter(Json[] entities, string filterExpr) @trusted {
    import std.string : indexOf, strip;

    auto eqPos = indexOf(filterExpr, " eq ");
    if (eqPos < 0)
        return entities; // unsupported filter — return all

    auto field = filterExpr[0 .. eqPos].strip;
    auto rawVal = filterExpr[eqPos + 4 .. $].strip;

    // strip surrounding quotes
    if (rawVal.length >= 2 && rawVal[0] == '\'' && rawVal[$ - 1] == '\'')
        rawVal = rawVal[1 .. $ - 1];

    return entities.filter!(e => jsonValueAsString(e[field]) == rawVal).array;
}

/// Applies $orderby clauses.
private Json[] applyOrderBy(Json[] entities, OrderByClause[] clauses) @trusted {
    if (clauses.length == 0)
        return entities;

    entities.sort!((a, b) {
        foreach (clause; clauses) {
            auto va = jsonValueAsString(a[clause.property]);
            auto vb = jsonValueAsString(b[clause.property]);
            if (va == vb)
                continue;
            return clause.descending ? (va > vb) : (va < vb);
        }
        return false;
    });

    return entities;
}

/// Applies $select — keeps only the listed properties.
private Json[] applySelect(Json[] entities, string[] selectFields) @trusted {
    Json[] result;
    foreach (entity; entities) {
        auto selected = Json.emptyObject;
        foreach (field; selectFields) {
            if (entity.type == Json.Type.object) {
                auto val = entity[field];
                if (val.type != Json.Type.undefined)
                    selected[field] = val;
            }
        }
        result ~= selected;
    }
    return result;
}
