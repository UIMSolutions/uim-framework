/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.imap.service;

import vibe.d : runTask;

import uim.imap;

mixin(ShowModule!());

@safe:

class UIMIMAPService : UIMObject, IIMAPService {
  private IMAPConfig _config;
  private bool _configured;

  private IMAPListMailboxesDelegate _listProvider;
  private IMAPSelectMailboxDelegate _selectProvider;
  private IMAPSearchDelegate _searchProvider;
  private IMAPFetchDelegate _fetchProvider;
  private IMAPDeleteDelegate _deleteProvider;

  bool configure(IMAPConfig config) {
    if (config.host.length == 0 || config.port == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  IMAPConfig config() const {
    return _config;
  }

  bool setListMailboxesProvider(IMAPListMailboxesDelegate provider) {
    _listProvider = provider;
    return true;
  }

  bool setSelectMailboxProvider(IMAPSelectMailboxDelegate provider) {
    _selectProvider = provider;
    return true;
  }

  bool setSearchProvider(IMAPSearchDelegate provider) {
    _searchProvider = provider;
    return true;
  }

  bool setFetchProvider(IMAPFetchDelegate provider) {
    _fetchProvider = provider;
    return true;
  }

  bool setDeleteProvider(IMAPDeleteDelegate provider) {
    _deleteProvider = provider;
    return true;
  }

  IMAPMailboxInfo[] listMailboxes() {
    IMAPMailboxInfo[] result;
    if (!_configured) {
      return result;
    }

    if (_listProvider !is null) {
      try {
        return _listProvider(_config);
      } catch (Exception) {
        return result;
      }
    }

    result ~= IMAPMailboxInfo("INBOX", 12, 1, 2);
    result ~= IMAPMailboxInfo("Archive", 230, 0, 0);
    return result;
  }

  IMAPMailboxInfo selectMailbox(string mailbox) {
    if (!_configured || mailbox.length == 0) {
      return IMAPMailboxInfoEmpty(mailbox);
    }

    if (_selectProvider !is null) {
      try {
        return _selectProvider(_config, mailbox);
      } catch (Exception) {
        return IMAPMailboxInfoEmpty(mailbox);
      }
    }

    if (mailbox == "INBOX") {
      return IMAPMailboxInfo("INBOX", 12, 1, 2);
    }

    return IMAPMailboxInfo(mailbox, 0, 0, 0);
  }

  ulong[] search(string mailbox, string criteria = "ALL") {
    ulong[] result;
    if (!_configured || mailbox.length == 0) {
      return result;
    }

    if (_searchProvider !is null) {
      try {
        return _searchProvider(_config, mailbox, criteria);
      } catch (Exception) {
        return result;
      }
    }

    if (criteria == "UNSEEN") {
      result ~= 2001;
      result ~= 2005;
      return result;
    }

    result ~= 2001;
    result ~= 2002;
    result ~= 2003;
    return result;
  }

  IMAPMessage fetch(string mailbox, ulong uid) {
    if (!_configured || mailbox.length == 0 || uid == 0) {
      return IMAPMessageEmpty(uid);
    }

    if (_fetchProvider !is null) {
      try {
        return _fetchProvider(_config, mailbox, uid);
      } catch (Exception) {
        return IMAPMessageEmpty(uid);
      }
    }

    auto raw = "From: system@example.org\r\n"
      ~ "To: user@example.org\r\n"
      ~ "Subject: IMAP demo\r\n"
      ~ "\r\n"
      ~ "This message was fetched from in-memory IMAP provider.";

    auto message = parseFetchResponse(uid, raw);
    message.sequence = 1;
    return message;
  }

  IMAPResult deleteMessage(string mailbox, ulong uid) {
    if (!_configured) {
      return IMAPResultErr("IMAP service is not configured.");
    }

    if (mailbox.length == 0 || uid == 0) {
      return IMAPResultErr("mailbox and uid are required");
    }

    if (_deleteProvider !is null) {
      try {
        return _deleteProvider(_config, mailbox, uid);
      } catch (Exception ex) {
        return IMAPResultErr(ex.msg);
      }
    }

    return IMAPResultOk("message flagged as \\Deleted and expunged");
  }

  bool selectMailboxAsync(string mailbox, IMAPMailboxInfoHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localMailbox = mailbox;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(selectMailbox(localMailbox));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool fetchAsync(string mailbox, ulong uid, IMAPMessageHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localMailbox = mailbox;
    auto localUid = uid;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(fetch(localMailbox, localUid));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool deleteMessageAsync(string mailbox, ulong uid, IMAPResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localMailbox = mailbox;
    auto localUid = uid;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(deleteMessage(localMailbox, localUid));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  IMAPMailboxInfo parseListLine(string line) {
    return imapParseListLine(line);
  }

  ulong[] parseSearchLine(string line) {
    return imapParseSearchLine(line);
  }

  IMAPMessage parseFetchResponse(ulong uid, string raw) {
    return imapParseFetchResponse(uid, raw);
  }
}

IIMAPService IMAPService() {
  return new UIMIMAPService();
}

unittest {
  auto service = IMAPService();

  IMAPConfig config;
  config.host = "imap.example.org";
  config.port = 143;
  assert(service.configure(config));

  auto mailboxes = service.listMailboxes();
  assert(mailboxes.length >= 1);

  auto inbox = service.selectMailbox("INBOX");
  assert(inbox.name == "INBOX");

  auto ids = service.search("INBOX", "ALL");
  assert(ids.length >= 1);

  auto message = service.fetch("INBOX", ids[0]);
  assert(message.uid == ids[0]);

  auto result = service.deleteMessage("INBOX", ids[0]);
  assert(result.success);
}
