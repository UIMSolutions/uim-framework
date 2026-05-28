/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.adatp3.interfaces.message;

import std.datetime : SysTime;

import uim.adatp3.types;

@safe:

interface IADatP3Message {
  ADatP3MessageType messageType();
  IADatP3Message messageType(ADatP3MessageType value);

  string messageId();
  IADatP3Message messageId(string value);

  string originator();
  IADatP3Message originator(string value);

  string recipient();
  IADatP3Message recipient(string value);

  SysTime timestamp();
  IADatP3Message timestamp(SysTime value);

  ADatP3Priority priority();
  IADatP3Message priority(ADatP3Priority value);

  string[string] fields();
  IADatP3Message fields(string[string] value);

  IADatP3Message setField(string key, string value);
  string field(string key, string defaultValue = "") const;
}
