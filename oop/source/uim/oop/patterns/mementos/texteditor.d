module uim.oop.patterns.mementos.texteditor;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Text editor with undo/redo support using mementos.
 */
class TextEditor : IOriginator {
    private string _content;
    private int _cursorPosition;
    
    this() {
        _content = "";
        _cursorPosition = 0;
    }
    
    @safe void setText(string text) {
        _content = text;
        _cursorPosition = cast(int)text.length;
    }
    
    @safe void appendText(string text) {
        _content ~= text;
        _cursorPosition = cast(int)_content.length;
    }
    
    @safe void setCursor(int position) {
        if (position >= 0 && position <= _content.length) {
            _cursorPosition = position;
        }
    }
    
    @safe string content() const {
        return _content;
    }
    
    @safe int cursorPosition() const {
        return _cursorPosition;
    }
    
    @safe IMemento save() {
        return new TextEditorMemento(_content, _cursorPosition);
    }
    
    @safe void restore(IMemento memento) {
        auto textMemento = cast(TextEditorMemento)memento;
        if (textMemento !is null) {
            _content = textMemento.getContent();
            _cursorPosition = textMemento.getCursorPosition();
        }
    }
    
    /**
     * Private memento class - only TextEditor can access its internals.
     */
    private static class TextEditorMemento : Memento {
        private string _savedContent;
        private int _savedCursor;
        
        this(string content, int cursor) {
            super("TextEditor");
            _savedContent = content;
            _savedCursor = cursor;
        }
        
        @safe string getContent() const {
            return _savedContent;
        }
        
        @safe int getCursorPosition() const {
            return _savedCursor;
        }
    }
}