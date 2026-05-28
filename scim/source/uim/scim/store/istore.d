/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.store.istore;

import uim.scim.schemas.user;
import uim.scim.schemas.group;
import uim.scim.operations.patch;
import uim.scim.operations.list;

@safe:

// User store contract — CRUD + list/filter for SCIM User resources
interface IScimUserStore {
  ScimUser                  createUser(ScimUser user)                     @safe;
  ScimUser                  getUser(string id)                             @safe;
  ScimUser                  getUserByName(string userName)                 @safe;
  ScimUser                  replaceUser(string id, ScimUser user)          @safe;
  bool                      patchUser(string id, ScimPatchRequest op)      @safe;
  bool                      deleteUser(string id)                          @safe;
  ScimListResponse!ScimUser listUsers(ScimListRequest req)                 @safe;
}

// Group store contract — CRUD + list/filter for SCIM Group resources
interface IScimGroupStore {
  ScimGroup                  createGroup(ScimGroup group)                   @safe;
  ScimGroup                  getGroup(string id)                             @safe;
  ScimGroup                  replaceGroup(string id, ScimGroup group)        @safe;
  bool                       patchGroup(string id, ScimPatchRequest op)      @safe;
  bool                       deleteGroup(string id)                          @safe;
  ScimListResponse!ScimGroup listGroups(ScimListRequest req)                 @safe;
}
