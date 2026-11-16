module uim.oop.patterns.mementos.games.savemanager;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Snapshot manager for game saves.
 */
class GameSaveManager : ISnapshotManager {
    private GameCharacter _character;
    private IMemento[string] _snapshots;
    
    this(GameCharacter character) {
        _character = character;
    }
    
    @safe void createSnapshot(string name) {
        _snapshots[name] = _character.save();
    }
    
    @safe bool restoreSnapshot(string name) {
        if (name !in _snapshots) {
            return false;
        }
        
        _character.restore(_snapshots[name]);
        return true;
    }
    
    @safe bool hasSnapshot(string name) const {
        return (name in _snapshots) !is null;
    }
    
    @trusted string[] snapshotNames() const {
        return cast(string[])_snapshots.keys;
    }
    
    @safe bool deleteSnapshot(string name) {
        if (name !in _snapshots) {
            return false;
        }
        
        _snapshots.remove(name);
        return true;
    }
}