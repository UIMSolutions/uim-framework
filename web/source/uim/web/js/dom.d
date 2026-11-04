/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.js.dom;

import uim.web;

mixin(ShowModule!());

@safe:

/// document.getElementById() expression, e.g. getElementById("app") -> `document.getElementById('app')`
string getElementById(string id) {
  return "document.getElementById(%s)".format(jsString(id));
}

/// document.querySelector() expression
string querySelector(string selector) {
  return "document.querySelector(%s)".format(jsString(selector));
}

/// document.querySelectorAll() expression
string querySelectorAll(string selector) {
  return "document.querySelectorAll(%s)".format(jsString(selector));
}

/// document.createElement() expression
string createElement(string tag) {
  return "document.createElement(%s)".format(jsString(tag));
}

/// addEventListener statement on an element expression
string addEventListener(string elementExpression, string event, string handlerExpression) {
  return "%s.addEventListener(%s, %s);".format(elementExpression, jsString(event), handlerExpression);
}

/// addEventListener with an inline arrow function body
string addEventListenerBlock(string elementExpression, string event, string body) {
  return addEventListener(elementExpression, event, jsArrowBlock(["event"], body));
}

/// removeEventListener statement
string removeEventListener(string elementExpression, string event, string handlerName) {
  return "%s.removeEventListener(%s, %s);".format(elementExpression, jsString(event), handlerName);
}

/// Sets the textContent of an element, e.g. setTextContent("el", "hi") -> `el.textContent = 'hi';`
string setTextContent(string elementExpression, string content) {
  return "%s.textContent = %s;".format(elementExpression, jsString(content));
}

/// Sets the innerHTML of an element
string setInnerHtml(string elementExpression, string html) {
  return "%s.innerHTML = %s;".format(elementExpression, jsString(html));
}

/// Sets an attribute on an element
string setAttribute(string elementExpression, string name, string value) {
  return "%s.setAttribute(%s, %s);".format(elementExpression, jsString(name), jsString(value));
}

/// Removes an attribute from an element
string removeAttribute(string elementExpression, string name) {
  return "%s.removeAttribute(%s);".format(elementExpression, jsString(name));
}

/// classList.add() statement
string classListAdd(string elementExpression, string[] classNames...) {
  return "%s.classList.add(%s);".format(elementExpression,
    classNames.map!(name => jsString(name)).join(", "));
}

/// classList.remove() statement
string classListRemove(string elementExpression, string[] classNames...) {
  return "%s.classList.remove(%s);".format(elementExpression,
    classNames.map!(name => jsString(name)).join(", "));
}

/// classList.toggle() statement
string classListToggle(string elementExpression, string className) {
  return "%s.classList.toggle(%s);".format(elementExpression, jsString(className));
}

/// Sets a style property on an element, e.g. setStyle("el", "color", "red") -> `el.style.color = 'red';`
string setStyle(string elementExpression, string property, string value) {
  return "%s.style.%s = %s;".format(elementExpression, property, jsString(value));
}

/// Appends a child element
string appendChild(string parentExpression, string childExpression) {
  return "%s.appendChild(%s);".format(parentExpression, childExpression);
}

/// Removes an element from the DOM
string removeElement(string elementExpression) {
  return "%s.remove();".format(elementExpression);
}

/// element.focus() statement
string focusElement(string elementExpression) {
  return "%s.focus();".format(elementExpression);
}

/// window.location assignment (navigation), e.g. redirectTo("/home") -> `window.location.href = '/home';`
string redirectTo(string url) {
  return "window.location.href = %s;".format(jsString(url));
}

/// window.scrollTo() call
string scrollTo(int x, int y) {
  return "window.scrollTo(%s, %s);".format(x, y);
}

/// localStorage.setItem() statement
string localStorageSet(string key, string value) {
  return "localStorage.setItem(%s, %s);".format(jsString(key), jsString(value));
}

/// localStorage.getItem() expression
string localStorageGet(string key) {
  return "localStorage.getItem(%s)".format(jsString(key));
}

/// localStorage.removeItem() statement
string localStorageRemove(string key) {
  return "localStorage.removeItem(%s);".format(jsString(key));
}

/// sessionStorage.setItem() statement
string sessionStorageSet(string key, string value) {
  return "sessionStorage.setItem(%s, %s);".format(jsString(key), jsString(value));
}

/// sessionStorage.getItem() expression
string sessionStorageGet(string key) {
  return "sessionStorage.getItem(%s)".format(jsString(key));
}

///
unittest {
  // selectors
  assert(getElementById("app") == "document.getElementById('app')");
  assert(querySelector(".btn") == "document.querySelector('.btn')");
  assert(querySelectorAll(".btn") == "document.querySelectorAll('.btn')");
  assert(createElement("div") == "document.createElement('div')");

  // events
  assert(addEventListener("el", "click", "handleClick")
    == "el.addEventListener('click', handleClick);");
  assert(addEventListenerBlock("el", "click", "hide();")
    == "el.addEventListener('click', (event) => { hide(); });");
  assert(removeEventListener("el", "click", "handleClick")
    == "el.removeEventListener('click', handleClick);");

  // content
  assert(setTextContent("el", "hi") == "el.textContent = 'hi';");
  assert(setInnerHtml("el", "<b>x</b>") == `el.innerHTML = '<b>x<\/b>';`);
  assert(setAttribute("el", "title", "T") == "el.setAttribute('title', 'T');");
  assert(removeAttribute("el", "title") == "el.removeAttribute('title');");

  // classes
  assert(classListAdd("el", "a", "b") == "el.classList.add('a', 'b');");
  assert(classListRemove("el", "a") == "el.classList.remove('a');");
  assert(classListToggle("el", "active") == "el.classList.toggle('active');");

  // styles and structure
  assert(setStyle("el", "color", "red") == "el.style.color = 'red';");
  assert(appendChild("parent", "child") == "parent.appendChild(child);");
  assert(removeElement("el") == "el.remove();");
  assert(focusElement("el") == "el.focus();");

  // window
  assert(redirectTo("/home") == "window.location.href = '/home';");
  assert(scrollTo(0, 100) == "window.scrollTo(0, 100);");

  // storage
  assert(localStorageSet("k", "v") == "localStorage.setItem('k', 'v');");
  assert(localStorageGet("k") == "localStorage.getItem('k')");
  assert(localStorageRemove("k") == "localStorage.removeItem('k');");
  assert(sessionStorageSet("k", "v") == "sessionStorage.setItem('k', 'v');");
  assert(sessionStorageGet("k") == "sessionStorage.getItem('k')");
}
