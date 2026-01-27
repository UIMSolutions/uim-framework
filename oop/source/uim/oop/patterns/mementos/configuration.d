/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.mementos.configuration;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Application configuration with rollback support.
 */
class Configuration : IOriginator {
    private string[string] _settings;
    
    @safe void set(string key, string value) {
        _settings[key] = value;
    }
    
    @safe string get(string key, string defaultValue = "") const {
        if (key in _settings) {
            return _settings[key];
        }
        return defaultValue;
    }
    
    @safe bool has(string key) const {
        return (key in _settings) !is null;
    }
    
    @safe size_t settingCount() const {
        return _settings.length;
    }
    
    @safe IMemento save() {
        return new ConfigMemento(_settings.dup);
    }
    
    @safe void restore(IMemento memento) {
        auto configMemento = cast(ConfigMemento)memento;
        if (configMemento !is null) {
            _settings = configMemento.getSettings().dup;
        }
    }
    
    private static class ConfigMemento : Memento {
        private string[string] _savedSettings;
        
        this(string[string] settings) @safe {
            super("Configuration");
            _savedSettings = settings;
        }
        
        @trusted string[string] getSettings() const {
            return cast(string[string])_savedSettings;
        }
    }
}