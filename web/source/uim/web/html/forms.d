/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.html.forms;

import uim.web;

mixin(ShowModule!());

@safe:

/// Form element, e.g. form("/submit", "post")
HtmlElement form(string action = null, string method = "get") {
  auto element = new HtmlElement("form");
  if (action.length > 0) {
    element.attr("action", action);
  }
  element.attr("method", method.toLower);
  return element;
}

/// Label element, e.g. label("name", "Name") -> `<label for="name">Name</label>`
string label(string forId, string content) {
  return htmlTag("label", ["for": forId], content);
}

/// Input element, e.g. input("text", "username")
HtmlElement input(string type, string name, string value = null) {
  auto element = new HtmlElement("input")
    .attr("type", type)
    .attr("name", name);
  if (value.length > 0) {
    element.attr("value", value);
  }
  return element;
}

/// Text input element
HtmlElement inputText(string name, string value = null, string placeholder = null) {
  auto element = input("text", name, value);
  if (placeholder.length > 0) {
    element.attr("placeholder", placeholder);
  }
  return element;
}

/// Password input element
HtmlElement inputPassword(string name, string placeholder = null) {
  auto element = input("password", name);
  if (placeholder.length > 0) {
    element.attr("placeholder", placeholder);
  }
  return element;
}

/// Email input element
HtmlElement inputEmail(string name, string value = null) {
  return input("email", name, value);
}

/// Number input element with optional min/max
HtmlElement inputNumber(string name, string value = null, int min = int.min, int max = int.max) {
  auto element = input("number", name, value);
  if (min != int.min) {
    element.attr("min", min.to!string);
  }
  if (max != int.max) {
    element.attr("max", max.to!string);
  }
  return element;
}

/// Checkbox input element
HtmlElement inputCheckbox(string name, string value = "on", bool checked = false) {
  auto element = input("checkbox", name, value);
  if (checked) {
    element.boolAttr("checked");
  }
  return element;
}

/// Radio input element
HtmlElement inputRadio(string name, string value, bool checked = false) {
  auto element = input("radio", name, value);
  if (checked) {
    element.boolAttr("checked");
  }
  return element;
}

/// Hidden input element
HtmlElement inputHidden(string name, string value) {
  return input("hidden", name, value);
}

/// File input element
HtmlElement inputFile(string name, string accept = null) {
  auto element = input("file", name);
  if (accept.length > 0) {
    element.attr("accept", accept);
  }
  return element;
}

/// Submit button input element
HtmlElement inputSubmit(string value = "Submit") {
  return new HtmlElement("input").attr("type", "submit").attr("value", value);
}

/// Textarea element, e.g. textarea("bio", "Some text")
HtmlElement textarea(string name, string content = null, int rows = 0, int cols = 0) {
  auto element = new HtmlElement("textarea").attr("name", name);
  if (content.length > 0) {
    element.text(content);
  }
  if (rows > 0) {
    element.attr("rows", rows.to!string);
  }
  if (cols > 0) {
    element.attr("cols", cols.to!string);
  }
  return element;
}

/// Option element, e.g. option("de", "Germany") -> `<option value="de">Germany</option>`
string option(string value, string content, bool selected = false) {
  return optionElement(value, content, selected).toString;
}

private HtmlElement optionElement(string value, string content, bool selected) {
  auto element = new HtmlElement("option").attr("value", value).text(content);
  return selected ? element.boolAttr("selected") : element;
}

/// Select element from value/label pairs, in the given order, e.g. select("c", [["de", "Germany"]])
HtmlElement select(string name, string[2][] options, string selectedValue = null) {
  auto element = new HtmlElement("select").attr("name", name);
  foreach (pair; options) {
    element.add(optionElement(pair[0], pair[1], pair[0] == selectedValue));
  }
  return element;
}

/// Select element from an associative array, sorted by value
HtmlElement select(string name, string[string] options, string selectedValue = null) {
  return select(name, sortedPairs(options), selectedValue);
}

/// Button element, e.g. button("Save") -> "<button>Save</button>"
string button(string content, string type = "button", string[string] attributes = null) {
  auto element = new HtmlElement("button").attrs(attributes).attr("type", type).text(content);
  return element.toString;
}

/// Fieldset element with optional legend
HtmlElement fieldset(string legend = null) {
  auto element = new HtmlElement("fieldset");
  if (legend.length > 0) {
    element.add("legend", legend);
  }
  return element;
}

/// Legend element (caption of a fieldset)
string legend(string content) {
  return htmlTag("legend", content);
}

