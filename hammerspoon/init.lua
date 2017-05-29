require('keyboard') -- Load Hammerspoon bits from https://github.com/jasonrudolph/keyboard

--------------------------------------------------------------------------------
-- Display a reminder every 15 minutes encouraging excellent posture.
--------------------------------------------------------------------------------
function showPostureReminder()
  local focusedWindow = hs.window.focusedWindow()

  -- Display the reminder in a way that is hard to ignore and requires
  -- acknowledgement.
  --
  -- In *most* cases, when I generate a notification via Hammerspoon, I want the
  -- notification to be unobtrusive, so I use hs.notify. In this case, I want
  -- the notification front and center, so I'm resorting to an AppleScript-
  -- generated alert.
  local applescript = [[
    display alert "Adjust Posture"¬
      message "Seriously. It's for your own good, man. 😅"¬
      buttons ["OK. My posture is excellent now! 👌"]¬
      giving up after 60
  ]]
  hs.osascript.applescript(applescript)

  focusedWindow:focus()
end
postureReminderTimer = hs.timer.doAt('00:00', '15m', showPostureReminder)

--------------------------------------------------------------------------------
-- Bind URL for toggling the Wi-Fi on/off.
--
--   hammerspoon://toggle-wifi
--------------------------------------------------------------------------------
function toggleWiFI()
  local isOn = hs.wifi.interfaceDetails('en0')['power']
  hs.wifi.setPower(not isOn)
end
hs.urlevent.bind("toggle-wifi", toggleWiFI)

--------------------------------------------------------------------------------
-- Bind URL for toggling the macOS "Do Not Disturb" setting:
--
--   hammerspoon://toggle-do-not-disturb
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
hs.urlevent.bind("toggle-do-not-disturb", toggleDoNotDisturb)

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
--- Fetch a collection of all running applications that have windows.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A table where each key is a string application name and the value is the
--     corresponding hs.application object.
--------------------------------------------------------------------------------
function appsWithWindows()
  local apps = hs.fnutils.map(hs.window.allWindows(), function(window)
    return window:application()
  end)

  local namesToApps = {}
  for _, app in ipairs(apps) do
    if (not namesToApps[app]) then
      namesToApps[app:name()] = app
    end
  end

  return namesToApps
end

--------------------------------------------------------------------------------
--- Function
--- Kill all running applications that are not whitelisted for screen sharing.
--------------------------------------------------------------------------------
function killAppsNotWhitelistedForScreenSharing()
  local APPS_WHITELISTED_FOR_SCREEN_SHARING_MODE = {
    'Atom',
    'Bartender 2',
    'Dash',
    'Dashboard',
    'Google Chrome',
    'Hackable Slack Client',
    'Hammerspoon',
    'LaunchBar',
    'iTerm2',
    'Screenhero',
  }

  local appsToKill = hs.fnutils.filter(appsWithWindows(), function(app)
    local isAppWhitelisted =
      hs.fnutils.contains(APPS_WHITELISTED_FOR_SCREEN_SHARING_MODE, app:name())

    return (not isAppWhitelisted)
  end)

  hs.fnutils.each(appsToKill, function(app)
    app:kill()
  end)
end

--------------------------------------------------------------------------------
-- Bind URL for toggling screen sharing mode:
--
--   hammerspoon://toggle-screen-sharing-mode
--
-- Entering screen sharing mode attempts to do away with all those pesky things
-- you'd rather not transmit to your coworkers: the Skype chat you've been
-- having with the recruiter from Microsoft, iMessage notifications from your
-- mom sending you pictures of her neighbor's new cat, and so on.
--
-- When you're done sharing your screen, just toggle screen sharing mode off,
-- re-open Messages.app, and remind Mom for the bajillionth time that you're a
-- dog person.
--------------------------------------------------------------------------------
function toggleScreenSharingMode()
  -- Use "Do Not Disturb" mode to determine whether we're in screen sharing mode
  if isDoNotDisturbEnabled() then
    postureReminderTimer:start()

    hs.alert('Say goodbye to screen sharing mode 👋')
  else
    postureReminderTimer:stop()
    killAppsNotWhitelistedForScreenSharing()
    toggleDoNotDisturb()

    hs.alert("It's probably safe to share your screen now. Just don't do anything stupid, OK? 😇")
  end
end
hs.urlevent.bind("toggle-screen-sharing-mode", toggleScreenSharingMode)

-- TODO Consider auto-generating an HTML bookmarks file containing all of URLs
-- that are bound to Hammerspoon functions, so that LaunchBar can automatically
-- add those URLs to its index.
