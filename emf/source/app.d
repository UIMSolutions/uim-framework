module app;

import uim.emf;

version (unittest) {
} else {
    void main() {
        // ----------------------------
        // Metamodell
        // ----------------------------

        auto person = new EClass("Person")
            .addAttribute(new EAttribute("name", typeid(string)))
            .addAttribute(new EAttribute("age", typeid(int)));

        auto company = new EClass("Company")
            .addAttribute(new EAttribute("name", typeid(string)))
            .addReference(new EReference("employees", person, true, true));

        // ----------------------------
        // Instanzen
        // ----------------------------

        auto alice = person.create()
            .set("name", "Alice")
            .set("age", 42);

        auto bob = person.create()
            .set("name", Json("Bob"))
            .set("age", Json(31));

        auto acme = company.create()
            .set("name", Json("ACME"));

        // ----------------------------
        // Beziehungen
        // ----------------------------

        auto dynamicCompany =
            cast(DynamicEObject)acme;

        dynamicCompany.add("employees", alice);
        dynamicCompany.add("employees", bob);

        // ----------------------------
        // Ausgabe
        // ----------------------------

        writeln(
            "Company: ",
            acme.get("name")
        );

        writeln(
            "Class: ",
            acme.eClass.name
        );

        writeln(
            "Alice: ",
            alice.get("name"),
            ", age=",
            alice.get("age")
        );

        writeln(
            "Bob: ",
            bob.get("name"),
            ", age=",
            bob.get("age")
        );
    }
}
