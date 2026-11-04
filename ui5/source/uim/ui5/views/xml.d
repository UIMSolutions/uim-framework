/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.views.xml;

import uim.ui5;

mixin(ShowModule!());

@safe:

/// A UI5 XML view (mvc:View) with namespaces, controller reference and content controls.
class Ui5XmlView : Ui5View {
  this(string controllerName = null) {
    super();
    _controllerName = controllerName;
  }

  override bool initialize(Json config = Json(null)) {
    if (!super.initialize(config)) {
      return false;
    }

    return true;
  }

  /// Sets the controller name, e.g. "my.app.controller.Main" (fluent interface)
  auto controllerName(string value) {
    _controllerName = value;
    return this;
  }

  /// Registers an additional namespace, e.g. namespace("f", "sap.f") (fluent interface)
  auto namespace(string prefix, string uri) {
    _namespaces[prefix] = uri;
    if (!_namespaceOrder.canFind(prefix)) {
      _namespaceOrder ~= prefix;
    }
    return this;
  }

  /// Enables displayBlock mode (fluent interface)
  auto displayBlock(bool value = true) {
    _displayBlock = value;
    return this;
  }

  /// Sets the height of the view (fluent interface)
  auto height(string value) {
    _height = value;
    return this;
  }

  /// Adds a content control (fluent interface)
  auto add(Ui5Control control) {
    _content ~= control;
    return this;
  }

  /// All content controls
  Ui5Control[] content() {
    return _content.dup;
  }

  /// The registered additional namespaces
  string[string] namespaces() const {
    return _namespaces.dup;
  }

  /// Renders the XML view
  override string toString() const {
    auto result = appender!string;
    result.put(`<mvc:View`);
    if (_controllerName.length > 0) {
      result.put(` controllerName="` ~ escapeHtmlAttribute(_controllerName) ~ `"`);
    }
    result.put(` xmlns:mvc="sap.ui.core.mvc" xmlns="sap.m"`);
    foreach (prefix; _namespaceOrder) {
      result.put(` xmlns:` ~ prefix ~ `="` ~ escapeHtmlAttribute(_namespaces[prefix]) ~ `"`);
    }
    if (_displayBlock) {
      result.put(` displayBlock="true"`);
    }
    if (_height.length > 0) {
      result.put(` height="` ~ escapeHtmlAttribute(_height) ~ `"`);
    }
    result.put(">");
    foreach (control; _content) {
      result.put(control.toString);
    }
    result.put("</mvc:View>");
    return result.data;
  }

  private string _controllerName;
  private string[string] _namespaces;
  private string[] _namespaceOrder;
  private bool _displayBlock;
  private string _height;
  private Ui5Control[] _content;
}

/// Creates a UI5 XML view
Ui5XmlView ui5XmlView(string controllerName = null) {
  return new Ui5XmlView(controllerName);
}

/// A UI5 XML fragment (reusable view part without controller).
class Ui5XmlFragment {
  /// Registers an additional namespace (fluent interface)
  auto namespace(string prefix, string uri) {
    _namespaces[prefix] = uri;
    if (!_namespaceOrder.canFind(prefix)) {
      _namespaceOrder ~= prefix;
    }
    return this;
  }

  /// Adds a content control (fluent interface)
  auto add(Ui5Control control) {
    _content ~= control;
    return this;
  }

  /// All content controls
  Ui5Control[] content() {
    return _content.dup;
  }

  /// Renders the XML fragment
  override string toString() const {
    auto result = appender!string;
    result.put(`<FragmentDefinition xmlns="sap.m" xmlns:core="sap.ui.core"`);
    foreach (prefix; _namespaceOrder) {
      result.put(` xmlns:` ~ prefix ~ `="` ~ escapeHtmlAttribute(_namespaces[prefix]) ~ `"`);
    }
    result.put(">");
    foreach (control; _content) {
      result.put(control.toString);
    }
    result.put("</FragmentDefinition>");
    return result.data;
  }

  private string[string] _namespaces;
  private string[] _namespaceOrder;
  private Ui5Control[] _content;
}

/// Creates a UI5 XML fragment
Ui5XmlFragment ui5XmlFragment() {
  return new Ui5XmlFragment;
}

///
unittest {
  // minimal view
  auto view = new Ui5XmlView;
  assert(view.toString == `<mvc:View xmlns:mvc="sap.ui.core.mvc" xmlns="sap.m"></mvc:View>`);

  // full view
  auto main = ui5XmlView("my.app.controller.Main")
    .namespace("f", "sap.f")
    .namespace("layout", "sap.ui.layout")
    .displayBlock
    .height("100%")
    .add(ui5Page("Home").add(ui5Text("Hello UI5")));

  assert(main.content.length == 1);
  assert(main.namespaces.length == 2);

  string rendered = main.toString;
  assert(rendered.canFind(`<mvc:View controllerName="my.app.controller.Main"`));
  assert(rendered.canFind(`xmlns:mvc="sap.ui.core.mvc"`));
  assert(rendered.canFind(`xmlns="sap.m"`));
  assert(rendered.canFind(`xmlns:f="sap.f"`));
  assert(rendered.canFind(`xmlns:layout="sap.ui.layout"`));
  assert(rendered.canFind(`displayBlock="true"`));
  assert(rendered.canFind(`height="100%"`));
  assert(rendered.canFind(`<Page title="Home"><Text text="Hello UI5"/></Page>`));
  assert(rendered.endsWith("</mvc:View>"));

  // fragment
  auto fragment = ui5XmlFragment()
    .namespace("form", "sap.ui.layout.form")
    .add(ui5Input("Name"))
    .add(ui5Button("OK", ".onOk"));

  assert(fragment.content.length == 2);
  string fragmentXml = fragment.toString;
  assert(fragmentXml.canFind(`<FragmentDefinition xmlns="sap.m" xmlns:core="sap.ui.core"`));
  assert(fragmentXml.canFind(`xmlns:form="sap.ui.layout.form"`));
  assert(fragmentXml.canFind(`<Input placeholder="Name"/>`));
  assert(fragmentXml.canFind(`<Button text="OK" press=".onOk"/>`));
  assert(fragmentXml.endsWith("</FragmentDefinition>"));

  // controller name is escaped
  assert(ui5XmlView(`a"b`).toString.canFind(`controllerName="a&quot;b"`));
}
