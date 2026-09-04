module uim.emf.core.eobject;

import uim.emf;

@safe:

/// Represents an EObject in the EMF model.
interface EObject {
    EClass eClass();

    Json get(string featureName);

    void set(string featureName, Object value);

    bool isSet(string featureName);

    void unset(string featureName);
}

