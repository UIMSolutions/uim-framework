/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.helpers.convert;
import uim.service;

mixin(ShowModule!());

@safe:
private Json toJsonArray(string[] values) {
  return values.map!(v => v.toJson()).array.toJson;
}

Json toJsonArray(UIMEntity[] metrics) {
  return metrics.map!(m => m.toJson()).array.toJson;
}

private Json toJsonArray(T)(T[] values) {
  return values.map!(v => v.toJson()).array.toJson;
}

UserId toUserId(string s) {
  // auto parts = s.split(":");
  // if (parts.length != 2)
  //     throw new Exception("Invalid User ID format");
  // return UserId(parts[0], parts[1]);
  return UserId(s);
}

UserId getCreatedBy(Json data) {
  return toUserId(data.getString("createdBy"));
}

UserId getUpdatedBy(Json data) {
  return toUserId(data.getString("updatedBy"));
}

TenantId toTenantId(string s) {
    return TenantId(s);
}

TenantId tenantId(Json data) {
    return TenantId(data.getString("tenantId"));
}



UserId userId(Json data, string key = "userId") {
    return UserId(data.getString(key));
}


