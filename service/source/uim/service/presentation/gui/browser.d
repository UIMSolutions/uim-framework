/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// GtkD (GTK 3) desktop driving adapter: a generic entity browser generated
/// from the ODataEngine's model. Every entity set gets a list page with
/// $filter / $search, create / edit forms built from the EDM types and
/// delete; singletons get a property sheet; actions get a runner page.
/// All calls go through the same engine as the OData endpoint and the CLI.
///
/// Only compiled when gtk-d is available (version Have_gtk_d).
module uim.service.presentation.gui.browser;

version (Have_gtk_d):

import uim.service;
import uim.service.ports.services.context;
import uim.service.ports.services.entitysets;
import uim.service.presentation.odata.model;
import uim.service.presentation.odata.query : ODataQueryException;
import uim.service.presentation.odata.engine;
import uim.service.presentation.odata.values;

import gtk.Main;
import gtk.MainWindow;
import gtk.HeaderBar;
import gtk.Box;
import gtk.Button;
import gtk.Entry;
import gtk.SearchEntry;
import gtk.Label;
import gtk.ScrolledWindow;
import gtk.TreeView;
import gtk.TreeViewColumn;
import gtk.TreePath;
import gtk.TreeIter;
import gtk.ListStore;
import gtk.CellRendererText;
import gtk.Statusbar;
import gtk.Dialog;
import gtk.MessageDialog;
import gtk.Grid;
import gtk.Widget;
import gtk.Window;
import gtk.CheckButton;
import GtkStack = gtk.Stack;
import gtk.StackSidebar;
import gtk.Separator;
import glib.Timeout;
import gobject.Value;
import gtkc.gobjecttypes : GType;
import gtk.c.types : GtkOrientation, GtkDialogFlags, GtkMessageType, GtkButtonsType, ResponseType,
  GtkPolicyType, GtkWindowPosition, GtkAlign;

mixin(ShowModule!());

@system:

/// Shared state of the browser: engine, caller context and feedback helpers.
class BrowserSession {
  ODataEngine engine;
  RequestContext context;
  Window window;
  Statusbar status;

  this(ODataEngine engine, RequestContext context) {
    this.engine = engine;
    this.context = context;
  }

  /// Run an action and report failures in a dialog. Returns false on failure.
  bool guarded(void delegate() action) {
    try {
      action();
      return true;
    } catch (EntitySetException e) {
      message(GtkMessageType.ERROR, e.msg ~ "\n\n(" ~ e.status.to!string ~ " " ~ e.code ~ ")");
    } catch (ODataQueryException e) {
      message(GtkMessageType.WARNING, "Invalid query: " ~ e.msg);
    } catch (Exception e) {
      message(GtkMessageType.ERROR, e.msg);
    }
    return false;
  }

  void message(GtkMessageType type, string text) {
    auto d = new MessageDialog(window, GtkDialogFlags.MODAL, type, GtkButtonsType.CLOSE, "%s", text);
    d.run();
    d.destroy();
  }

  bool confirm(string question) {
    auto d = new MessageDialog(window, GtkDialogFlags.MODAL, GtkMessageType.QUESTION, GtkButtonsType.YES_NO, "%s", question);
    auto answer = d.run();
    d.destroy();
    return answer == ResponseType.YES;
  }

  void info(string text) {
    if (status !is null)
      status.push(0, text);
  }

  /// Read-only property sheet of a JSON object.
  void showObject(string title, Json data, string delegate(string) labelOf = null) {
    auto d = new Dialog(title, window, GtkDialogFlags.MODAL, ["Close"], [ResponseType.CLOSE]);
    d.setDefaultSize(620, 480);
    auto grid = new Grid();
    grid.setRowSpacing(4);
    grid.setColumnSpacing(16);
    grid.setBorderWidth(12);
    int row;
    if (data.isObject) {
      foreach (k; data.get!(Json[string]).keys.sort) {
        auto name = new Label(labelOf is null ? k : labelOf(k));
        name.setXalign(1);
        name.setYalign(0);
        auto v = data[k];
        auto value = new Label(v.type == Json.Type.string ? v.get!string : (v.type == Json.Type.null_ ? "" : v.toPrettyString));
        value.setXalign(0);
        value.setSelectable(true);
        value.setLineWrap(true);
        grid.attach(name, 0, row, 1, 1);
        grid.attach(value, 1, row++, 1, 1);
      }
    } else {
      auto value = new Label(data.toPrettyString);
      value.setSelectable(true);
      grid.attach(value, 0, 0, 1, 1);
    }
    auto scroller = new ScrolledWindow();
    scroller.add(grid);
    d.getContentArea().packStart(scroller, true, true, 0);
    d.showAll();
    d.run();
    d.destroy();
  }

