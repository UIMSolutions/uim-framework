module emf.backlog.app;

import uim.emf;

// version (unittest) {
// } else {
//     void main() {
//         // ----------------------------
//         // Metamodel
//         // ----------------------------

//         auto person = new EClass("Person")
//             .addAttribute(new EAttribute("name", stringType))
//             .addAttribute(new EAttribute("age", intType));

//         auto company = new EClass("Company")
//             .addAttribute(new EAttribute("name", stringType))
//             .addReference(new EReference("employees", person, true, true));

//         // ----------------------------
//         // Instances
//         // ----------------------------

//         auto alice = person.create()
//             .set("name", Json("Alice"))
//             .set("age", Json(42));

//         auto bob = person.create()
//             .set("name", Json("Bob"))
//             .set("age", Json(31));

//         auto acme = company.create()
//             .set("name", Json("ACME"));

//         // ----------------------------
//         // Relationships
//         // ----------------------------

//         auto dynamicCompany =
//             cast(DynamicEObject)acme;

//         // dynamicCompany.add("employees", alice);
//         // dynamicCompany.add("employees", bob);

//         // ----------------------------
//         // Output
//         // ----------------------------

//         writeln(
//             "Company: ",
//             acme.get("name")
//         );

//         writeln(
//             "Class: ",
//             acme.eClass.name
//         );

//         writeln(
//             "Alice: ",
//             alice.get("name"),
//             ", age=",
//             alice.get("age")
//         );

//         writeln(
//             "Bob: ",
//             bob.get("name"),
//             ", age=",
//             bob.get("age")
//         );
//     }
// }
