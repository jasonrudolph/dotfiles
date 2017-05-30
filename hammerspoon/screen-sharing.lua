require('do-not-disturb')
require('posture-reminder')

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
    toggleDoNotDisturb()

    hs.alert('Say goodbye to screen sharing mode 👋')
  else
    postureReminderTimer:stop()
    killAppsNotWhitelistedForScreenSharing()
    toggleDoNotDisturb()

    hs.alert("It's probably safe to share your screen now. Just don't do anything stupid, OK? 😇")
  end
end
hs.urlevent.bind("toggle-screen-sharing-mode", toggleScreenSharingMode)