  /// Form generated from property definitions. Calls save(payload) on OK and
  /// keeps the dialog open while save throws. Returns true if saved.
  bool editForm(string title, const ODataPropertyDef[] props, Json current, bool creating, string key,
      void delegate(Json payload) save) {
    auto d = new Dialog(title, window, GtkDialogFlags.MODAL, ["Cancel", creating ? "Create" : "Save"],
      [ResponseType.CANCEL, ResponseType.OK]);
    d.setDefaultSize(520, -1);
    auto grid = new Grid();
    grid.setRowSpacing(6);
    grid.setColumnSpacing(12);
    grid.setBorderWidth(12);

    struct Field {
      ODataPropertyDef def;
      Entry entry;
      CheckButton check;
      string initial;
    }

    Field[] fields;
    int row;
    foreach (p; props) {
      if (p.computed || (!creating && (p.name == key || p.immutable_)))
        continue;
      auto text = (p.label.length ? p.label : p.name) ~ (!p.nullable ? " *" : "");
      auto label = new Label(text);
      label.setXalign(1);
      grid.attach(label, 0, row, 1, 1);

      Field f;
      f.def = p;
      auto value = current.isObject && p.name in current ? current[p.name] : Json(null);
      if (p.type == Edm.boolean && !p.collection) {
        f.check = new CheckButton();
        f.check.setActive(value.type == Json.Type.bool_ && value.get!bool);
        f.initial = f.check.getActive() ? "true" : "false";
        grid.attach(f.check, 1, row++, 1, 1);
      } else {
        f.initial = formatODataValue(p, value);
        f.entry = new Entry(f.initial);
        f.entry.setWidthChars(40);
        f.entry.setActivatesDefault(true);
        f.entry.setPlaceholderText(p.collection ? "comma separated" : (!p.isPrimitive ? "JSON object"
            : p.type == Edm.dateTimeOffset ? "2026-11-09T10:00:00Z" : p.type.replace("Edm.", "")));
        grid.attach(f.entry, 1, row++, 1, 1);
      }
      fields ~= f;
    }
    if (fields.length == 0) {
      auto none = new Label("Nothing to edit.");
      grid.attach(none, 0, 0, 2, 1);
    }

    d.getContentArea().packStart(grid, true, true, 0);
    d.setDefaultResponse(ResponseType.OK);
    d.showAll();

    bool saved;
    while (!saved && d.run() == ResponseType.OK) {
      saved = guarded(() {
        auto payload = Json.emptyObject;
        foreach (f; fields) {
          auto text = f.check !is null ? (f.check.getActive() ? "true" : "false") : f.entry.getText();
          if (!creating && text == f.initial)
            continue; // PATCH only what changed
          if (creating && text.strip.length == 0 && f.check is null)
            continue;
          payload[f.def.name] = text.strip.length == 0 && f.def.type == Edm.string_ && f.def.nullable && !creating
            ? Json(null) : parseODataValue(f.def, text);
        }
        save(payload);
      });
    }
    d.destroy();
    return saved;
  }
}

/// List page of an entity set.
class EntitySetPage : Box {
  protected BrowserSession session;
  protected ODataEntitySetDef set;
  protected string[] columns;
  protected TreeView view;
  protected ListStore store;
  protected SearchEntry search;
  protected Entry filter;
  protected Label countLabel;
  protected Button editButton, deleteButton;

