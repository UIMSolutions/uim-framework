
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.mixins.obj;

import uim.oop;

mixin(ShowModule!());

@safe:

string objThis(string name, bool overrideMemberNames = true) {
  return `
    this() {
      super("{name}");
    }
    this(Json initData) {
      super("{name}", initData.toMap);
    }
    this(Json[string] initData) {
      super("{name}", initData);
    }
    this(string name, Json initData) {
      super(name, initData.toMap);
    }
    this(string name, Json[string] initData = null) {
      super(name, initData);
    }`.replace("{name}", name)
    ~
    (overrideMemberNames ? `override ` : ``) ~
    `string[] objMemberNames() {
      return [__traits(allMembers, typeof(this))];
    }
    `;
}

template ObjThis(string name, bool withOverride = true) {
  const char[] ObjThis = objThis(name, withOverride);
}

string objCalls(string name, string resultType = "auto") {
  return `
    {resultType} {name}() {{ return new D{name}(); }}
    {resultType} {name}(Json[string] initData) {{ return new D{name}(initData); }}
    {resultType} {name}(string name, Json[string] initData = null) {{ return new D{name}(name, initData); }}
    `.replace("{name}", name).replace("{resultType}", resultType);
}

template ObjCalls(string name, string resultType = "auto") {
  const char[] ObjCalls = objCalls(name, resultType);
}

string objTemplate(string name, bool withOverride = true, string resultType = "auto") {
  return objThis(name, withOverride) ~ objCalls(name, resultType);
}

template ObjTemplate(alias htmlClass, string name, bool withOverride = true, string resultType = "auto") {
  const char[] ObjTemplate = objTemplate(name, withOverride, resultType); // ~ HtmlMethods!htmlClass;
}
