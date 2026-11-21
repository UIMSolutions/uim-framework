/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.mixins.enumerations;

import uim.service;

mixin(ShowModule!());

@safe:

// string toEnum(string s, string enumName) {
//     final string fullName = "uim.service.mixins.enumerations." ~ enumName;
//     final TypeInfoEnum* enumInfo = cast(TypeInfoEnum*)TypeInfo.getTypeInfoByName(fullName);
//     if (enumInfo is null) {
//         throw new Exception("Enumeration type not found: " ~ fullName);
//     }
//     foreach (i, member; enumInfo.members) {
//         if (member.toLower() == s.toLower()) {
//             return member;
//         }
//     }
//     throw new Exception("Invalid value '" ~ s ~ "' for enumeration " ~ fullName);
// }

