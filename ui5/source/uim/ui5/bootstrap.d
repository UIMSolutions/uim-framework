/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.bootstrap;

import uim.ui5;

mixin(ShowModule!());

@safe:

/// The UI5 distribution variant
enum Ui5Variant {
  openui5,
  sapui5
}

/// Well-known UI5 themes
enum Ui5Theme {
  sapHorizon,
  sapHorizonDark,
  sapFiori3,
  sapFiori3Dark,
  sapBelize,
  sapBelizeDeep,
  sapQuartzLight,
  sapQuartzDark
}

/// Converts a theme to its technical name, e.g. Ui5Theme.sapHorizon -> "sap_horizon"
string toString(Ui5Theme theme) {
  final switch (theme) {
    case Ui5Theme.sapHorizon:
      return "sap_horizon";
    case Ui5Theme.sapHorizonDark:
      return "sap_horizon_dark";
    case Ui5Theme.sapFiori3:
      return "sap_fiori_3";
    case Ui5Theme.sapFiori3Dark:
      return "sap_fiori_3_dark";
    case Ui5Theme.sapBelize:
      return "sap_belize";
    case Ui5Theme.sapBelizeDeep:
      return "sap_belize_deep";
    case Ui5Theme.sapQuartzLight:
      return "sap_quartz_light";
    case Ui5Theme.sapQuartzDark:
      return "sap_quartz_dark";
  }
}

/// CDN base URL of a UI5 variant
string cdnBase(Ui5Variant variant) {
  final switch (variant) {
    case Ui5Variant.openui5:
      return "https://sdk.openui5.org";
    case Ui5Variant.sapui5:
      return "https://sapui5.hana.ondemand.com";
  }
}

/// Resource root URL of a UI5 variant, e.g. cdnResourceRoot(Ui5Variant.openui5, "1.120.0")
string cdnResourceRoot(Ui5Variant variant, string version_ = null) {
  return version_.length > 0
    ? "%s/%s/resources".format(cdnBase(variant), version_)
    : "%s/resources".format(cdnBase(variant));
}

/// URL of the sap-ui-core.js bootstrap script
string cdnBootstrapScript(Ui5Variant variant, string version_ = null) {
  return "%s/sap-ui-core.js".format(cdnResourceRoot(variant, version_));
}

/// Configuration of the UI5 bootstrap (the sap-ui-core.js script tag).
class Ui5Bootstrap {
  this(Ui5Variant variant = Ui5Variant.openui5) {
    _variant = variant;
  }

  /// The UI5 variant (OpenUI5 or SAPUI5)
  Ui5Variant variant() const {
    return _variant;
  }

  /// Uses OpenUI5 (fluent interface)
  auto openui5() {
    _variant = Ui5Variant.openui5;
    return this;
  }

  /// Uses SAPUI5 (fluent interface)
  auto sapui5() {
    _variant = Ui5Variant.sapui5;
    return this;
  }

  /// Pins a UI5 version, e.g. "1.120.0" (fluent interface)
  auto ui5Version(string value) {
    _version = value;
    return this;
  }

  /// Sets the theme (fluent interface)
  auto theme(Ui5Theme value) {
    _theme = value;
    return this;
  }

  /// Sets a custom theme name (fluent interface)
  auto theme(string value) {
    _customTheme = value;
    return this;
  }

  /// Sets the UI5 libraries to load, e.g. libs("sap.m", "sap.ui.layout") (fluent interface)
  auto libs(string[] values...) {
    _libs = values.dup;
    return this;
  }

  /// Sets the language, e.g. "de" (fluent interface)
  auto language(string value) {
    _language = value;
    return this;
  }

  /// Enables async boot (data-sap-ui-async="true", fluent interface)
  auto async(bool value = true) {
    _async = value;
    return this;
  }

  /// Enables compatibility mode (data-sap-ui-compatVersion="edge", fluent interface)
  auto compatEdge(bool value = true) {
    _compatEdge = value;
    return this;
  }

  /// Enables on-init module loading, e.g. onInit("my/app/index") (fluent interface)
  auto onInit(string modulePath) {
    _onInit = modulePath;
    return this;
  }

  /// Enables the frameOptions whitelist for clickjacking protection (fluent interface)
  auto frameOptionsTrusted(bool value = true) {
    _frameOptions = value ? "trusted" : "allow";
    return this;
  }

  /// Sets a custom resource root URL instead of the CDN (fluent interface)
  auto resourceRoot(string url) {
    _resourceRoot = url;
    return this;
  }

  /// The effective theme name
  string themeName() const {
    return _customTheme.length > 0 ? _customTheme : _theme.toString;
  }

  /// The effective resource root URL
  string resourceRootUrl() const {
    return _resourceRoot.length > 0 ? _resourceRoot : cdnResourceRoot(_variant, _version);
  }

  /// The effective bootstrap script URL
  string scriptUrl() const {
    return _resourceRoot.length > 0
      ? "%s/sap-ui-core.js".format(_resourceRoot)
      : cdnBootstrapScript(_variant, _version);
  }

