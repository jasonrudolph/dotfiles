////////////////////////////////////////////////////////////////////////////////
// Atom will evaluate this file each time a new window is opened. It is run
// after packages are loaded/activated and after the previous editor state
// has been restored.
////////////////////////////////////////////////////////////////////////////////

// Toggle between light and dark theme.
atom.commands.add('atom-workspace', 'me:toggle-theme', function () {
  const activeThemes = atom.themes.getActiveThemeNames()

  if (activeThemes[0].indexOf('light') > 0) {
    atom.config.set('core.themes', ['nucleus-dark-ui', 'one-dark-syntax'])
  } else {
    atom.config.set('core.themes', ['one-light-ui', 'one-light-syntax'])
  }
})

// Close all panes.
//
// Atom's built-in 'pane:close-other-items' is super handy. But sometimes you
// just really want a completely clean slate.
//
// "Shut down all the [panes] on the detention level! ... Shut them all down.
// Hurry!"
atom.commands.add('atom-workspace', 'me:close-all-panes', () =>
  atom.workspace.getPanes().forEach(pane => pane.destroy())
)

// If the right dock is focused, close it. If the right dock is not focused,
// display the right dock and focus it.
//
// I bind this command a keyboard shortcut so that I can use a single keyboard
// shortcut to go straight to the Git tab from anywhere inside Atom, and then use
// that same keyboard shortcut to close the Git tab when I'm done committing my
// changes.
atom.commands.add('atom-workspace', 'me:focus-or-close-right-dock', function () {
  const workspaceActivePaneItem = atom.workspace.getActivePaneItem()
  const rightDockActivePaneItem = atom.workspace.getRightDock().getActivePaneItem()
  const isRightDockFocused = workspaceActivePaneItem === rightDockActivePaneItem

  if (isRightDockFocused) {
    atom.commands.dispatch(atom.workspace.getElement(), 'window:toggle-right-dock')
  } else {
    atom.workspace.getRightDock().activate()
  }
})

// Save all open buffers, even if they're not modified. This behavior is useful
// when you're using a file watcher to trigger scripts (e.g., using guard to
// run your Ruby tests).
//
// Atom's built-in "window:save-all" command previously provided this behavior,
// but it was removed in https://github.com/atom/atom/pull/9249.
atom.commands.add('atom-workspace', 'me:save-all', () =>
  atom.workspace.getPanes().forEach(pane => pane.getItems().map((item) => pane.saveItem(item)))
)

// Generate ctags.
atom.commands.add('atom-text-editor', 'me:generate-ctags', () => {
  let child
  const sys = require('sys')
  const { exec } = require('child_process')

  const tag_command = `    \
    /usr/local/bin/ctags   \
    --exclude=log          \
    --exclude=node_modules \
    --exclude=tmp          \
    --exclude=vendor       \
    --tag-relative -R      \
    `

  atom.notifications.addInfo('Generating ctags')
  atom.project.getPaths().map((path) =>
    (child = exec(tag_command, {cwd: path}, function (error, stdout, stderr) {
      if (error) {
        atom.notifications.addError('ctags exited with error',
          {detail: error, dismissable: true}
        )
      } else if (stderr) {
        atom.notifications.addWarning('Generated ctags (with warnings)',
          {detail: stderr, dismissable: true}
        )
      } else {
        atom.notifications.addSuccess('Finished generating ctags',
          {detail: stdout}
        )
      }
    })
  ))
})

