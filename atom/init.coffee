# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.

################################################################################

# An example command to demonstrate the ability to define commands in
# init.coffee. See the corresponding keymap in keymap.cson.
#
# It's useful to define commands in init.coffee if you want to:
# - Have a sandbox for experimenting with new commands before publishing them in
#   a package.
# - Define tiny commands without the overhead of creating an entire package.
# - Define commands for your own private use (e.g., commands that you might not
#   want to share for some reason).
atom.workspaceView.command 'dot-atom:demo', ->
  console.log "Hello from dot-atom:demo"

# Delete to end of line **without** modifying the pasteboard. Useful as an
# alternative to Atom's built-in 'editor:cut-to-end-of-line' command.
atom.workspaceView.command 'dot-atom:delete-to-end-of-line', '.editor', ->
  editor = atom.workspaceView.getActiveView().getEditor()
  editor.selectToEndOfLine()
  editor.delete()