  /// Renders the bootstrap script tag with data-sap-ui-* attributes
  override string toString() const {
    auto element = new HtmlElement("script")
      .id("sap-ui-bootstrap")
      .attr("src", scriptUrl)
      .attr("data-sap-ui-theme", themeName)
      .attr("data-sap-ui-libs", _libs.join(","))
      .attr("data-sap-ui-language", _language);
    if (_async) {
      element.attr("data-sap-ui-async", "true");
    }
    if (_compatEdge) {
      element.attr("data-sap-ui-compatVersion", "edge");
    }
    if (_onInit.length > 0) {
      element.attr("data-sap-ui-on-init", "module:" ~ _onInit);
    }
    if (_frameOptions.length > 0) {
      element.attr("data-sap-ui-frameOptions", _frameOptions);
    }
    return element.toString;
  }

  private Ui5Variant _variant;
  private string _version;
  private Ui5Theme _theme = Ui5Theme.sapHorizon;
  private string _customTheme;
  private string[] _libs = ["sap.m", "sap.ui.core"];
  private string _language = "en";
  private bool _async = true;
  private bool _compatEdge = true;
  private string _onInit;
  private string _frameOptions;
  private string _resourceRoot;
}

/// Creates a UI5 bootstrap configuration (OpenUI5 by default)
Ui5Bootstrap ui5Bootstrap(Ui5Variant variant = Ui5Variant.openui5) {
  return new Ui5Bootstrap(variant);
}

/// Renders a complete UI5 index.html page
string ui5IndexPage(string title, Ui5Bootstrap bootstrap, string bodyContent = null, string lang = "en") {
  auto doc = htmlDocument(title).lang(lang);
  doc.addHead(bootstrap.toString);
  if (bodyContent.length > 0) {
    doc.raw(bodyContent);
  }
  return doc.toString;
}

///
unittest {
  // variant URLs
  assert(cdnBase(Ui5Variant.openui5) == "https://sdk.openui5.org");
  assert(cdnBase(Ui5Variant.sapui5) == "https://sapui5.hana.ondemand.com");
  assert(cdnResourceRoot(Ui5Variant.openui5) == "https://sdk.openui5.org/resources");
  assert(cdnResourceRoot(Ui5Variant.sapui5, "1.120.0") == "https://sapui5.hana.ondemand.com/1.120.0/resources");
  assert(cdnBootstrapScript(Ui5Variant.openui5) == "https://sdk.openui5.org/resources/sap-ui-core.js");

  // themes
  assert(Ui5Theme.sapHorizon.toString == "sap_horizon");
  assert(Ui5Theme.sapFiori3Dark.toString == "sap_fiori_3_dark");
  assert(Ui5Theme.sapBelize.toString == "sap_belize");

  // default bootstrap
  auto boot = ui5Bootstrap();
  assert(boot.variant == Ui5Variant.openui5);
  assert(boot.themeName == "sap_horizon");
  assert(boot.scriptUrl == "https://sdk.openui5.org/resources/sap-ui-core.js");

  string tag = boot.toString;
  assert(tag.canFind(`id="sap-ui-bootstrap"`));
  assert(tag.canFind(`src="https://sdk.openui5.org/resources/sap-ui-core.js"`));
  assert(tag.canFind(`data-sap-ui-theme="sap_horizon"`));
  assert(tag.canFind(`data-sap-ui-libs="sap.m,sap.ui.core"`));
  assert(tag.canFind(`data-sap-ui-language="en"`));
  assert(tag.canFind(`data-sap-ui-async="true"`));
  assert(tag.canFind(`data-sap-ui-compatVersion="edge"`));

  // configured bootstrap
  auto sap = ui5Bootstrap(Ui5Variant.sapui5)
    .ui5Version("1.120.0")
    .theme(Ui5Theme.sapFiori3)
    .libs("sap.m", "sap.ui.layout", "sap.f")
    .language("de")
    .onInit("my/app/index")
    .frameOptionsTrusted;
  assert(sap.scriptUrl == "https://sapui5.hana.ondemand.com/1.120.0/resources/sap-ui-core.js");
  string sapTag = sap.toString;
  assert(sapTag.canFind(`data-sap-ui-theme="sap_fiori_3"`));
  assert(sapTag.canFind(`data-sap-ui-libs="sap.m,sap.ui.layout,sap.f"`));
  assert(sapTag.canFind(`data-sap-ui-language="de"`));
  assert(sapTag.canFind(`data-sap-ui-on-init="module:my/app/index"`));
  assert(sapTag.canFind(`data-sap-ui-frameOptions="trusted"`));

  // custom theme and resource root
  auto custom = ui5Bootstrap().theme("my_theme").resourceRoot("/ui5-resources").async(false).compatEdge(false);
  assert(custom.themeName == "my_theme");
  assert(custom.scriptUrl == "/ui5-resources/sap-ui-core.js");
  string customTag = custom.toString;
  assert(!customTag.canFind("data-sap-ui-async"));
  assert(!customTag.canFind("compatVersion"));

  // index page
  string page = ui5IndexPage("My UI5 App", ui5Bootstrap(), `<div id="content"></div>`, "de");
  assert(page.canFind(`<html lang="de">`));
  assert(page.canFind("<title>My UI5 App</title>"));
  assert(page.canFind(`id="sap-ui-bootstrap"`));
  assert(page.canFind(`<div id="content"></div>`));
}
