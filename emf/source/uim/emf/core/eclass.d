module uim.emf.core.eclass;

import uim.emf;

@safe:

/// Represents an EClass in the EMF model.
// interface EClass : EClassifier {
//     EClass[] superTypes();
//     EStructuralFeature[] features();
// }

/// Represents an EClass in the EMF model.
/// EClass is a concrete class that extends EClassifier and represents a class in the EMF model.
/// It contains properties such as superTypes and features, which define the inheritance hierarchy and the structural features of the class.
/// EClass is used to define the structure and behavior of EObjects in the EMF model.
class EClass : EClassifier {
    private string _name;

    private EClass[] _superTypes;
    private EStructuralFeature[] _features;

    this(string name) {
        _name = name;
    }

    @property
    string name() const {
        return _name;
    }

    void addSuperType(EClass type) {
        _superTypes ~= type;
    }

    void addFeature(EStructuralFeature feature) {
        if (getFeature(feature.name) !is null)
            throw new Exception(
                "Feature already exists: " ~ feature.name);

        _features ~= feature;
    }

    EClass addAttribute(EAttribute attribute) {
        addFeature(attribute);
        return this;
    }

    EClass addReference(EReference reference) {
        addFeature(reference);
        return this;
    }

    EStructuralFeature getFeature(string name) {
        foreach (feature; _features) {
            if (feature.name == name)
                return feature;
        }

        foreach (base; _superTypes) {
            auto feature = base.getFeature(name);

            if (feature !is null)
                return feature;
        }

        return null;
    }

    EStructuralFeature[] features() {
        return _features;
    }

    EClass[] superTypes() {
        return _superTypes;
    }

    EObject create() {
        return new DynamicEObject(this);
    }
}
///
unittest {
    auto person = new EClass("Person")
        .addAttribute(new EAttribute("name", typeid(string)))
        .addAttribute(new EAttribute("age", typeid(int)));

    assert(person.name == "Person");
    assert(person.features.length == 2);
    assert(person.getFeature("name") !is null);
    assert(person.getFeature("age") !is null);
}