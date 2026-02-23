/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.table;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <table> HTML element represents tabular data, which is data presented in a grid of rows and columns. 
  * It is used to organize and display information in a structured format. 
  * The <table> element can contain various child elements such as <caption>, <colgroup>, <thead>, <tbody>, <tfoot>, <tr>, <th>, and <td> to define the table's structure and content.
  *
  * Example usage:
  * <table border="1" cellspacing="0" cellpadding="5">
  *   <caption>Monthly Sales Report</caption>
  *   <tr>
  *     <th>Month</th>
  *     <th>Sales</th>
  *   </tr>
  *   <tr>
  *     <td>January</td>
  *     <td>$10,000</td>
  *   </tr>
  *   <tr>
  *     <td>February</td>
  *     <td>$12,000</td>
  *   </tr>
  * </table>
  */
  @StringAttribute("border")
  @StringAttribute("cellspacing")
  @StringAttribute("cellpadding")
class H5Table : HtmlElement {
  mixin(H5Template!("Table", "table", false));
  mixin(AttributeMethods!H5Table);
}
///
unittest {
  assert(H5Table() == `<table></table>`);
  assert(H5Table(["testclass"]) == `<table class="testclass"></table>`);
  assert(H5Table(["a":"b"]) == `<table a="b"></table>`);
  assert(H5Table(["testclass"], ["a":"b"]) == `<table class="testclass" a="b"></table>`);

  assert(H5Table("Hello") == `<table>Hello</table>`);
  assert(H5Table(["testclass"], "Hello") == `<table class="testclass">Hello</table>`);
  assert(H5Table(["a":"b"], "Hello") == `<table a="b">Hello</table>`);

  assert(H5Table(["testclass"], ["a":"b"], "Hello") == `<table class="testclass" a="b">Hello</table>`);

  assert(H5Table().border("1") == `<table border="1"></table>`);
  assert(H5Table().cellspacing("0") == `<table cellspacing="0"></table>`);
  assert(H5Table().cellpadding("5") == `<table cellpadding="5"></table>`);
}
