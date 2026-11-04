/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.pwa.registration;

import uim.web;

mixin(ShowModule!());

@safe:

/// JavaScript registering a service worker, e.g. registerServiceWorker("/sw.js")
string registerServiceWorker(string scriptUrl = "/sw.js", string scopeUrl = "/") {
  return "if ('serviceWorker' in navigator) {\n"
    ~ "  window.addEventListener('load', () => {\n"
    ~ "    navigator.serviceWorker.register(%s, { scope: %s })\n".format(jsString(scriptUrl), jsString(scopeUrl))
    ~ "      .then((registration) => console.log('Service worker registered:', registration.scope))\n"
    ~ "      .catch((error) => console.error('Service worker registration failed:', error));\n"
    ~ "  });\n"
    ~ "}";
}

/// JavaScript registering a service worker with an update handler calling `onUpdate(registration)`
string registerServiceWorkerWithUpdate(string scriptUrl = "/sw.js", string onUpdateBody = null) {
  string updateHandler = onUpdateBody.length > 0
    ? onUpdateBody
    : "console.log('New service worker available');";
  return "if ('serviceWorker' in navigator) {\n"
    ~ "  window.addEventListener('load', () => {\n"
    ~ "    navigator.serviceWorker.register(%s).then((registration) => {\n".format(jsString(scriptUrl))
    ~ "      registration.addEventListener('updatefound', () => {\n"
    ~ "        const worker = registration.installing;\n"
    ~ "        worker.addEventListener('statechange', () => {\n"
    ~ "          if (worker.state == 'installed' && navigator.serviceWorker.controller) {\n"
    ~ "            %s\n".format(updateHandler)
    ~ "          }\n"
    ~ "        });\n"
    ~ "      });\n"
    ~ "    });\n"
    ~ "  });\n"
    ~ "}";
}

/// JavaScript unregistering all service workers of the current scope
string unregisterServiceWorker() {
  return "if ('serviceWorker' in navigator) {\n"
    ~ "  navigator.serviceWorker.getRegistrations().then((registrations) => {\n"
    ~ "    registrations.forEach((registration) => registration.unregister());\n"
    ~ "  });\n"
    ~ "}";
}

/// JavaScript capturing the beforeinstallprompt event for a custom install button.
/// The deferred prompt is stored on `window.pwaInstallPrompt`.
string captureInstallPrompt() {
  return "window.addEventListener('beforeinstallprompt', (event) => {\n"
    ~ "  event.preventDefault();\n"
    ~ "  window.pwaInstallPrompt = event;\n"
    ~ "  document.querySelectorAll('[data-pwa-install]').forEach((button) => button.hidden = false);\n"
    ~ "});";
}

/// JavaScript triggering a previously captured install prompt
string showInstallPrompt() {
  return "if (window.pwaInstallPrompt) {\n"
    ~ "  window.pwaInstallPrompt.prompt();\n"
    ~ "  window.pwaInstallPrompt.userChoice.then(() => window.pwaInstallPrompt = null);\n"
    ~ "}";
}

/// JavaScript checking whether the app runs installed (standalone display mode)
string isInstalledCheck() {
  return "const pwaInstalled = window.matchMedia('(display-mode: standalone)').matches"
    ~ " || window.navigator.standalone == true;";
}

/// JavaScript tracking online/offline status changes, calling `onOnline()`/`onOffline()`
string onlineStatusHandlers(string onOnlineBody = null, string onOfflineBody = null) {
  string online = onOnlineBody.length > 0 ? onOnlineBody : "console.log('online');";
  string offline = onOfflineBody.length > 0 ? onOfflineBody : "console.log('offline');";
  return "window.addEventListener('online', () => { %s });\n".format(online)
    ~ "window.addEventListener('offline', () => { %s });".format(offline);
}

/// JavaScript subscribing to push notifications, e.g. pushSubscribe("base64Key")
string pushSubscribe(string applicationServerKey) {
  return "navigator.serviceWorker.ready.then((registration) => {\n"
    ~ "  return registration.pushManager.subscribe({\n"
    ~ "    userVisibleOnly: true,\n"
    ~ "    applicationServerKey: %s\n".format(jsString(applicationServerKey))
    ~ "  });\n"
    ~ "}).then((subscription) => console.log('Push subscription:', JSON.stringify(subscription)));";
}

/// JavaScript requesting the notification permission
string requestNotificationPermission() {
  return "Notification.requestPermission().then((permission) => {\n"
    ~ "  console.log('Notification permission:', permission);\n"
    ~ "});";
}

/// A builder collecting all PWA-related head entries and scripts for a page.
class PwaSetup {
  this(PwaManifest manifest) {
    _manifest = manifest;
  }

  /// The manifest of the setup
  PwaManifest manifest() {
    return _manifest;
  }

  /// Sets the service worker script URL (fluent interface)
  auto serviceWorker(string scriptUrl, string scopeUrl = "/") {
    _swUrl = scriptUrl;
    _swScope = scopeUrl;
    return this;
  }

  /// Sets the manifest link href (fluent interface)
  auto manifestHref(string href) {
    _manifestHref = href;
    return this;
  }

