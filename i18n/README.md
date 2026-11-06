# Library 📚 uim-i18n

Manage the languages of an application, translate its texts, and bring translations in from files and external systems.

- **Languages**: add and remove languages, fall back from `de_AT` to `de` to the default locale, pick a language from an `Accept-Language` header, and see what is still untranslated.
- **Translations**: placeholders, message contexts, and real plural forms with the rules of each language.
- **Upload**: `.properties`, `.po`, `.mo` and `.json` files, from code or through an HTTP endpoint.
- **Connectors**: read translations from HTTP systems or a directory, or implement your own.

## Getting started

```d
import uim.i18n;

auto manager = new I18nManager;                 // The default locale is "en"
manager.add(new I18nCatalog("en")
  .set("greeting", "Hello {0}")
  .setPlural("file", ["one file", "%d files"]));
manager.add(new I18nCatalog("de")
  .set("greeting", "Hallo {0}")
  .setPlural("file", ["eine Datei", "%d Dateien"]));

manager.translate("greeting", "de-AT", ["Ada"]);       // "Hallo Ada", through the parent "de"
manager.translatePlural("file", "files", 3, "de");     // "3 Dateien"
manager.translate("unknown", "de");                    // "unknown": the key is the last fallback
```

A lookup searches the locale, its parents and then the default locale. Unknown or invalid locales are no error, as they usually come from a client.

Each language selects plural forms by its own rule: the `Plural-Forms` header of its gettext file, or else a built-in rule for its language. Built-in rules cover `ar`, `cs`, `fr`, `id`, `ja`, `ko`, `pl`, `ru`, `sk`, `th`, `uk`, `vi` and `zh`; all other languages use the rule of English.

```d
auto locale = negotiateLocale(req.headers.get("Accept-Language", ""), manager.languages);

manager.missing("de");     // The messages of the default locale that "de" does not translate
manager.coverage("de");    // Their share as a value from 0 to 1
```

## Uploading language files

```d
auto uploader = new I18nUploader(manager);

uploader.upload("i18n_de.properties", content);              // One file
uploader.upload("texts.po", content, "fr-CA");               // With an explicit locale
uploader.upload([I18nUploadFile("de.po", a), I18nUploadFile("de.mo", b)]);  // All or nothing
```

The locale comes from the `locale` parameter, otherwise from the `Language` header of a `.po` or `.mo` file, otherwise from the file name (`i18n_de_AT.properties`). A file that names no locale goes to the default locale. By default, new messages replace equal keys; `mergeMode` also offers `keepExisting` and `replace`.

To accept uploads over HTTP:

```d
router.any("/i18n/*", &requireAdmin);   // Your authentication
uploader.registerRoute(router);         // POST /i18n/upload
```

> **The upload route has no authentication of its own.** It changes the texts that users see, so always put an authentication handler in front of it.

The route takes `multipart/form-data` with one or more files and an optional `locale` field. All files of a request are applied together, or none of them.

| Status | Meaning | Body |
| --- | --- | --- |
| 200 | Applied | `{"uploaded": [{"file", "format", "locale", "messages"}]}` |
| 400 | Bad request, locale or content | `{"error", "file"}` |
| 413 | File larger than `maxFileSize` (default 2 MiB) | `{"error", "file"}` |
| 415 | Unknown file type | `{"error", "file"}` |

`HTTPServerSettings.maxRequestSize` limits the whole request as well.

## File formats

| Format | Plurals | Contexts | Charsets |
| --- | --- | --- | --- |
| `.properties` | `key` and `key[1]`, `key[2]`, ... | no | UTF-8, ISO-8859-1 |
| `.po` | `msgstr[n]` | `msgctxt` | UTF-8, ASCII, ISO-8859-1 |
| `.mo` | yes | yes | UTF-8, ASCII, ISO-8859-1 |
| `.json` | as `.properties` | no | UTF-8 |

Like `msgfmt`, the gettext parsers skip fuzzy, obsolete and untranslated messages. Nested JSON is flattened to dotted keys, so `{"app": {"title": "x"}}` gives `app.title`.

## Connecting external systems

`I18nHttpConnector` reads any system that delivers one document for each locale, in one of the formats above:

```d
auto connector = new I18nHttpConnector("tms", "https://tms.example.com/api/{tag}/messages.json")
  .bearerToken(token)
  .jsonRoot("data.messages")                         // If the API wraps the messages
  .localesUrl("https://tms.example.com/api/locales"); // Or fixed: .locales(["de", "fr"])

foreach (result; manager.sync(connector)) {
  if (!result.ok) {
    logWarn("%s: %s", result.locale, result.error);
  }
}
```

- The URL template knows `{locale}` (`de_AT`), `{tag}` (`de-AT`) and `{language}` (`de`).
- The format follows from `format`, then the extension of the URL, then the `Content-Type`.
- Locales are independent: one that fails keeps its messages and is reported in the result.
- In the mode `replace`, an empty document counts as a failure and leaves the language untouched.
- Redirects are not followed, as they would hand your credentials to another host.
- Documents are limited by `maxResponseSize` (default 16 MiB, also after decompression), and requests by `timeout` (default 30 seconds).

`sync` runs once. To keep translations up to date, call it from a timer, for example with `setTimer` of vibe.d.

`I18nDirectoryConnector` reads the language files of a directory, which suits the export of another system on a shared volume:

```d
manager.sync(new I18nDirectoryConnector("/srv/translations"));
```

For anything else, implement `I18nConnector`:

```d
class MyConnector : I18nConnector {
  string name() { return "my-system"; }
  string[] locales() { return ["de", "fr"]; }
  I18nCatalog fetch(string locale) { return new I18nCatalog(locale).set("key", "text"); }
}
```

## Limits

- A manager belongs to one thread, like other vibe.d objects without locking.
- Translations live in memory. Persist them with your own storage, or sync them again at startup.
- Other gettext charsets, such as KOI8-R, are rejected with an error. Convert those files to UTF-8 with `msgconv` or `iconv`.

## Build and test

```bash
dub build :i18n --compiler=dmd
cd i18n && dub test --temp-build --compiler=dmd
```