  this(BrowserSession session, ODataEntitySetDef set) {
    super(GtkOrientation.VERTICAL, 6);
    this.session = session;
    this.set = set;
    setBorderWidth(6);
    columns = set.listColumns.filter!(c => c != set.key).array ~ set.key; // key is the last column

    auto toolbar = new Box(GtkOrientation.HORIZONTAL, 6);
    search = new SearchEntry();
    search.setPlaceholderText("Search");
    search.addOnActivate((Entry _) => reload());
    filter = new Entry();
    filter.setPlaceholderText("$filter, e.g. " ~ exampleFilter());
    filter.setWidthChars(36);
    filter.addOnActivate((Entry _) => reload());
    toolbar.packStart(search, false, false, 0);
    toolbar.packStart(filter, true, true, 0);
    toolbar.packStart(button("Apply", &reload), false, false, 0);

    if (set.insertable)
      toolbar.packStart(button("New…", &createEntity), false, false, 0);
    editButton = button(set.updatable ? "Edit…" : "Details", &openSelected);
    toolbar.packStart(editButton, false, false, 0);
    if (set.deletable) {
      deleteButton = button("Delete", &deleteSelected);
      toolbar.packStart(deleteButton, false, false, 0);
    }
    countLabel = new Label("");
    toolbar.packEnd(countLabel, false, false, 0);
    packStart(toolbar, false, false, 0);

    view = new TreeView();
    view.setEnableSearch(true);
    view.addOnRowActivated((TreePath p, TreeViewColumn c, TreeView v) => openSelected());
    buildColumns();
    auto scroller = new ScrolledWindow();
    scroller.setPolicy(GtkPolicyType.AUTOMATIC, GtkPolicyType.AUTOMATIC);
    scroller.add(view);
    packStart(scroller, true, true, 0);
  }

  protected string exampleFilter() {
    foreach (c; columns)
      if (set.propertyOf(c).type == Edm.string_ && c != set.key)
        return "contains(" ~ c ~ ",'x')";
    return set.key ~ " eq 'x'";
  }

  protected Button button(string label, void delegate() action) {
    auto b = new Button(label);
    b.addOnClicked((Button _) => action());
    return b;
  }

  protected void buildColumns() {
    GType[] types;
    foreach (_; columns)
      types ~= GType.STRING;
    store = new ListStore(types);
    view.setModel(store);
    foreach (i, name; columns) {
      if (name == set.key && i + 1 == columns.length && set.listColumns.length > 0 && !set.listColumns.canFind(set.key))
        continue; // hidden key column
      auto renderer = new CellRendererText();
      auto column = new TreeViewColumn(set.labelOf(name), renderer, "text", cast(int) i);
      column.setResizable(true);
      column.setSortColumnId(cast(int) i);
      column.setMaxWidth(420);
      view.appendColumn(column);
    }
  }

  void reload() {
    session.guarded(() {
      string[string] options;
      if (search.getText().strip.length)
        options["$search"] = search.getText().strip;
      if (filter.getText().strip.length)
        options["$filter"] = filter.getText().strip;
      auto page = session.engine.query(session.context, set.name, options);
      store.clear();
      foreach (row; page.rows) {
        TreeIter iter;
        store.append(iter);
        foreach (i, name; columns) {
          auto v = row.isObject && name in row ? row[name] : Json(null);
          store.setValue(iter, cast(int) i, new Value(formatODataValue(set.propertyOf(name), v)));
        }
      }
      countLabel.setText(format("%d %s", page.total, set.displayName));
    });
  }

  /// Key of the selected row, or "".
  string selectedKey() {
    auto iter = view.getSelectedIter();
    return iter is null ? "" : iter.getValueString(cast(int) columns.length - 1);
  }

  protected void createEntity() {
    if (session.editForm("New " ~ (set.typeName.length ? set.typeName : set.entityType), set.properties, Json.emptyObject,
        true, set.key, (Json payload) { session.engine.create(session.context, set.name, payload); })) {
      session.info("Created " ~ set.entityType);
      reload();
    }
  }

