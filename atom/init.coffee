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
#
# TODO Change this to delete to the VERY end of the line, regardless of whether
# the line is wrapped.
atom.workspaceView.command 'dot-atom:delete-to-end-of-line', '.editor', ->
  editor = atom.workspaceView.getActiveView().getEditor()
  editor.selectToEndOfLine()
  editor.delete()

# Approximate Vim's "H" motion: Move the cursor to the topmost line that is
# currently visible.
atom.workspaceView.command 'dot-atom:move-to-top-visible-line', '.editor', ->
  view = atom.workspaceView.getActiveView()
  topRow = view.getFirstVisibleScreenRow()
  topRow = topRow + 1 unless topRow == 0
  view.getEditor().setCursorBufferPosition [topRow, 0], autoscroll: false

# Approximate Vim's "M" motion: Move the cursor to the middle line that is
# currently visible.
atom.workspaceView.command 'dot-atom:move-to-middle-visible-line', '.editor', ->
  view = atom.workspaceView.getActiveView()
  topRow = view.getFirstVisibleScreenRow()
  bottomRow = view.getLastVisibleScreenRow()
  middleRow = Math.floor((bottomRow - topRow) / 2) + topRow
  view.getEditor().setCursorBufferPosition [middleRow, 0]

# Approximate Vim's "L" motion: Move the cursor to the bottommost line that
# is currently visible.
atom.workspaceView.command 'dot-atom:move-to-bottom-visible-line', '.editor', ->
  view = atom.workspaceView.getActiveView()
  editor = view.getEditor()
  bottomRow = view.getLastVisibleScreenRow()
  bottomRow = bottomRow - 1 unless bottomRow == editor.getLastScreenRow()
  editor.setCursorBufferPosition [bottomRow, 0], autoscroll: false

# Approximate Vim's "zt" motion: Scroll the view such that the line containing
# the cursor is at the top of the view.
atom.workspaceView.command 'dot-atom:scroll-cursor-to-top', '.editor', ->
  view = atom.workspaceView.getActiveView()
  editor = view.getEditor()
  pixelPositionForCursorPosition =
    view.pixelPositionForScreenPosition(editor.getCursorScreenPosition())
  view.scrollTop pixelPositionForCursorPosition.top

# Approximate Vim's "zz" motion: Scroll the view such that the line containing
# the cursor is vertically centered in the view.
atom.workspaceView.command 'dot-atom:scroll-cursor-to-center', '.editor', ->
  view = atom.workspaceView.getActiveView()
  editor = view.getEditor()
  # TODO Why can't we implement this command using: `view.scrollToScreenPosition view.getCursorScreenPosition(), center: true`
  #      This line seems to be the culprit: https://github.com/atom/atom/blob/9fce6a2f1cea680d69bc3181774bc98c541f00b7/src/editor-view.coffee#L1133
  #      Because of that line, if the cursor is currently visible, no
  #      scrolling occurs.
  pixelPositionForCursorPosition =
    view.pixelPositionForScreenPosition(editor.getCursorScreenPosition())
  halfScreenHeight = view.scrollView.height() / 2
  view.scrollTop(pixelPositionForCursorPosition.top - halfScreenHeight)

# Approximate Vim's "zb" motion: Scroll the view such that the line containing
# the cursor is at the bottom of the view.
atom.workspaceView.command 'dot-atom:scroll-cursor-to-bottom', '.editor', ->
  view = atom.workspaceView.getActiveView()
  cursorPosition = view.getEditor().getCursorScreenPosition()
  scrollBottomPosition = [cursorPosition.row + 1, cursorPosition.column]
  pixelPositionForScrollBottomPosition =
    view.pixelPositionForScreenPosition(scrollBottomPosition)
  view.scrollBottom pixelPositionForScrollBottomPosition.top