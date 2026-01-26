import uim.entities;
import std.stdio;

@UseEntity("test_users")
class TestUser : DAnnotateUIMEntity {
    @EntityAttribute("username")
    @Required
    string username;
    
    @EntityAttribute("email")
    @Required
    string email;
}

void main() {
    auto user = new TestUser();
    writeln("Username: '", user.username, "'");
    writeln("Email: '", user.email, "'");
    
    auto errors = user.validate();
    writeln("Validation errors: ", errors.length);
    foreach (error; errors) {
        writeln("  - ", error);
    }
}
