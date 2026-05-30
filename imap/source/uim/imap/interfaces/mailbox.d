/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.imap.interfaces.mailbox;

@safe:

enum IMAPSecurity : ubyte {
  none = 0,
  startTLS = 1,
  tls = 2
}

struct IMAPConfig {
  string host;
  ushort port = 143;
  IMAPSecurity security = IMAPSecurity.none;
  string username;
  string password;
  uint connectTimeoutMs = 5_000;
  uint commandTimeoutMs = 5_000;
}

struct IMAPMailboxInfo {
  string name;
  uint messages;
  uint recent;
  uint unseen;
}

struct IMAPMessageMeta {
  uint sequence;
  ulong uid;
  ulong sizeBytes;
  string[] flags;
  string subject;
  string from;
  string date;
}

struct IMAPMessage {
  uint sequence;
  ulong uid;
  string raw;
  string headers;
  string body;
}

struct IMAPResult {
  bool success;
  string message;
}

alias IMAPMailboxInfoHandler = void delegate(IMAPMailboxInfo mailbox) @safe;
alias IMAPMessageHandler = void delegate(IMAPMessage message) @safe;
alias IMAPResultHandler = void delegate(IMAPResult result) @safe;

alias IMAPListMailboxesDelegate = IMAPMailboxInfo[] delegate(IMAPConfig config) @safe;
alias IMAPSelectMailboxDelegate = IMAPMailboxInfo delegate(IMAPConfig config, string mailbox) @safe;
alias IMAPSearchDelegate = ulong[] delegate(IMAPConfig config, string mailbox, string criteria) @safe;
alias IMAPFetchDelegate = IMAPMessage delegate(IMAPConfig config, string mailbox, ulong uid) @safe;
alias IMAPDeleteDelegate = IMAPResult delegate(IMAPConfig config, string mailbox, ulong uid) @safe;

interface IIMAPService {
  bool configure(IMAPConfig config);
  IMAPConfig config() const;

  bool setListMailboxesProvider(IMAPListMailboxesDelegate provider);
  bool setSelectMailboxProvider(IMAPSelectMailboxDelegate provider);
  bool setSearchProvider(IMAPSearchDelegate provider);
  bool setFetchProvider(IMAPFetchDelegate provider);
  bool setDeleteProvider(IMAPDeleteDelegate provider);

  IMAPMailboxInfo[] listMailboxes();
  IMAPMailboxInfo selectMailbox(string mailbox);
  ulong[] search(string mailbox, string criteria = "ALL");
  IMAPMessage fetch(string mailbox, ulong uid);
  IMAPResult deleteMessage(string mailbox, ulong uid);

  bool selectMailboxAsync(string mailbox, IMAPMailboxInfoHandler handler);
  bool fetchAsync(string mailbox, ulong uid, IMAPMessageHandler handler);
  bool deleteMessageAsync(string mailbox, ulong uid, IMAPResultHandler handler);

  IMAPMailboxInfo parseListLine(string line);
  ulong[] parseSearchLine(string line);
  IMAPMessage parseFetchResponse(ulong uid, string raw);
}
