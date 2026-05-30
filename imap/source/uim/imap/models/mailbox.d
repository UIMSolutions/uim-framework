/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.imap.models.mailbox;

import uim.imap;

mixin(ShowModule!());

@safe:

IMAPMailboxInfo IMAPMailboxInfoEmpty(string name = "") {
  IMAPMailboxInfo info;
  info.name = name;
  return info;
}

IMAPMessage IMAPMessageEmpty(ulong uid = 0) {
  IMAPMessage message;
  message.uid = uid;
  return message;
}

IMAPResult IMAPResultOk(string message = "ok") {
  IMAPResult result;
  result.success = true;
  result.message = message;
  return result;
}

IMAPResult IMAPResultErr(string message = "error") {
  IMAPResult result;
  result.success = false;
  result.message = message;
  return result;
}

unittest {
  auto inbox = IMAPMailboxInfoEmpty("INBOX");
  assert(inbox.name == "INBOX");

  auto ok = IMAPResultOk("done");
  assert(ok.success);
}
