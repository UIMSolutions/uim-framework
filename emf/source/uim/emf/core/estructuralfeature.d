module uim.emf.core.estructuralfeature;

import uim.emf;

@safe:

// /// Represents an EStructuralFeature in the EMF model.
// interface EStructuralFeature {
//     string name();
//     bool many();
//     bool required();
// }

/// Represents an EStructuralFeature in the EMF model.
/// EStructuralFeature is an abstract class that serves as a base for EAttribute and EReference.
/// It contains common properties such as name, many, and required.
/// EStructuralFeature is used to define the structure of an EObject, specifying the features that an EObject can have.
abstract class EStructuralFeature {
    private string _name;
    private bool _many;
    private bool _required;

    this(string name, bool many = false, bool required = false) {
        _name = name;
        _many = many;
        _required = required;
    }

    @property
    string name() const {
        return _name;
    }

    @property
    bool many() const {
        return _many;
    }

    @property
    bool required() const {
        return _required;
    }
}
