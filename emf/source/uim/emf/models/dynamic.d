module uim.emf.models.dynamic;

import uim.emf;

@safe:

class DynamicEObject : EObject {
    private EClass _class;

    private Json[string] _values;

    this(EClass type) {
        if (type is null)
            throw new Exception("EClass must not be null");

        _class = type;
    }

    override
    EClass eClass() {
        return _class;
    }

    override
    Json get(string featureName) {
        auto feature = _class.getFeature(featureName);

        if (feature is null) {
            throw new Exception(
                "Unknown feature '" ~ featureName ~
                    "' on class '" ~ _class.name ~ "'");
        }

        if (feature.many) {
            if (featureName !in _values) {
                _values[featureName] = Json.emptyArray;
            }
        }

        return (featureName in _values) ? _values[featureName] : Json(null);
    }

    override
    void set(string featureName, Object value) {
        setValue(featureName, value);
    }

    void set(T)(string featureName, auto ref T value)
            if (!is(T : Object)) {
        setValue(featureName, value);
    }

    private void setValue(T)(string featureName, auto ref T value) {
        auto feature = _class.getFeature(featureName);

        if (feature is null) {
            throw new Exception(
                "Unknown feature '" ~ featureName ~
                    "' on class '" ~ _class.name ~ "'");
        }

        if (feature.many) {
            throw new Exception(
                "Feature '" ~ featureName ~
                    "' is multi-valued; use add() instead");
        }

        validate(feature, value);

        _values[featureName] = toJson(value);
    }

    void add(string featureName, Object value) {
        auto feature = _class.getFeature(featureName);

        if (feature is null) {
            throw new Exception(
                "Unknown feature '" ~ featureName ~
                    "' on class '" ~ _class.name ~ "'");
        }

        if (!feature.many) {
            throw new Exception(
                "Feature '" ~ featureName ~
                    "' is not multi-valued");
        }

        validate(feature, value);

        Json[] values;

        if (featureName in _values) {
            auto existing = _values[featureName];

            if (existing.type != Json.Type.array) {
                throw new Exception(
                    "Feature '" ~ featureName ~
                        "' is expected to store a JSON array");
            }

            values = existing.get!(Json[]);
        }

        values ~= toJson(value);

        _values[featureName] = Json(values);
        // return this;
    }

    override
    bool isSet(string featureName) {
        return (featureName in _values) ? true : false;
    }

    override
    void unset(string featureName) {
        _values.remove(featureName);
    }

    private void validate(
        EStructuralFeature feature,
        Object value) {
        if (value is null)
            return;

        if (auto reference = cast(EReference)feature) {
            auto object = cast(EObject)value;

            if (object is null) {
                throw new Exception(
                    "Reference '" ~ feature.name ~
                        "' requires an EObject");
            }
        }
    }

    private void validate(T)(
        EStructuralFeature feature,
        auto ref T value)
            if (!is(T : Object)) {
        if (auto reference = cast(EReference)feature) {
            throw new Exception(
                "Reference '" ~ feature.name ~
                    "' requires an EObject");
        }
    }

    private Json toJson(Object value) {
        if (value is null)
            return Json(null);

        if (auto eObject = cast(EObject)value) {
            auto referenceValue = Json.emptyObject;
            referenceValue["eClass"] = Json(eObject.eClass.name);
            return referenceValue;
        }

        return Json(value.classinfo.name);
    }

    private Json toJson(T)(auto ref T value)
            if (!is(T : Object)) {
        static if (is(T == Json))
            return value;

        return Json(value);
    }
}
unittest {
    auto person = new EClass("Person")
        .addAttribute(new EAttribute("name", typeid(string)));

    auto dynamicObject = new DynamicEObject(person);
    assert(dynamicObject.isSet("name") == false);
    dynamicObject.set("name", "John Doe");
    assert(dynamicObject.isSet("name") == true);
    assert(dynamicObject.get("name") == Json("John Doe"));
    dynamicObject.unset("name");
    assert(dynamicObject.isSet("name") == false);
}