// You can access plugins via the 'services' global variable
/*global services, plugin*/

// to load plugins use
// services.pluginManager.loadPackage([
//     "https://<user>.github.io/<project>/build/package.<name>.js",
//     "~/.c9/plugins/<name>/package.json",
// ]);

// Prevent the terminal from treating the mousewheel as up/down arrow keys in zsh.
// @see https://github.com/c9/core/issues/270#issuecomment-196969854

var Terminal=require("plugins/c9.ide.terminal/aceterm/libterm");

Terminal.prototype.noScrollBack = function() {
    return (this.mouseEvents || this.tmuxDotCover);
};

Terminal.prototype.mouseEvents = true;

services.tabManager.once("ready", function() {
    services.tabManager.getTabs().forEach(function(tab) {
        updateEditor(tab.editor);
    });
    function updateEditor(editor) {
        if (editor && editor.type == "terminal" && editor.ace)
            editor.ace._eventRegistry.mousewheel.pop();
    }
    services.editors.on("create", updateEditor, plugin);
});
