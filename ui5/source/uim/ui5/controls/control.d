module uim.ui5.controls.control;

import uim.ui5;

mixin(ShowModule!());

@safe:

/// A UI5 control rendered as an XML view element, e.g. `<Button text="Save" press=".onSave"/>`.
class Ui5Control {
  this(string name, string namespace = "sap.m") {
    _name = name;
    _namespace = namespace;
  }

  /// The control name, e.g. "Button"
  string name() const {
    return _name;
  }

  /// The control namespace, e.g. "sap.m"
  string namespace() const {
    return _namespace;
  }

  /// Sets a property/attribute (fluent interface), e.g. prop("text", "Save")
  auto prop(string name, string value) {
    if (!_order.canFind(name)) {
      _order ~= name;
    }
    _properties[name] = value;
    return this;
  }

  /// Sets a boolean property (fluent interface)
  auto prop(string name, bool value) {
    return prop(name, value ? "true" : "false");
  }

  /// Sets a numeric property (fluent interface)
  auto prop(string name, int value) {
    return prop(name, value.to!string);
  }

  /// Sets an event handler attribute, e.g. event("press", ".onSave") (fluent interface)
  auto event(string name, string handler) {
    return prop(name, handler);
  }

  /// Sets the control id (fluent interface)
  auto id(string value) {
    return prop("id", value);
  }

  /// Sets a binding path as property value, e.g. binding("text", "/name") -> text="{/name}" (fluent interface)
  auto binding(string name, string path) {
    return prop(name, "{" ~ path ~ "}");
  }

  /// Sets an i18n binding, e.g. i18n("text", "saveButton") -> text="{i18n>saveButton}" (fluent interface)
  auto i18n(string name, string key) {
    return prop(name, "{i18n>" ~ key ~ "}");
  }

  /// Adds a child control to the default aggregation (fluent interface)
  auto add(Ui5Control child) {
    _children ~= child;
    return this;
  }

  /// Adds a child control to a named aggregation, e.g. aggregation("items", ...) (fluent interface)
  auto aggregation(string name, Ui5Control child) {
    _aggregations[name] ~= child;
    if (!_aggregationOrder.canFind(name)) {
      _aggregationOrder ~= name;
    }
    return this;
  }

  /// Checks whether a property is set
  bool hasProp(string name) const {
    return (name in _properties) !is null;
  }

  /// Returns the value of a property
  string getProp(string name) const {
    auto found = name in _properties;
    return found is null ? null : *found;
  }

  /// All property names in insertion order
  string[] propNames() const {
    return _order.dup;
  }

  /// All child controls of the default aggregation
  Ui5Control[] children() {
    return _children.dup;
  }

  /// Renders the control as an XML element
  override string toString() const {
    auto result = appender!string;
    result.put("<" ~ _name);
    foreach (property; _order) {
      result.put(" %s=\"%s\"".format(property, escapeHtmlAttribute(_properties[property])));
    }

    bool hasContent = _children.length > 0 || _aggregationOrder.length > 0;
    if (!hasContent) {
      result.put("/>");
      return result.data;
    }

    result.put(">");
    foreach (child; _children) {
      result.put(child.toString);
    }
    foreach (aggregationName; _aggregationOrder) {
      result.put("<" ~ aggregationName ~ ">");
      foreach (child; _aggregations[aggregationName]) {
        result.put(child.toString);
      }
      result.put("</" ~ aggregationName ~ ">");
    }
    result.put("</" ~ _name ~ ">");
    return result.data;
  }

  private string _name;
  private string _namespace;
  private string[string] _properties;
  private string[] _order;
  private Ui5Control[] _children;
  private Ui5Control[][string] _aggregations;
  private string[] _aggregationOrder;
}

/// Creates a UI5 control, e.g. ui5Control("Button")
Ui5Control ui5Control(string name, string namespace = "sap.m") {
  return new Ui5Control(name, namespace);
}

// #region sap.m controls
/// sap.m.Button, e.g. ui5Button("Save", ".onSave")
Ui5Control ui5Button(string text = null, string press = null) {
  auto control = new Ui5Control("Button");
  if (text.length > 0) {
    control.prop("text", text);
  }
  if (press.length > 0) {
    control.event("press", press);
  }
  return control;
}