// Define commands that should only be available in an editor view (and should
// not be available in a tree view, for example).
atom.commands.add('atom-text-editor', {
  // Approximate Vim's "H" motion: Move the cursor to the topmost line that is
  // currently visible.
  'me:move-to-top-visible-line' () {
    const editor = atom.workspace.getActiveTextEditor()
    let topRow = editor.getFirstVisibleScreenRow()
    if (topRow !== 0) { topRow = topRow + 1 }
    editor.setCursorBufferPosition([topRow, 0], {autoscroll: false})
  },

  // Approximate Vim's "M" motion: Move the cursor to the middle line that is
  // currently visible.
  'me:move-to-middle-visible-line' () {
    const editor = atom.workspace.getActiveTextEditor()
    const topRow = editor.getFirstVisibleScreenRow()
    const bottomRow = editor.getLastVisibleScreenRow()
    const middleRow = Math.floor((bottomRow - topRow) / 2) + topRow
    editor.setCursorBufferPosition([middleRow, 0])
  },

  // Approximate Vim's "L" motion: Move the cursor to the bottommost line that
  // is currently visible.
  'me:move-to-bottom-visible-line' () {
    const editor = atom.workspace.getActiveTextEditor()
    let bottomRow = editor.getLastVisibleScreenRow()
    if (bottomRow !== editor.getLastScreenRow()) { bottomRow = bottomRow - 1 }
    editor.setCursorBufferPosition([bottomRow, 0], {autoscroll: false})
  },

  // Approximate Vim's "zt" motion: Scroll the view such that the line containing
  // the cursor is at the top of the view.
  'me:scroll-cursor-to-top' () {
    const textEditor = atom.workspace.getActiveTextEditor()
    const textEditorElement = atom.views.getView(textEditor)
    const cursorPosition = textEditor.getCursorScreenPosition()
    const pixelPositionForCursorPosition =
      textEditorElement.pixelPositionForScreenPosition(cursorPosition)
    textEditorElement.setScrollTop(pixelPositionForCursorPosition.top)
  },

  // Approximate Vim's "zz" motion: Scroll the view such that the line containing
  // the cursor is vertically centered in the view.
  'me:scroll-cursor-to-center' () {
    const textEditor = atom.workspace.getActiveTextEditor()
    const textEditorElement = atom.views.getView(textEditor)
    const cursorPosition = textEditor.getCursorScreenPosition()
    const pixelPositionForCursorPosition =
      textEditorElement.pixelPositionForScreenPosition(cursorPosition)
    const halfScreenHeight = textEditorElement.getHeight() / 2
    const scrollTop = pixelPositionForCursorPosition.top - halfScreenHeight
    textEditorElement.setScrollTop(scrollTop)
  },

  // Approximate Vim's "zb" motion: Scroll the view such that the line containing
  // the cursor is at the bottom of the view.
  'me:scroll-cursor-to-bottom' () {
    const textEditor = atom.workspace.getActiveTextEditor()
    const textEditorElement = atom.views.getView(textEditor)
    const cursorPosition = textEditor.getCursorScreenPosition()
    const scrollBottomPosition = [cursorPosition.row + 1, cursorPosition.column]
    const pixelPositionForScrollBottomPosition =
      textEditorElement.pixelPositionForScreenPosition(scrollBottomPosition)
    textEditorElement.setScrollBottom(pixelPositionForScrollBottomPosition.top)
  },

  // Move the cursor to the next diff in the editor, and then scroll the view
  // such that the line containing the cursor is vertically centered in the view.
  'me:center-next-diff' () {
    const editor = atom.workspace.getActiveTextEditor()
    const editorView = atom.views.getView(editor)
    atom.commands.dispatch(editorView, 'git-diff:move-to-next-diff')
    atom.commands.dispatch(editorView, 'me:scroll-cursor-to-center')
  },

  // Move the cursor to the previous diff in the editor, and then scroll the view
  // such that the line containing the cursor is vertically centered in the view.
  'me:center-previous-diff' () {
    const editor = atom.workspace.getActiveTextEditor()
    const editorView = atom.views.getView(editor)
    atom.commands.dispatch(editorView, 'git-diff:move-to-previous-diff')
    atom.commands.dispatch(editorView, 'me:scroll-cursor-to-center')
  }
})

function focusTracer (event) {
  console.log('window.focus =', event.target)
}

atom.commands.add('atom-workspace', {
  // Log each time focus changes to a new element in Atom's UI.
  'me:trace-focus' (event) {
    window.addEventListener('focusin', focusTracer)
  },

  // Stop logging each time focus changes to a new element in Atom's UI.
  'me:untrace-focus' (event) {
    window.removeEventListener('focusin', focusTracer)
  }
})
