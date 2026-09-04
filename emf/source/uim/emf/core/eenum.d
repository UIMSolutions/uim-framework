module uim.emf.core.eenum;

import uim.emf;

@safe:

class EEnum : EClassifierBase {
    private string[] _literals;

    this(string name) {
        _name = name;
    }

    void addLiteral(string literal) {
        _literals ~= literal;
    }

    string[] literals() {
        return _literals;
    }
}
unittest {  
    auto colorEnum = new EEnum("Color");
    colorEnum.addLiteral("Red");
    colorEnum.addLiteral("Green");
    colorEnum.addLiteral("Blue");

    assert(colorEnum.literals().length == 3);
    assert(colorEnum.literals()[0] == "Red");
    assert(colorEnum.literals()[1] == "Green");
    assert(colorEnum.literals()[2] == "Blue");
}