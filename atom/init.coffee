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
atom.commands.add 'atom-workspace', 'dot-atom:demo', ->
  console.log "Hello from dot-atom:demo"

# Toggle between light and dark theme.
atom.commands.add 'atom-workspace', 'dot-atom:toggle-theme', ->
  activeThemes = atom.themes.getActiveThemeNames()

  if activeThemes[0].indexOf("light") > 0
    atom.config.set("core.themes", ["one-dark-ui", "one-dark-syntax"])
  else
    atom.config.set("core.themes", ["one-light-ui", "one-light-syntax"])

# Close all panes.
#
# Atom's built-in 'pane:close-other-items' is super handy. But sometimes you
# just really want a completely clean slate.
#
# "Shut down all the [panes] on the detention level! ... Shut them all down.
# Hurry!"
atom.commands.add 'atom-workspace', 'dot-atom:close-all-panes', ->
  atom.workspace.getPanes().forEach (pane) ->
    pane.destroyItems()

# Define commands that should only be available in an editor view (and should
# not be available in a tree view, for example).
atom.commands.add 'atom-text-editor',

  # Approximate Vim's "H" motion: Move the cursor to the topmost line that is
  # currently visible.
  'dot-atom:move-to-top-visible-line': ->
    editor = atom.workspace.getActiveTextEditor()
    topRow = editor.getFirstVisibleScreenRow()
    topRow = topRow + 1 unless topRow == 0
    editor.setCursorBufferPosition [topRow, 0], autoscroll: false

  # Approximate Vim's "M" motion: Move the cursor to the middle line that is
  # currently visible.
  'dot-atom:move-to-middle-visible-line': ->
    editor = atom.workspace.getActiveTextEditor()
    topRow = editor.getFirstVisibleScreenRow()
    bottomRow = editor.getLastVisibleScreenRow()
    middleRow = Math.floor((bottomRow - topRow) / 2) + topRow
    editor.setCursorBufferPosition [middleRow, 0]

  # Approximate Vim's "L" motion: Move the cursor to the bottommost line that
  # is currently visible.
  'dot-atom:move-to-bottom-visible-line': ->
    editor = atom.workspace.getActiveTextEditor()
    bottomRow = editor.getLastVisibleScreenRow()
    bottomRow = bottomRow - 1 unless bottomRow == editor.getLastScreenRow()
    editor.setCursorBufferPosition [bottomRow, 0], autoscroll: false

  # Approximate Vim's "zt" motion: Scroll the view such that the line containing
  # the cursor is at the top of the view.
  'dot-atom:scroll-cursor-to-top': ->
    textEditor = atom.workspace.getActiveTextEditor()
    textEditorElement = atom.views.getView(textEditor)
    cursorPosition = textEditor.getCursorScreenPosition()
    pixelPositionForCursorPosition =
      textEditorElement.pixelPositionForScreenPosition(cursorPosition)
    textEditor.setScrollTop(pixelPositionForCursorPosition.top)

  # Approximate Vim's "zz" motion: Scroll the view such that the line containing
  # the cursor is vertically centered in the view.
  'dot-atom:scroll-cursor-to-center': ->
    textEditor = atom.workspace.getActiveTextEditor()
    textEditorElement = atom.views.getView(textEditor)
    cursorPosition = textEditor.getCursorScreenPosition()
    pixelPositionForCursorPosition =
      textEditorElement.pixelPositionForScreenPosition(cursorPosition)
    halfScreenHeight = textEditor.getHeight() / 2
    scrollTop = pixelPositionForCursorPosition.top - halfScreenHeight
    textEditor.setScrollTop(scrollTop)

  # Approximate Vim's "zb" motion: Scroll the view such that the line containing
  # the cursor is at the bottom of the view.
  'dot-atom:scroll-cursor-to-bottom': ->
    editor = atom.workspace.getActiveTextEditor()
    cursorPosition = editor.getCursorScreenPosition()
    scrollBottomPosition = [cursorPosition.row + 1, cursorPosition.column]
    pixelPositionForScrollBottomPosition =
      editor.pixelPositionForScreenPosition(scrollBottomPosition)
    editor.setScrollBottom(pixelPositionForScrollBottomPosition.top)

  # Move the cursor to the next diff in the editor, and then scroll the view
  # such that the line containing the cursor is vertically centered in the view.
  'dot-atom:center-next-diff': ->
    editor = atom.workspace.getActiveTextEditor()
    editorView = atom.views.getView(editor)
    atom.commands.dispatch editorView, "git-diff:move-to-next-diff"
    atom.commands.dispatch editorView, "dot-atom:scroll-cursor-to-center"

  # Move the cursor to the previous diff in the editor, and then scroll the view
  # such that the line containing the cursor is vertically centered in the view.
  'dot-atom:center-previous-diff': ->
    editor = atom.workspace.getActiveTextEditor()
    editorView = atom.views.getView(editor)
    atom.commands.dispatch editorView, "git-diff:move-to-previous-diff"
    atom.commands.dispatch editorView, "dot-atom:scroll-cursor-to-center"