/// Datalist element with option values
HtmlElement datalist(string id, string[] values) {
  auto element = new HtmlElement("datalist").id(id);
  foreach (value; values) {
    element.add(new HtmlElement("option").attr("value", value));
  }
  return element;
}

/// Progress element, e.g. progress(70, 100)
string progress(int value, int max = 100) {
  return new HtmlElement("progress")
    .attr("value", value.to!string)
    .attr("max", max.to!string)
    .toString;
}

/// Meter element, e.g. meter(6, 10)
string meter(int value, int min, int max) {
  return new HtmlElement("meter")
    .attr("value", value.to!string)
    .attr("min", min.to!string)
    .attr("max", max.to!string)
    .toString;
}

///
unittest {
  // form
  assert(form.toString == `<form method="get"></form>`);
  assert(form("/submit", "post").toString == `<form action="/submit" method="post"></form>`);

  // label
  assert(label("name", "Name") == `<label for="name">Name</label>`);

  // inputs
  assert(input("text", "username").toString == `<input type="text" name="username">`);
  assert(input("text", "username", "oz").toString == `<input type="text" name="username" value="oz">`);
  assert(inputText("q", null, "Search...").toString == `<input type="text" name="q" placeholder="Search...">`);
  assert(inputPassword("pw", "Password").toString == `<input type="password" name="pw" placeholder="Password">`);
  assert(inputEmail("mail", "a@b.c").toString == `<input type="email" name="mail" value="a@b.c">`);
  assert(inputNumber("age", "5", 0, 120).toString == `<input type="number" name="age" value="5" min="0" max="120">`);
  assert(inputNumber("age").toString == `<input type="number" name="age">`);
  assert(inputCheckbox("agree", "yes", true).toString == `<input type="checkbox" name="agree" value="yes" checked>`);
  assert(inputCheckbox("agree").toString == `<input type="checkbox" name="agree" value="on">`);
  assert(inputRadio("color", "red", true).toString == `<input type="radio" name="color" value="red" checked>`);
  assert(inputHidden("token", "abc").toString == `<input type="hidden" name="token" value="abc">`);
  assert(inputFile("upload", ".png,.jpg").toString == `<input type="file" name="upload" accept=".png,.jpg">`);
  assert(inputSubmit("Go").toString == `<input type="submit" value="Go">`);
  assert(inputSubmit.toString == `<input type="submit" value="Submit">`);

  // textarea
  assert(textarea("bio").toString == `<textarea name="bio"></textarea>`);
  assert(textarea("bio", "text", 4, 40).toString == `<textarea name="bio" rows="4" cols="40">text</textarea>`);

  // option and select
  assert(option("de", "Germany") == `<option value="de">Germany</option>`);
  assert(option("de", "Germany", true) == `<option value="de" selected>Germany</option>`);

  auto countrySelect = select("country", ["de": "Germany", "at": "Austria"], "at");
  assert(countrySelect.toString.canFind(`<select name="country">`));
  assert(countrySelect.toString.canFind(`<option value="at" selected>Austria</option>`));

  // pairs keep their order, associative arrays are sorted
  assert(select("c", [["z", "Z"], ["a", "A"]]).toString
    == `<select name="c"><option value="z">Z</option><option value="a">A</option></select>`);
  assert(select("c", ["z": "Z", "a": "A"]).toString
    == `<select name="c"><option value="a">A</option><option value="z">Z</option></select>`);

  // button
  assert(button("Save") == `<button type="button">Save</button>`);
  assert(button("Send", "submit", ["class": "btn"]) == `<button class="btn" type="submit">Send</button>`);

  // fieldset and legend
  assert(fieldset("Login").toString == "<fieldset><legend>Login</legend></fieldset>");
  assert(fieldset.toString == "<fieldset></fieldset>");
  assert(legend("L") == "<legend>L</legend>");

  // datalist
  auto dl = datalist("colors", ["red", "green"]);
  assert(dl.toString == `<datalist id="colors"><option value="red"></option><option value="green"></option></datalist>`);

  // progress and meter
  assert(progress(70) == `<progress value="70" max="100"></progress>`);
  assert(progress(1, 4) == `<progress value="1" max="4"></progress>`);
  assert(meter(6, 0, 10) == `<meter value="6" min="0" max="10"></meter>`);

  // composition
  auto loginForm = form("/login", "post")
    .raw(label("user", "User"))
    .add(inputText("user"))
    .raw(label("pass", "Password"))
    .add(inputPassword("pass"))
    .add(inputSubmit("Login"));
  assert(loginForm.toString.canFind(`<label for="user">User</label>`));
  assert(loginForm.toString.canFind(`<input type="submit" value="Login">`));
}