  /// Enables the install prompt capture script (fluent interface)
  auto withInstallPrompt(bool value = true) {
    _installPrompt = value;
    return this;
  }

  /// Enables online/offline status handlers (fluent interface)
  auto withOnlineStatus(string onOnlineBody = null, string onOfflineBody = null) {
    _onlineBody = onOnlineBody;
    _offlineBody = onOfflineBody;
    _onlineStatus = true;
    return this;
  }

  /// Renders the head entries: manifest link, theme color, apple touch icons
  string[] headEntries() const {
    string[] entries = [_manifest.toHtml(_manifestHref)];
    string themeMeta = _manifest.themeColorMeta;
    if (themeMeta.length > 0) {
      entries ~= themeMeta;
    }
    entries ~= _manifest.appleTouchIcons;
    return entries;
  }

  /// Renders the body-end scripts: service worker registration and optional extras
  string[] scripts() const {
    string[] result;
    if (_swUrl.length > 0) {
      result ~= scriptTag(registerServiceWorker(_swUrl, _swScope));
    }
    if (_installPrompt) {
      result ~= scriptTag(captureInstallPrompt);
    }
    if (_onlineStatus) {
      result ~= scriptTag(onlineStatusHandlers(_onlineBody, _offlineBody));
    }
    return result;
  }

  /// Applies the setup to an HTML document (fluent interface)
  auto applyTo(HtmlDocument document) {
    foreach (entry; headEntries) {
      document.addHead(entry);
    }
    foreach (script; scripts) {
      document.raw(script);
    }
    return document;
  }

  private PwaManifest _manifest;
  private string _manifestHref = "/manifest.json";
  private string _swUrl;
  private string _swScope = "/";
  private bool _installPrompt;
  private bool _onlineStatus;
  private string _onlineBody;
  private string _offlineBody;
}

/// Creates a PWA setup for a manifest
PwaSetup pwaSetup(PwaManifest manifest) {
  return new PwaSetup(manifest);
}

///
unittest {
  // registration scripts
  string registration = registerServiceWorker();
  assert(registration.canFind("'serviceWorker' in navigator"));
  assert(registration.canFind("navigator.serviceWorker.register('/sw.js', { scope: '/' })"));

  assert(registerServiceWorker("/app/sw.js", "/app/").canFind("'/app/sw.js'"));

  string withUpdate = registerServiceWorkerWithUpdate("/sw.js", "showUpdateBar();");
  assert(withUpdate.canFind("updatefound"));
  assert(withUpdate.canFind("showUpdateBar();"));
  assert(registerServiceWorkerWithUpdate().canFind("New service worker available"));

  string unregister = unregisterServiceWorker();
  assert(unregister.canFind("getRegistrations()"));
  assert(unregister.canFind("unregister()"));

  // install prompt
  string capture = captureInstallPrompt();
  assert(capture.canFind("beforeinstallprompt"));
  assert(capture.canFind("window.pwaInstallPrompt = event;"));
  assert(capture.canFind("[data-pwa-install]"));

  string show = showInstallPrompt();
  assert(show.canFind("window.pwaInstallPrompt.prompt()"));

  // display mode check
  assert(isInstalledCheck.canFind("display-mode: standalone"));
  assert(isInstalledCheck.canFind("navigator.standalone"));

  // online status
  string status = onlineStatusHandlers("sync();", "showOffline();");
  assert(status.canFind("window.addEventListener('online'"));
  assert(status.canFind("sync();"));
  assert(status.canFind("window.addEventListener('offline'"));
  assert(status.canFind("showOffline();"));
  assert(onlineStatusHandlers().canFind("console.log('online');"));

  // push
  assert(pushSubscribe("key123").canFind("pushManager.subscribe"));
  assert(pushSubscribe("key123").canFind("'key123'"));
  assert(requestNotificationPermission.canFind("Notification.requestPermission()"));

  // setup builder
  auto manifest = pwaManifest("My App")
    .themeColor("#3498db")
    .icon("/icon-192.png", "192x192", "image/png");
  auto setup = pwaSetup(manifest)
    .serviceWorker("/sw.js")
    .withInstallPrompt
    .withOnlineStatus("sync();");

  assert(setup.manifest is manifest);

  auto head = setup.headEntries;
  assert(head.length == 3);
  assert(head[0] == `<link rel="manifest" href="/manifest.json">`);
  assert(head[1] == `<meta name="theme-color" content="#3498db">`);
  assert(head[2].canFind("apple-touch-icon"));

  auto scripts = setup.scripts;
  assert(scripts.length == 3);
  assert(scripts[0].canFind("<script>"));
  assert(scripts[0].canFind("serviceWorker"));
  assert(scripts[1].canFind("beforeinstallprompt"));
  assert(scripts[2].canFind("sync();"));

  // apply to document
  auto doc = htmlDocument("PWA");
  setup.applyTo(doc);
  string rendered = doc.toString;
  assert(rendered.canFind(`<link rel="manifest" href="/manifest.json">`));
  assert(rendered.canFind("serviceWorker"));

  // minimal setup: only the manifest link
  auto minimal = pwaSetup(pwaManifest("Mini"));
  assert(minimal.headEntries.length == 1);
  assert(minimal.scripts.length == 0);
}
