--------------------------------------------------------------------------------
--- Function
--- Toggle Night Shift.
---
--- Depends on https://github.com/smudge/nightlight being installed on the
--- system. To install via homebrew, run:
---
---   $ brew install smudge/smudge/nightlight
---
--- Parameters:
---  * None
---
--- Returns:
---  * Nothing
--------------------------------------------------------------------------------
function toggleNightShift()
  local _, status, exit, code = hs.execute('/usr/local/bin/nightlight toggle')

  if (not (status == true and exit == 'exit' and code == 0)) then
    hs.alert("Whoops! Toggling Night failed.")

    local alertDurationInSeconds = 4
    hs.alert(
      "Make sure you have smudge/nightlight installed and try again.",
      hs.alert.defaultStyle,
      hs.screen.mainScreen(),
      alertDurationInSeconds
    )
  end
end

--------------------------------------------------------------------------------
-- Bind URL for toggling the macOS Night Shift setting:
--
--   hammerspoon://toggle-night-shift
--------------------------------------------------------------------------------
hs.urlevent.bind("toggle-night-shift", toggleNightShift)
