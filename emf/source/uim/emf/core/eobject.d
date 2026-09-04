module uim.emf.core.EObject;

import uim.emf;

@safe:

/// Represents an EObject in the EMF model.
interface EObject {
    EClass eClass();

    Json get(string featureName);

    // void set(string featureName, Object value);

    EObject set(string featureName, Json value);
    EObject add(string featureName, Json value);
    EObject add(string featureName, string key, Json value);

    bool isSet(string featureName);
    EObject unset(string featureName);
}

