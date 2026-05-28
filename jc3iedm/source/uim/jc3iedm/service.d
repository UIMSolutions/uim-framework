/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jc3iedm.service;

import vibe.d : runTask;

import uim.jc3iedm;

mixin(ShowModule!());

@safe:

class UIMJC3IEDMService : UIMObject, IJC3IEDMService {
  private bool _connected;
  private string _endpoint;
  private IJC3IEDMEntity[string] _entities;

  bool connect(string endpointUrl) {
    if (endpointUrl.length == 0) {
      return false;
    }

    _endpoint = endpointUrl;
    _connected = true;
    return true;
  }

  bool disconnect() {
    if (!_connected) {
      return false;
    }

    _connected = false;
    _endpoint = "";
    return true;
  }

  bool connected() const {
    return _connected;
  }

  string endpoint() const {
    return _endpoint;
  }

  bool upsertEntity(IJC3IEDMEntity entity) {
    if (!_connected || entity is null || !entity.isValid()) {
      return false;
    }

    _entities[entity.id()] = entity;
    return true;
  }

  IJC3IEDMEntity entityById(string entityId) {
    auto normalized = jc3iedmNormalizeId(entityId);
    if (auto found = normalized in _entities) {
      return *found;
    }

    return null;
  }

  IJC3IEDMEntity[] entities() {
    IJC3IEDMEntity[] result;
    foreach (_id, value; _entities) {
      result ~= value;
    }

    return result;
  }

  IJC3IEDMEntity[] queryByType(JC3IEDMEntityType value) {
    IJC3IEDMEntity[] result;
    foreach (_id, e; _entities) {
      if (e.entityType() == value) {
        result ~= e;
      }
    }

    return result;
  }

  IJC3IEDMEntity[] queryByAffiliation(JC3IEDMAffiliation value) {
    IJC3IEDMEntity[] result;
    foreach (_id, e; _entities) {
      if (e.affiliation() == value) {
        result ~= e;
      }
    }

    return result;
  }

  IJC3IEDMEntity[] queryByAttribute(string key, string value) {
    IJC3IEDMEntity[] result;
    if (key.length == 0) {
      return result;
    }

    foreach (_id, e; _entities) {
      auto attrs = e.attributes();
      if (key in attrs && attrs[key] == value) {
        result ~= e;
      }
    }

    return result;
  }

  bool streamEntities(JC3IEDMEntityHandler handler) {
    if (!_connected || handler is null) {
      return false;
    }

    auto snapshot = entities();
    foreach (entity; snapshot) {
      auto localEntity = entity;
      auto localHandler = handler;

      (() @trusted {
        runTask(() nothrow {
          try {
            localHandler(localEntity);
          } catch (Exception) {
          }
        });
      })();
    }

    return true;
  }
}

IJC3IEDMService JC3IEDMService() {
  return new UIMJC3IEDMService();
}

unittest {
  auto service = JC3IEDMService();
  assert(service.connect("memory://jc3iedm"));

  auto a = JC3IEDMEntity("u-1", "Alpha", JC3IEDMEntityType.unit)
    .affiliation(JC3IEDMAffiliation.friendly)
    .setAttribute("nation", "DEU");

  auto b = JC3IEDMEntity("eq-1", "Radar", JC3IEDMEntityType.equipment)
    .affiliation(JC3IEDMAffiliation.friendly)
    .setAttribute("nation", "DEU");

  assert(service.upsertEntity(a));
  assert(service.upsertEntity(b));
  assert(service.queryByType(JC3IEDMEntityType.unit).length == 1);
  assert(service.queryByAffiliation(JC3IEDMAffiliation.friendly).length == 2);
  assert(service.queryByAttribute("nation", "DEU").length == 2);
  assert(service.entityById("u-1") !is null);

  assert(service.disconnect());
}
