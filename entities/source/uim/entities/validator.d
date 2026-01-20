/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.validator;

import uim.core;
import uim.oop;
import uim.entities.entity;
import uim.entities.attributes;

import std.regex : regex, matchFirst;
import std.conv : to;
import std.traits;

@safe:

/**
 * Validation rule interface
 */
interface IValidationRule {
    bool validate(string value);
    string errorMessage();
}

/**
 * Required field validation
 */
class RequiredRule : UIMObject, IValidationRule {
    this() { super(); }
    
    bool validate(string value) {
        return value.length > 0;
    }
    
    string errorMessage() {
        return "Field is required";
    }
}

/**
 * Maximum length validation
 */
class MaxLengthRule : UIMObject, IValidationRule {
    protected size_t _maxLength;
    
    this(size_t maxLen) {
        super();
        _maxLength = maxLen;
    }
    
    bool validate(string value) {
        return value.length <= _maxLength;
    }
    
    string errorMessage() {
        return "Field exceeds maximum length of " ~ _maxLength.to!string;
    }
}

/**
 * Minimum length validation
 */
class MinLengthRule : UIMObject, IValidationRule {
    protected size_t _minLength;
    
    this(size_t minLen) {
        super();
        _minLength = minLen;
    }
    
    bool validate(string value) {
        return value.length >= _minLength;
    }
    
    string errorMessage() {
        return "Field must be at least " ~ _minLength.to!string ~ " characters";
    }
}

/**
 * Pattern (regex) validation
 */
class PatternRule : UIMObject, IValidationRule {
    protected string _pattern;
    
    this(string pattern) {
        super();
        _pattern = pattern;
    }
    
    bool validate(string value) @trusted {
        auto re = regex(_pattern);
        auto match = matchFirst(value, re);
        return !match.empty;
    }
    
    string errorMessage() {
        return "Field does not match required pattern";
    }
}

/**
 * Entity validator
 */
class DEntityValidator : UIMObject {
    protected IValidationRule[][string] _rules;
    
    this() {
        super();
    }
    
    /**
     * Add a validation rule for a field
     */
    DEntityValidator addRule(string fieldName, IValidationRule rule) {
        if (fieldName !in _rules) {
            _rules[fieldName] = [];
        }
        _rules[fieldName] ~= rule;
        return this;
    }
    
    /**
     * Validate an entity
     */
    bool validate(IEntity entity) {
        entity.clearErrors();
        bool isValid = true;
        
        foreach (fieldName, rules; _rules) {
            auto value = entity.getAttribute(fieldName);
            
            foreach (rule; rules) {
                if (!rule.validate(value)) {
                    entity.addError(fieldName ~ ": " ~ rule.errorMessage());
                    isValid = false;
                }
            }
        }
        
        return isValid;
    }
    
    /**
     * Create validator from entity UDAs
     */
    static DEntityValidator fromEntityType(T)() if (is(T == class)) {
        auto validator = new DEntityValidator();
        
        static foreach (memberName; __traits(allMembers, T)) {
            static if (is(typeof(__traits(getMember, T, memberName)))) {
                alias member = __traits(getMember, T, memberName);
                
                // Check for Required
                static if (hasUDA!(member, Required)) {
                    validator.addRule(memberName, new RequiredRule());
                }
                
                // Check for MaxLength
                static if (hasUDA!(member, MaxLength)) {
                    enum maxLen = getUDAs!(member, MaxLength)[0];
                    validator.addRule(memberName, new MaxLengthRule(maxLen.value));
                }
                
                // Check for MinLength
                static if (hasUDA!(member, MinLength)) {
                    enum minLen = getUDAs!(member, MinLength)[0];
                    validator.addRule(memberName, new MinLengthRule(minLen.value));
                }
                
                // Check for Pattern
                static if (hasUDA!(member, Pattern)) {
                    enum pattern = getUDAs!(member, Pattern)[0];
                    validator.addRule(memberName, new PatternRule(pattern.regex));
                }
            }
        }
        
        return validator;
    }
}

// Factory function
auto EntityValidator() {
    return new DEntityValidator();
}

unittest {
    writeln("Testing DEntityValidator class...");
    
    auto validator = EntityValidator();
    
    // Add validation rules
    validator.addRule("username", new RequiredRule());
    validator.addRule("username", new MinLengthRule(3));
    validator.addRule("username", new MaxLengthRule(20));
    
    // Test valid entity
    auto entity = Entity("Test");
    entity.setAttribute("username", "john_doe");
    
    assert(validator.validate(entity));
    assert(entity.isValid());
    
    // Test invalid entity (empty username)
    auto entity2 = Entity("Test2");
    entity2.setAttribute("username", "");
    
    assert(!validator.validate(entity2));
    assert(!entity2.isValid());
    assert(entity2.errors().length > 0);
    
    // Test invalid entity (too short)
    auto entity3 = Entity("Test3");
    entity3.setAttribute("username", "ab");
    
    assert(!validator.validate(entity3));
    assert(!entity3.isValid());
    
    writeln("DEntityValidator tests passed!");
}
