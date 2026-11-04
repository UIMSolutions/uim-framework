/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.pwa.manifest;

import uim.web;

mixin(ShowModule!());

@safe:

/// Display modes of a PWA (W3C Web App Manifest)
enum PwaDisplay {
  fullscreen,
  standalone,
  minimalUi,
  browser
}

/// Converts a display mode to its manifest string
string toString(PwaDisplay display) {
  final switch (display) {
    case PwaDisplay.fullscreen:
      return "fullscreen";
    case PwaDisplay.standalone:
      return "standalone";
    case PwaDisplay.minimalUi:
      return "minimal-ui";
    case PwaDisplay.browser:
      return "browser";
  }
}

/// Screen orientation lock of a PWA
enum PwaOrientation {
  any,
  natural,
  portrait,
  portraitPrimary,
  portraitSecondary,
  landscape,
  landscapePrimary,
  landscapeSecondary
}

/// Converts an orientation to its manifest string
string toString(PwaOrientation orientation) {
  final switch (orientation) {
    case PwaOrientation.any:
      return "any";
    case PwaOrientation.natural:
      return "natural";
    case PwaOrientation.portrait:
      return "portrait";
    case PwaOrientation.portraitPrimary:
      return "portrait-primary";
    case PwaOrientation.portraitSecondary:
      return "portrait-secondary";
    case PwaOrientation.landscape:
      return "landscape";
    case PwaOrientation.landscapePrimary:
      return "landscape-primary";
    case PwaOrientation.landscapeSecondary:
      return "landscape-secondary";
  }
}

/// An icon entry of a web app manifest.
struct PwaIcon {
  string src;
  string sizes;
  string type;
  string purpose; // e.g. "any", "maskable", "any maskable"

  /// Renders the icon as a Json object
  // @trusted: Json construction is memory-safe here
  @trusted Json toJson() const {
    auto json = Json.emptyObject;
    json["src"] = src;
    json["sizes"] = sizes;
    if (type.length > 0) {
      json["type"] = type;
    }
    if (purpose.length > 0) {
      json["purpose"] = purpose;
    }
    return json;
  }
}

/// Creates a manifest icon, e.g. pwaIcon("/icon-192.png", "192x192")
PwaIcon pwaIcon(string src, string sizes, string type = null, string purpose = null) {
  return PwaIcon(src, sizes, type, purpose);
}

/// Creates a maskable manifest icon
PwaIcon pwaIconMaskable(string src, string sizes, string type = "image/png") {
  return PwaIcon(src, sizes, type, "maskable");
}

/// A shortcut entry of a web app manifest.
struct PwaShortcut {
  string name;
  string url;
  string shortName;
  string description;
  PwaIcon[] icons;

  /// Renders the shortcut as a Json object
  // @trusted: Json construction is memory-safe here
  @trusted Json toJson() const {
    auto json = Json.emptyObject;
    json["name"] = name;
    json["url"] = url;
    if (shortName.length > 0) {
      json["short_name"] = shortName;
    }
    if (description.length > 0) {
      json["description"] = description;
    }
    if (icons.length > 0) {
      auto iconArray = Json.emptyArray;
      foreach (icon; icons) {
        iconArray ~= icon.toJson;
      }
      json["icons"] = iconArray;
    }
    return json;
  }
}

/// Creates a manifest shortcut, e.g. pwaShortcut("Tasks", "/tasks")
PwaShortcut pwaShortcut(string name, string url) {
  return PwaShortcut(name, url);
}

/// A web app manifest (manifest.json) describing an installable PWA.
class PwaManifest {
  this(string name) {
    _name = name;
  }

  /// The full application name
  string name() const {
    return _name;
  }

  /// Sets the short name shown under the icon (fluent interface)
  auto shortName(string value) {
    _shortName = value;
    return this;
  }

  /// Sets the description (fluent interface)
  auto description(string value) {
    _description = value;
    return this;
  }

  /// Sets the start URL (fluent interface)
  auto startUrl(string value) {
    _startUrl = value;
    return this;
  }