/// sap.m.Input
Ui5Control ui5Input(string placeholder = null, string value = null) {
  auto control = new Ui5Control("Input");
  if (placeholder.length > 0) {
    control.prop("placeholder", placeholder);
  }
  if (value.length > 0) {
    control.prop("value", value);
  }
  return control;
}

/// sap.m.Label, e.g. ui5Label("Name", "inputName")
Ui5Control ui5Label(string text, string labelFor = null) {
  auto control = new Ui5Control("Label").prop("text", text);
  if (labelFor.length > 0) {
    control.prop("labelFor", labelFor);
  }
  return control;
}

/// sap.m.Text
Ui5Control ui5Text(string text) {
  return new Ui5Control("Text").prop("text", text);
}

/// sap.m.Title
Ui5Control ui5Title(string text) {
  return new Ui5Control("Title").prop("text", text);
}

/// sap.m.Link
Ui5Control ui5Link(string text, string href = null) {
  auto control = new Ui5Control("Link").prop("text", text);
  if (href.length > 0) {
    control.prop("href", href);
  }
  return control;
}

/// sap.m.CheckBox
Ui5Control ui5CheckBox(string text = null, bool selected = false) {
  auto control = new Ui5Control("CheckBox");
  if (text.length > 0) {
    control.prop("text", text);
  }
  if (selected) {
    control.prop("selected", true);
  }
  return control;
}

/// sap.m.Switch
Ui5Control ui5Switch(bool state = false) {
  return new Ui5Control("Switch").prop("state", state);
}

/// sap.m.SearchField
Ui5Control ui5SearchField(string placeholder = null, string search = null) {
  auto control = new Ui5Control("SearchField");
  if (placeholder.length > 0) {
    control.prop("placeholder", placeholder);
  }
  if (search.length > 0) {
    control.event("search", search);
  }
  return control;
}

/// sap.m.MessageToast is not a control; renders the JS call instead
string ui5MessageToast(string message) {
  return jsMethodCall("sap.m.MessageToast", "show", jsString(message));
}
// #endregion sap.m controls

// #region sap.m containers
/// sap.m.Page with optional title
Ui5Control ui5Page(string title = null) {
  auto control = new Ui5Control("Page");
  if (title.length > 0) {
    control.prop("title", title);
  }
  return control;
}

/// sap.m.App (root container)
Ui5Control ui5AppContainer() {
  return new Ui5Control("App");
}

/// sap.m.Shell
Ui5Control ui5Shell() {
  return new Ui5Control("Shell");
}

/// sap.m.VBox (vertical layout)
Ui5Control ui5VBox() {
  return new Ui5Control("VBox", "sap.m");
}

/// sap.m.HBox (horizontal layout)
Ui5Control ui5HBox() {
  return new Ui5Control("HBox", "sap.m");
}

/// sap.m.Panel
Ui5Control ui5Panel(string headerText = null) {
  auto control = new Ui5Control("Panel");
  if (headerText.length > 0) {
    control.prop("headerText", headerText);
  }
  return control;
}

/// sap.m.Dialog
Ui5Control ui5Dialog(string title = null) {
  auto control = new Ui5Control("Dialog");
  if (title.length > 0) {
    control.prop("title", title);
  }
  return control;
}

/// sap.m.Bar
Ui5Control ui5Bar() {
  return new Ui5Control("Bar");
}
// #endregion sap.m containers

// #region sap.m lists and tables
/// sap.m.List
Ui5Control ui5List(string headerText = null) {
  auto control = new Ui5Control("List");
  if (headerText.length > 0) {
    control.prop("headerText", headerText);
  }
  return control;
}

/// sap.m.StandardListItem
Ui5Control ui5StandardListItem(string title, string press = null) {
  auto control = new Ui5Control("StandardListItem").prop("title", title);
  if (press.length > 0) {
    control.event("press", press);
  }
  return control;
}

/// sap.m.Table with bound items, e.g. ui5Table("/items")
Ui5Control ui5Table(string itemsBinding = null) {
  auto control = new Ui5Control("Table");
  if (itemsBinding.length > 0) {
    control.binding("items", itemsBinding);
  }
  return control;
}

