module uim.emf.core.efactory;

import uim.emf;

@safe:

// interface EFactory
// {
//     EObject create(EClass type);
// }

/// Represents an EFactory in the EMF model.
/// EFactory is responsible for creating instances of EObjects based on their corresponding EClass.
/// It provides a create method that takes an EClass as input and returns a new instance of the corresponding EObject.
/// EFactory is used to instantiate EObjects in the EMF model, allowing for dynamic creation of objects based on their defined classes.
class EFactory {
    EObject create(EClass type) {
        if (type is null)
            throw new Exception("EClass must not be null");

        return type.create();
    }
}
