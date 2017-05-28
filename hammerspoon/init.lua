require('keyboard/init') -- Load Hammerspoon bits from https://github.com/jasonrudolph/keyboard

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

-- TODO Consider auto-generating an HTML bookmarks file containing all of URLs
-- that are bound to Hammerspoon functions, so that LaunchBar can automatically
-- add those URLs to its index.