  /// Sets the scope URL (fluent interface)
  auto scopeUrl(string value) {
    _scopeUrl = value;
    return this;
  }

  /// Sets the display mode (fluent interface)
  auto display(PwaDisplay value) {
    _display = value;
    return this;
  }

  /// Sets the orientation lock (fluent interface)
  auto orientation(PwaOrientation value) {
    _orientation = value;
    _hasOrientation = true;
    return this;
  }

  /// Sets the theme color, e.g. "#3498db" (fluent interface)
  auto themeColor(string value) {
    _themeColor = value;
    return this;
  }

  /// Sets the background color shown while the app loads (fluent interface)
  auto backgroundColor(string value) {
    _backgroundColor = value;
    return this;
  }

  /// Sets the language, e.g. "de" (fluent interface)
  auto lang(string value) {
    _lang = value;
    return this;
  }

  /// Sets the text direction, e.g. "ltr" or "rtl" (fluent interface)
  auto dir(string value) {
    _dir = value;
    return this;
  }

  /// Adds an icon (fluent interface)
  auto icon(PwaIcon value) {
    _icons ~= value;
    return this;
  }

  /// Adds an icon (fluent interface)
  auto icon(string src, string sizes, string type = null, string purpose = null) {
    return icon(PwaIcon(src, sizes, type, purpose));
  }

  /// Adds a shortcut (fluent interface)
  auto shortcut(PwaShortcut value) {
    _shortcuts ~= value;
    return this;
  }

  /// All icons of the manifest
  PwaIcon[] icons() const {
    return _icons.dup;
  }

  /// All shortcuts of the manifest
  PwaShortcut[] shortcuts() {
    return _shortcuts.dup;
  }

  /// Renders the manifest as a Json object
  // @trusted: Json construction is memory-safe here
  @trusted Json toJson() const {
    auto json = Json.emptyObject;
    json["name"] = _name;
    if (_shortName.length > 0) {
      json["short_name"] = _shortName;
    }
    if (_description.length > 0) {
      json["description"] = _description;
    }
    json["start_url"] = _startUrl;
    if (_scopeUrl.length > 0) {
      json["scope"] = _scopeUrl;
    }
    json["display"] = _display.toString;
    if (_hasOrientation) {
      json["orientation"] = _orientation.toString;
    }
    if (_themeColor.length > 0) {
      json["theme_color"] = _themeColor;
    }
    if (_backgroundColor.length > 0) {
      json["background_color"] = _backgroundColor;
    }
    if (_lang.length > 0) {
      json["lang"] = _lang;
    }
    if (_dir.length > 0) {
      json["dir"] = _dir;
    }
    if (_icons.length > 0) {
      auto iconArray = Json.emptyArray;
      foreach (icon; _icons) {
        iconArray ~= icon.toJson;
      }
      json["icons"] = iconArray;
    }
    if (_shortcuts.length > 0) {
      auto shortcutArray = Json.emptyArray;
      foreach (shortcut; _shortcuts) {
        shortcutArray ~= shortcut.toJson;
      }
      json["shortcuts"] = shortcutArray;
    }
    return json;
  }

  /// Renders the manifest as a JSON string (content of manifest.json)
  // @trusted: Json serialization is memory-safe here
  @trusted override string toString() const {
    return toJson.toString;
  }

  /// Renders the HTML link tag referencing the manifest file
  string toHtml(string href = "/manifest.json") const {
    return new HtmlElement("link").attr("rel", "manifest").attr("href", href).toString;
  }

  /// Renders the theme-color meta tag (empty if no theme color is set)
  string themeColorMeta() const {
    return _themeColor.length > 0 ? metaName("theme-color", _themeColor) : null;
  }

  /// Renders the apple-touch-icon link tags for iOS home screen icons
  string[] appleTouchIcons() const {
    return _icons
      .filter!(icon => icon.purpose != "maskable")
      .map!(icon => new HtmlElement("link")
          .attr("rel", "apple-touch-icon")
          .attr("sizes", icon.sizes)
          .attr("href", icon.src)
          .toString)
      .array;
  }

