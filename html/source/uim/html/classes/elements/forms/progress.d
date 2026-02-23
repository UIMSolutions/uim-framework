/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.progress;

import uim.html;

mixin(ShowModule!());

@safe:

/**  
  * Represents the HTML `<progress>` element, which is used to display the progress of a task or operation. It typically shows a progress bar that fills up as the task progresses.
  * 
  * The `<progress>` element can be used to indicate the completion status of a task, such as file uploads, downloads, or any other process that takes time to complete. It can also be used to show the progress of a multi-step process.
  * 
  * Browser support: All major browsers support the `<progress>` element.
  *
  * Examples:
  * ```html
  * <progress value="70" max="100">70%</progress>
  * ```
  */
@StringAttribute("value")
@StringAttribute("max")
class H5Progress : HtmlElement {
  mixin(H5This!("progress", false));

  /// Sets the value attribute of the progress element, indicating the current progress.
  H5Progress value(double val) {
    attribute("value", val.to!string);
    return this;
  }

  /// Sets the max attribute of the progress element, indicating the total amount of work.
  H5Progress max(double val) {
    attribute("max", val.to!string);
    return this;
  }

  mixin(H5Calls!("Progress"));
}
///
unittest {
  assert(H5Progress() == `<progress></progress>`);
  assert(H5Progress().value(50) == `<progress value="50"></progress>`);
  assert(H5Progress().max(100) == `<progress max="100"></progress>`);
  assert(H5Progress().value(70).max(100) == `<progress max="100" value="70"></progress>`);
}