  protected void openSelected() {
    auto key = selectedKey();
    if (key.length == 0)
      return session.message(GtkMessageType.INFO, "Select a row first.");
    Json current;
    if (!session.guarded(() { current = session.engine.read(session.context, set.name, key); }))
      return;
    if (!set.updatable)
      return session.showObject(set.entityType ~ " " ~ key, current, (string n) => set.labelOf(n));
    if (session.editForm("Edit " ~ set.entityType ~ " " ~ key, set.properties, current, false, set.key, (Json payload) {
        session.engine.update(session.context, set.name, key, payload);
      })) {
      session.info("Saved " ~ set.entityType ~ " " ~ key);
      reload();
    }
  }

  protected void deleteSelected() {
    auto key = selectedKey();
    if (key.length == 0)
      return session.message(GtkMessageType.INFO, "Select a row first.");
    if (!session.confirm("Delete " ~ set.entityType ~ " '" ~ key ~ "'?"))
      return;
    if (session.guarded(() { session.engine.remove(session.context, set.name, key); })) {
      session.info("Deleted " ~ set.entityType ~ " " ~ key);
      reload();
    }
  }
}

/// Property sheet of a singleton.
class SingletonPage : Box {
  protected BrowserSession session;
  protected ODataEntitySetDef set;
  protected Grid grid;
  protected Json current;

  this(BrowserSession session, ODataEntitySetDef set) {
    super(GtkOrientation.VERTICAL, 6);
    this.session = session;
    this.set = set;
    setBorderWidth(12);
    auto toolbar = new Box(GtkOrientation.HORIZONTAL, 6);
    auto refresh = new Button("Refresh");
    refresh.addOnClicked((Button _) => reload());
    toolbar.packStart(refresh, false, false, 0);
    if (set.updatable) {
      auto edit = new Button("Edit…");
      edit.addOnClicked((Button _) => editSingleton());
      toolbar.packStart(edit, false, false, 0);
    }
    packStart(toolbar, false, false, 0);
    grid = new Grid();
    grid.setRowSpacing(6);
    grid.setColumnSpacing(24);
    auto scroller = new ScrolledWindow();
    scroller.add(grid);
    packStart(scroller, true, true, 0);
  }

  void reload() {
    session.guarded(() {
      current = session.engine.read(session.context, set.name, "");
      if (auto children = grid.getChildren()) // null while the grid is empty
        foreach (child; children.toArray!Widget)
          grid.remove(child);
      int row;
      foreach (p; set.properties) {
        auto name = new Label(set.labelOf(p.name));
        name.setXalign(1);
        auto value = new Label(formatODataValue(p, p.name in current ? current[p.name] : Json(null)));
        value.setXalign(0);
        value.setSelectable(true);
        grid.attach(name, 0, row, 1, 1);
        grid.attach(value, 1, row++, 1, 1);
      }
      grid.showAll();
    });
  }

  protected void editSingleton() {
    if (session.editForm("Edit " ~ set.displayName, set.properties, current, false, set.key, (Json payload) {
        session.engine.update(session.context, set.name, "", payload);
      }))
      reload();
  }
}

/// Runner for the unbound actions of the model.
class ActionsPage : Box {
  protected BrowserSession session;

  this(BrowserSession session) {
    super(GtkOrientation.VERTICAL, 6);
    this.session = session;
    setBorderWidth(12);
    auto grid = new Grid();
    grid.setRowSpacing(8);
    grid.setColumnSpacing(16);
    int row;
    foreach (action; session.engine.model.actions) {
      auto title = new Label(action.label.length ? action.label ~ " (" ~ action.name ~ ")" : action.name);
      title.setXalign(0);
      auto params = new Label(action.parameters.length ? action.parameters.map!(p => p.name ~ ": " ~ p.type.replace("Edm.",
          "")).join(", ") : "no parameters");
      params.setXalign(0);
      auto run = new Button("Run…");
      auto a = action;
      run.addOnClicked((Button _) => invoke(a));
      grid.attach(title, 0, row, 1, 1);
      grid.attach(params, 1, row, 1, 1);
      grid.attach(run, 2, row++, 1, 1);
    }
    packStart(grid, false, false, 0);
  }

