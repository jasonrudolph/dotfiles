--------------------------------------------------------------------------------
--- Function
--- Determine whether "Do Not Disturb" is enabled.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A boolean value indicating whether "Do Not Disturb" is enabled.
--------------------------------------------------------------------------------
function isDoNotDisturbEnabled()
  local command =
    'defaults -currentHost read com.apple.notificationcenterui doNotDisturb'

  mode, _, _, _ = hs.execute(command)

  return tonumber(mode) == 1
end

--------------------------------------------------------------------------------
--- Function
--- Toggle "Do Not Disturb".
---
--- Parameters:
---  * None
---
--- Returns:
---  * Nothing
--------------------------------------------------------------------------------
function toggleDoNotDisturb()
  local applescript = [[
    tell application "System Events" to tell process "SystemUIServer"
    	key down option
    	click menu bar item 1 of menu bar 1
    	key up option
    end tell
  ]]

  hs.osascript.applescript(applescript)
end

--------------------------------------------------------------------------------
-- Bind URL for toggling the macOS "Do Not Disturb" setting:
--
--   hammerspoon://toggle-do-not-disturb
--------------------------------------------------------------------------------
hs.urlevent.bind("toggle-do-not-disturb", toggleDoNotDisturb)

--------------------------------------------------------------------------------
--- Function
--- Set "Do Not Disturb" state.
---
--- Parameters:
---  * state - A boolean value. True to enable "Do Not Disturb"; False to
---    disable it
---
--- Returns:
---  * Nothing
--------------------------------------------------------------------------------
function setDoNotDisturb(state)
  if state ~= isDoNotDisturbEnabled() then
    toggleDoNotDisturb()
  end
end
