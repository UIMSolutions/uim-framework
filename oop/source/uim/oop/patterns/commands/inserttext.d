module uim.oop.patterns.commands.inserttext;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Insert text command.
 */
class InsertTextCommand : DUndoableCommand {
    private TextEditorReceiver _editor;
    private string _textToInsert;

    this(TextEditorReceiver editor, string text) @safe {
        // super("InsertText");
        super();
        _editor = editor;
        _textToInsert = text;
    }

    protected override @safe bool doExecute(Json[string] options = null) {
        _editor.insertText(_textToInsert);
        return true;
    }

    protected /* override */  @safe bool doUndo(Json[string] options = null) {
        _editor.deleteText(_textToInsert.length);
        return true;
    }
}