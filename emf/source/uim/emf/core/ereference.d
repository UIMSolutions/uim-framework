module uim.emf.core.ereference;

import uim.emf;

@safe:

// interface EReference : EStructuralFeature
// {
//     EClass referenceType();
//     bool containment();
// }

/// Represents an EReference in the EMF model.
/// EReference is a subclass of EStructuralFeature that represents a reference to another EObject.
/// It contains properties such as referenceType and containment, which define the type of the referenced EObject and whether the reference is a containment reference.
/// EReference is used to define the relationships between EObjects in the EMF model.
class EReference : EStructuralFeature {
    private EClass _referenceType;
    private bool _containment;

    this(
        string name,
        EClass referenceType,
        bool many = false,
        bool containment = false,
        bool required = false) {
        super(name, many, required);

        _referenceType = referenceType;
        _containment = containment;
    }

    @property
    EClass referenceType() {
        return _referenceType;
    }

    @property
    bool containment() const {
        return _containment;
    }
}
unittest {
    auto personClass = new EClass("Person");
    auto addressClass = new EClass("Address");

    auto notMany = false;
    auto isContainment = true;
    auto isRequired = true;
    auto addressRef = new EReference("address", addressClass, notMany, isContainment, isRequired);

    assert(addressRef.referenceType is addressClass);
    assert(addressRef.containment);
    assert(!addressRef.many);
    assert(addressRef.required);

    auto personRef = new EReference("person", personClass, notMany, isContainment, isRequired);

    assert(personRef.referenceType is personClass);
    assert(personRef.containment);
    assert(!personRef.many);
    assert(personRef.required);
}