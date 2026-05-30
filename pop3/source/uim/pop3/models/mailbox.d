/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.pop3.models.mailbox;

import uim.pop3;

mixin(ShowModule!());

@safe:

POP3Status POP3StatusOk(uint messageCount, ulong mailboxSizeBytes, string message = "ok") {
  POP3Status status;
  status.success = true;
  status.messageCount = messageCount;
  status.mailboxSizeBytes = mailboxSizeBytes;
  status.message = message;
  return status;
}

POP3Status POP3StatusErr(string message = "error") {
  POP3Status status;
  status.success = false;
  status.message = message;
  return status;
}

POP3Message POP3MessageEmpty(uint number = 0, string uid = "") {
  POP3Message message;
  message.number = number;
  message.uid = uid;
  return message;
}

POP3Result POP3ResultOk(string message = "ok") {
  POP3Result result;
  result.success = true;
  result.message = message;
  return result;
}

POP3Result POP3ResultErr(string message = "error") {
  POP3Result result;
  result.success = false;
  result.message = message;
  return result;
}

unittest {
  auto ok = POP3StatusOk(2, 1024, "mailbox ready");
  assert(ok.success);
  assert(ok.messageCount == 2);

  auto err = POP3ResultErr("cannot delete");
  assert(!err.success);
}
