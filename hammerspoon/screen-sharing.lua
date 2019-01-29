require('do-not-disturb')

-- If an app has windows, and the app is not in this list, entering screen
-- sharing mode will quit that app.
WINDOWED_APPS_WHITELISTED_FOR_SCREEN_SHARING_MODE = {
  'Atom',
  'Atom Beta',
  'Atom Nightly',
  'Bartender 3',
  'Code',
  'Dash',
  'Dashboard',
  'Google Chrome',
  'Hackable Slack Client',
  'Hammerspoon',
  'LaunchBar',
  'iTerm2',
  'Screenhero',
  'Slack',
  'Zoom',
}

-- Apps to kill when entering screen sharing mode and to reopen when exiting
-- screen sharing mode.
ESSENTIAL_APPS_ONLY_FOR_NON_SCREEN_SHARING_MODE = {
}

-- At startup, use "Do Not Disturb" mode to determine whether we're in screen
-- sharing mode
_isScreenSharingModeEnabled = isDoNotDisturbEnabled()

--------------------------------------------------------------------------------
--- Function
--- Determine whether screen sharing mode is enabled.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A boolean value indicating whether screen sharing mode is enabled.
--------------------------------------------------------------------------------
function isScreenSharingModeEnabled()
  return _isScreenSharingModeEnabled
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

function killAppsNotWhitelistedForScreenSharing()
  local appsToKill = hs.fnutils.filter(appsWithWindows(), function(app)
    local isAppWhitelisted =
      hs.fnutils.contains(WINDOWED_APPS_WHITELISTED_FOR_SCREEN_SHARING_MODE, app:name())

    return (not isAppWhitelisted)
  end)

  hs.fnutils.each(appsToKill, function(app)
    app:kill()
  end)
end

function killAppsExclusiveToNonScreenSharingMode()
  local appsToKill = hs.fnutils.filter(hs.application.runningApplications(), function(app)
    return hs.fnutils.contains(ESSENTIAL_APPS_ONLY_FOR_NON_SCREEN_SHARING_MODE, app:name())
  end)

  hs.fnutils.each(appsToKill, function(app)
    app:kill()
  end)
end

function openAppsExclusiveToNonScreenSharingMode()
  hs.fnutils.each(ESSENTIAL_APPS_ONLY_FOR_NON_SCREEN_SHARING_MODE, function(app)
    hs.application.open(app)
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
  if _isScreenSharingModeEnabled then
    openAppsExclusiveToNonScreenSharingMode()
    setDoNotDisturb(false)

    hs.alert('Say goodbye to screen sharing mode 👋')
  else
    killAppsExclusiveToNonScreenSharingMode()
    killAppsNotWhitelistedForScreenSharing()
    setDoNotDisturb(true)

    hs.alert("It's probably safe to share your screen now. Just don't do anything stupid, OK? 😇")
  end

  _isScreenSharingModeEnabled = (not _isScreenSharingModeEnabled)
end
hs.urlevent.bind("toggle-screen-sharing-mode", toggleScreenSharingMode)
