#!/usr/bin/env dub
/+ dub.sdl:
    dependency "uim-framework:cdm" path="../"
+/
import uim.cdm;
import std.stdio;

void main() {
    writeln("=== UIM CDM Basic Usage Example ===\n");

    // Create a contact
    auto contact = new Contact();
    contact
        .name("John Doe")
        .firstName("John")
        .lastName("Doe")
        .email("john.doe@example.com")
        .phone("+1-555-0123")
        .title("Software Engineer")
        .department("Engineering")
        .city("San Francisco")
        .state("CA")
        .country("USA");

    writeln("Contact created:");
    writeln("Full Name: ", contact.fullName());
    writeln("Email: ", contact.email());
    writeln("Is Valid: ", contact.isValid());
    writeln("\nContact as JSON:");
    writeln(contact.toJson().toPrettyString());

    // Create an account
    auto account = new Account();
    account
        .name("Acme Corporation")
        .accountNumber("ACC-12345")
        .email("info@acme.com")
        .phone("+1-555-0100")
        .website("www.acme.com")
        .industry("Technology")
        .type("Customer")
        .revenue(1000000.0)
        .employeeCount(50);

    writeln("\n\nAccount created:");
    writeln("Name: ", account.name());
    writeln("Revenue: $", account.revenue());
    writeln("\nAccount as JSON:");
    writeln(account.toJson().toPrettyString());

    // Create a product
    auto product = new Product();
    product
        .name("Widget Pro")
        .sku("WDG-001")
        .category("Electronics")
        .brand("Acme")
        .price(99.99)
        .currency("USD")
        .cost(50.00)
        .stockQuantity(100)
        .reorderLevel(20);

    writeln("\n\nProduct created:");
    writeln("Name: ", product.name());
    writeln("SKU: ", product.sku());
    writeln("Price: $", product.price());
    writeln("Margin: ", product.margin(), "%");
    writeln("Needs Reorder: ", product.needsReorder());
    writeln("\nProduct as JSON:");
    writeln(product.toJson().toPrettyString());
}
