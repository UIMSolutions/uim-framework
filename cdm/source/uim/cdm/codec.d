/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdm.codec;

import std.conv : to;
import std.datetime : SysTime;
import std.json;

import uim.cdm;

mixin(ShowModule!());

@safe:

@trusted string cdmEncodeJson(ICdmDocument document) {
  JSONValue root;
  root["id"] = document.id();
  root["name"] = document.name();
  root["namespaceUri"] = document.namespaceUri();
  root["version"] = document.version_();
  root["createdStdTime"] = cast(long) document.created().stdTime;

  JSONValue metadataNode;
  foreach (key, value; document.metadata()) {
    metadataNode[key] = value;
  }
  root["metadata"] = metadataNode;

  JSONValue[] entitiesArray;
  foreach (entity; document.entities()) {
    JSONValue entityNode;
    entityNode["name"] = entity.name();
    entityNode["description"] = entity.description();

    JSONValue[] fieldArray;
    foreach (field; entity.fields()) {
      JSONValue item;
      item["name"] = field.name();
      item["dataType"] = cdmDataTypeToString(field.dataType());
      item["value"] = field.value();
      fieldArray ~= item;
    }
    entityNode["fields"] = JSONValue(fieldArray);

    JSONValue entityMetadata;
    foreach (key, value; entity.metadata()) {
      entityMetadata[key] = value;
    }
    entityNode["metadata"] = entityMetadata;

    entitiesArray ~= entityNode;
  }
  root["entities"] = JSONValue(entitiesArray);

  return root.toString();
}

@trusted ICdmDocument cdmDecodeJson(string payload) {
  auto root = parseJSON(payload);
  auto rootObject = (() @trusted => root.object)();

  auto document = CdmDocument(
    root["id"].str,
    root["name"].str,
    root["namespaceUri"].str,
    root["version"].str
  );

  if ("createdStdTime" in rootObject) {
    document.created(SysTime(root["createdStdTime"].integer.to!long));
  }

  if ("metadata" in rootObject && root["metadata"].type == JSONType.object) {
    auto metadataObject = (() @trusted => root["metadata"].object)();
    foreach (key, value; metadataObject) {
      document.setMetadata(key, value.str);
    }
  }

  if ("entities" in rootObject && root["entities"].type == JSONType.array) {
    auto entitiesArray = root["entities"].array;
    foreach (entityValue; entitiesArray) {
      auto entity = CdmEntity(
        entityValue["name"].str,
        entityValue["description"].str
      );

      auto entityObject = (() @trusted => entityValue.object)();

      if ("metadata" in entityObject && entityValue["metadata"].type == JSONType.object) {
        auto entityMetadata = (() @trusted => entityValue["metadata"].object)();
        foreach (key, value; entityMetadata) {
          entity.setMetadata(key, value.str);
        }
      }

      if ("fields" in entityObject && entityValue["fields"].type == JSONType.array) {
        auto fieldArray = entityValue["fields"].array;
        foreach (fieldValue; fieldArray) {
          entity.addField(
            CdmField(
              fieldValue["name"].str,
              cdmDataTypeFromString(fieldValue["dataType"].str),
              fieldValue["value"].str
            )
          );
        }
      }

      document.addEntity(entity);
    }
  }

  return document;
}

unittest {
  auto document = CdmDocument("CDM-1", "Mission Data Model", "urn:uim:cdm:mission");
  document.setMetadata("owner", "HQ-NORTH");
  document.addEntity(
    CdmEntity("MissionReport")
      .addField(CdmField("reportId", CdmDataType.identifier, "MR-001"))
      .addField(CdmField("status", CdmDataType.string, "open"))
  );

  auto json = cdmEncodeJson(document);
  auto parsed = cdmDecodeJson(json);

  assert(parsed.name() == "Mission Data Model");
  assert(parsed.metadata()["owner"] == "HQ-NORTH");
  assert(parsed.entities().length == 1);
  assert(parsed.entities()[0].name() == "MissionReport");
}