  protected void invoke(ODataActionDef action) {
    Json result;
    bool done;
    if (action.parameters.length == 0) {
      if (!session.confirm("Run " ~ action.name ~ "?"))
        return;
      done = session.guarded(() { result = session.engine.invoke(session.context, action.name, Json.emptyObject); });
    } else {
      done = session.editForm(action.name, action.parameters, Json.emptyObject, true, "", (Json payload) {
        result = session.engine.invoke(session.context, action.name, payload);
      });
    }
    if (!done)
      return;
    session.info(action.name ~ " completed");
    if (result.type != Json.Type.null_ && result.type != Json.Type.undefined)
      session.showObject(action.name ~ " — result", result);
  }
}

/// Main window.
class EntityBrowserWindow : MainWindow {
  protected BrowserSession session;
  protected HeaderBar header;
  protected Entry tenantEntry;
  protected EntitySetPage[] listPages;
  protected SingletonPage[] singletonPages;
  protected Timeout autoRefresh;

  this(ODataEngine engine, RequestContext context, uint autoRefreshSeconds = 0) {
    super(engine.model.title);
    session = new BrowserSession(engine, context);
    session.window = this;
    setDefaultSize(1280, 760);
    setPosition(GtkWindowPosition.CENTER);

    header = new HeaderBar();
    header.setShowCloseButton(true);
    header.setTitle(engine.model.title);
    setTitlebar(header);
    tenantEntry = new Entry(context.tenantId);
    tenantEntry.setPlaceholderText("tenant");
    tenantEntry.setWidthChars(16);
    tenantEntry.addOnActivate((Entry e) {
      session.context.tenantId = e.getText().strip;
      refreshAll();
    });
    header.packStart(new Label("Tenant"));
    header.packStart(tenantEntry);
    auto refresh = new Button("Refresh");
    refresh.addOnClicked((Button _) => refreshAll());
    header.packEnd(refresh);

    auto stack = new GtkStack.Stack();
    foreach (set; engine.model.entitySets) {
      if (set.singleton) {
        auto page = new SingletonPage(session, set);
        singletonPages ~= page;
        stack.addTitled(page, set.name, set.displayName);
      } else {
        auto page = new EntitySetPage(session, set);
        listPages ~= page;
        stack.addTitled(page, set.name, set.displayName);
      }
    }
    if (engine.model.actions.length > 0)
      stack.addTitled(new ActionsPage(session), "$actions", "Actions");

    auto sidebar = new StackSidebar();
    sidebar.setStack(stack);
    sidebar.setSizeRequest(220, -1);

    auto content = new Box(GtkOrientation.HORIZONTAL, 0);
    content.packStart(sidebar, false, false, 0);
    content.packStart(new Separator(GtkOrientation.VERTICAL), false, false, 0);
    content.packStart(stack, true, true, 0);

    session.status = new Statusbar();
    auto root = new Box(GtkOrientation.VERTICAL, 0);
    root.packStart(content, true, true, 0);
    root.packStart(session.status, false, false, 0);
    add(root);

    refreshAll();
    if (autoRefreshSeconds > 0) // picks up changes made by the server or the CLI
      autoRefresh = new Timeout(autoRefreshSeconds * 1000, () { refreshAll(); return true; });
    addOnDestroy((Widget _) {
      if (autoRefresh !is null)
        autoRefresh.stop();
      Main.quit();
    });
  }

  void refreshAll() {
    foreach (p; listPages)
      p.reload();
    foreach (p; singletonPages)
      p.reload();
    header.setSubtitle("tenant " ~ session.context.tenantId);
    session.info(format("Tenant '%s' refreshed at %s", session.context.tenantId, Clock.currTime.toSimpleString));
  }
}

/// Start GTK, show the browser and run the main loop. Returns the exit code.
int runEntityBrowser(ODataEngine engine, string tenant, string user, string[] gtkArgs, uint autoRefreshSeconds = 0) {
  Main.init(gtkArgs);
  auto window = new EntityBrowserWindow(engine, RequestContext.local(tenant, "gui", user), autoRefreshSeconds);
  window.showAll();
  Main.run();
  return 0;
}
