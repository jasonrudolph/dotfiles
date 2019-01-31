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
--- Depends on https://github.com/sindresorhus/do-not-disturb-cli being
--- installed on the system.
---
--- Parameters:
---  * None
---
--- Returns:
---  * Nothing
--------------------------------------------------------------------------------
function toggleDoNotDisturb()
  local _, status, exit, code = hs.execute('/usr/local/bin/do-not-disturb toggle', true)

  if (not (status == true and exit == 'exit' and code == 0)) then
    hs.alert("Whoops! Toggling 'Do Not Disturb' failed.")

    local alertDurationInSeconds = 4
    hs.alert(
      "Make sure you have sindresorhus/do-not-disturb-cli installed and try again.",
      hs.alert.defaultStyle,
      hs.screen.mainScreen(),
      alertDurationInSeconds
    )
  end
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