/// sap.m.Column
Ui5Control ui5Column(string header = null) {
  auto control = new Ui5Control("Column");
  if (header.length > 0) {
    control.aggregation("header", ui5Text(header));
  }
  return control;
}

/// sap.m.ColumnListItem
Ui5Control ui5ColumnListItem() {
  return new Ui5Control("ColumnListItem");
}
// #endregion sap.m lists and tables

///
unittest {
  // basic control
  auto button = new Ui5Control("Button");
  assert(button.name == "Button");
  assert(button.namespace == "sap.m");
  assert(button.toString == "<Button/>");

  // properties
  button.prop("text", "Save").prop("enabled", true).prop("width", 100);
  assert(button.hasProp("text"));
  assert(!button.hasProp("icon"));
  assert(button.getProp("text") == "Save");
  assert(button.getProp("enabled") == "true");
  assert(button.getProp("width") == "100");
  assert(button.propNames == ["text", "enabled", "width"]);
  assert(button.toString == `<Button text="Save" enabled="true" width="100"/>`);

  // events, ids, bindings
  auto save = ui5Button("Save", ".onSave").id("saveButton");
  assert(save.toString == `<Button text="Save" press=".onSave" id="saveButton"/>`);

  auto bound = ui5Input().binding("value", "/user/name");
  assert(bound.toString == `<Input value="{/user/name}"/>`);

  auto translated = ui5Button().i18n("text", "saveButton");
  assert(translated.toString == `<Button text="{i18n&gt;saveButton}"/>`); // '>' is escaped in XML attributes

  // escaping
  assert(ui5Text(`a "b"`).toString == `<Text text="a &quot;b&quot;"/>`);

  // nesting
  auto page = ui5Page("Home")
    .add(ui5Text("Hello"))
    .add(ui5Button("Go", ".onGo"));
  assert(page.children.length == 2);
  assert(page.toString == `<Page title="Home"><Text text="Hello"/><Button text="Go" press=".onGo"/></Page>`);

  // named aggregations
  auto table = ui5Table("/items")
    .aggregation("columns", ui5Column("Name"))
    .aggregation("columns", ui5Column("Price"));
  assert(table.toString == `<Table items="{/items}"><columns><Column><header><Text text="Name"/></header></Column><Column><header><Text text="Price"/></header></Column></columns></Table>`);

  // control factories
  assert(ui5Input("Name", "oz").toString == `<Input placeholder="Name" value="oz"/>`);
  assert(ui5Label("Name", "inputName").toString == `<Label text="Name" labelFor="inputName"/>`);
  assert(ui5Title("T").toString == `<Title text="T"/>`);
  assert(ui5Link("Home", "/home").toString == `<Link text="Home" href="/home"/>`);
  assert(ui5CheckBox("Agree", true).toString == `<CheckBox text="Agree" selected="true"/>`);
  assert(ui5CheckBox().toString == `<CheckBox/>`);
  assert(ui5Switch(true).toString == `<Switch state="true"/>`);
  assert(ui5SearchField("Search", ".onSearch").toString == `<SearchField placeholder="Search" search=".onSearch"/>`);
  assert(ui5MessageToast("Saved") == `sap.m.MessageToast.show('Saved');`);

  // containers
  assert(ui5Page().toString == "<Page/>");
  assert(ui5AppContainer().toString == "<App/>");
  assert(ui5Shell().toString == "<Shell/>");
  assert(ui5VBox().toString == "<VBox/>");
  assert(ui5HBox().toString == "<HBox/>");
  assert(ui5Panel("Header").toString == `<Panel headerText="Header"/>`);
  assert(ui5Dialog("Confirm").toString == `<Dialog title="Confirm"/>`);
  assert(ui5Bar().toString == "<Bar/>");

  // lists and tables
  assert(ui5List("Items").toString == `<List headerText="Items"/>`);
  assert(ui5StandardListItem("Item 1", ".onItem").toString == `<StandardListItem title="Item 1" press=".onItem"/>`);
  assert(ui5Table().toString == "<Table/>");
  assert(ui5Column().toString == "<Column/>");
  assert(ui5ColumnListItem().toString == "<ColumnListItem/>");

  // custom namespace
  assert(ui5Control("SmartTable", "sap.ui.comp.smarttable").namespace == "sap.ui.comp.smarttable");
}
