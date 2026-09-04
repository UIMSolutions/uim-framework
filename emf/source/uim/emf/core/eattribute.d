module uim.emf.core.eattribute;

import uim.emf;

@safe:

// interface EAttribute : EStructuralFeature{
//     Type valueType();
// }

/// Represents an EAttribute in the EMF model.
/// EAttribute is a subclass of EStructuralFeature that represents an attribute of an EObject.
/// It contains a property called valueType, which defines the type of the attribute's value.
/// EAttribute is used to define the attributes that an EObject can have in the EMF model.
class EAttribute : EStructuralFeature {
    private TypeInfo _valueType;

    this(
        string name,
        TypeInfo valueType,
        bool many = false,
        bool required = false) {

        super(name, many, required);
        _valueType = valueType;
    }

    @property
    TypeInfo valueType() {
        return _valueType;
    }
}
///
unittest {
    import std.stdio;
    import std.conv;

    auto nameAttr = new EAttribute("name", stringType, false, true);
    assert(nameAttr.name == "name");
    assert(nameAttr.valueType is stringType);
    assert(!nameAttr.many);
    assert(nameAttr.required);

    auto ageAttr = new EAttribute("age", intType, false, false);
    assert(ageAttr.name == "age");
    assert(ageAttr.valueType is intType);
    assert(!ageAttr.many);
    assert(!ageAttr.required);
}