  private string _name;
  private string _shortName;
  private string _description;
  private string _startUrl = "/";
  private string _scopeUrl;
  private PwaDisplay _display = PwaDisplay.standalone;
  private PwaOrientation _orientation;
  private bool _hasOrientation;
  private string _themeColor;
  private string _backgroundColor;
  private string _lang;
  private string _dir;
  private PwaIcon[] _icons;
  private PwaShortcut[] _shortcuts;
}

/// Creates a web app manifest, e.g. pwaManifest("My App")
PwaManifest pwaManifest(string name) {
  return new PwaManifest(name);
}

///
unittest {
  // display and orientation strings
  assert(PwaDisplay.standalone.toString == "standalone");
  assert(PwaDisplay.minimalUi.toString == "minimal-ui");
  assert(PwaOrientation.portraitPrimary.toString == "portrait-primary");

  // icons
  auto icon = pwaIcon("/icon-192.png", "192x192", "image/png");
  assert(icon.toJson["src"].get!string == "/icon-192.png");
  assert(icon.toJson["sizes"].get!string == "192x192");
  assert(icon.toJson["type"].get!string == "image/png");
  assert(!("purpose" in icon.toJson));

  auto maskable = pwaIconMaskable("/maskable.png", "512x512");
  assert(maskable.purpose == "maskable");
  assert(maskable.toJson["purpose"].get!string == "maskable");

  // shortcuts
  auto shortcut = pwaShortcut("Tasks", "/tasks");
  assert(shortcut.toJson["name"].get!string == "Tasks");
  assert(shortcut.toJson["url"].get!string == "/tasks");

  // manifest
  auto manifest = pwaManifest("My App")
    .shortName("MyApp")
    .description("A test app")
    .startUrl("/app")
    .scopeUrl("/app/")
    .display(PwaDisplay.standalone)
    .orientation(PwaOrientation.portrait)
    .themeColor("#3498db")
    .backgroundColor("#ffffff")
    .lang("de")
    .dir("ltr")
    .icon("/icon-192.png", "192x192", "image/png")
    .icon(pwaIconMaskable("/maskable.png", "512x512"))
    .shortcut(pwaShortcut("Tasks", "/tasks"));

  assert(manifest.name == "My App");
  assert(manifest.icons.length == 2);
  assert(manifest.shortcuts.length == 1);

  auto json = manifest.toJson;
  assert(json["name"].get!string == "My App");
  assert(json["short_name"].get!string == "MyApp");
  assert(json["start_url"].get!string == "/app");
  assert(json["scope"].get!string == "/app/");
  assert(json["display"].get!string == "standalone");
  assert(json["orientation"].get!string == "portrait");
  assert(json["theme_color"].get!string == "#3498db");
  assert(json["background_color"].get!string == "#ffffff");
  assert(json["lang"].get!string == "de");
  assert(json["icons"].length == 2);
  assert(json["shortcuts"].length == 1);

  // defaults
  auto minimal = pwaManifest("Mini");
  auto minimalJson = minimal.toJson;
  assert(minimalJson["start_url"].get!string == "/");
  assert(minimalJson["display"].get!string == "standalone");
  assert(!("orientation" in minimalJson));
  assert(!("theme_color" in minimalJson));
  assert(!("icons" in minimalJson));

  // HTML rendering
  assert(manifest.toHtml == `<link rel="manifest" href="/manifest.json">`);
  assert(manifest.toHtml("/app.webmanifest") == `<link rel="manifest" href="/app.webmanifest">`);
  assert(manifest.themeColorMeta == `<meta name="theme-color" content="#3498db">`);
  assert(minimal.themeColorMeta is null);

  auto appleIcons = manifest.appleTouchIcons;
  assert(appleIcons.length == 1); // maskable icon is excluded
  assert(appleIcons[0] == `<link rel="apple-touch-icon" sizes="192x192" href="/icon-192.png">`);

  // JSON string contains the name
  assert(manifest.toString.canFind(`"name":"My App"`));
}
