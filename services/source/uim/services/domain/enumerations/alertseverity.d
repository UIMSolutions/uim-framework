/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.enumerations.alertseverity;

import uim.service;

mixin(ShowModule!());

@safe:


// Alert severity
enum AlertSeverity {
  info,
  warning,
  error,
  critical,
  fatal
}

AlertSeverity toAlertSeverity(string value) {
  mixin(EnumSwitch("AlertSeverity", "info"));
}
AlertSeverity[] toAlertSeverities(string[] values) {
  return values.map!(toAlertSeverity).array;
}
string toString(AlertSeverity severity) {
  return severity.to!string;
}
string[] toString(AlertSeverity[] severities) {
  return severities.map!toString.array;
}
///
unittest {
  mixin(ShowTest!("AlertSeverity Enum"));

  assert(AlertSeverity.info.to!string == "info");
  assert(AlertSeverity.warning.to!string == "warning");
  assert(AlertSeverity.error.to!string == "error");
  assert(AlertSeverity.critical.to!string == "critical");
  assert(AlertSeverity.fatal.to!string == "fatal");

  assert("info".toAlertSeverity == AlertSeverity.info);
  assert("warning".toAlertSeverity == AlertSeverity.warning);
  assert("error".toAlertSeverity == AlertSeverity.error);
  assert("critical".toAlertSeverity == AlertSeverity.critical);
  assert("fatal".toAlertSeverity == AlertSeverity.fatal);

  assert("noexists".toAlertSeverity == AlertSeverity.info); // Default case
  assert("".toAlertSeverity == AlertSeverity.info); // Default case

  assert(["info", "warning", "error", "critical", "fatal"].toAlertSeverities == [AlertSeverity.info, AlertSeverity.warning, AlertSeverity.error, AlertSeverity.critical, AlertSeverity.fatal]);
  assert([AlertSeverity.info, AlertSeverity.warning, AlertSeverity.error, AlertSeverity.critical, AlertSeverity.fatal].toString == ["info", "warning", "error", "critical", "fatal"]);
}
