--------------------------------------------------------------------------------
-- Display a reminder every 15 minutes encouraging excellent posture.
--------------------------------------------------------------------------------
function showPostureReminder()
  if isScreenSharingModeEnabled() then return end

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
postureReminderTimer = hs.timer.doAt('00:00', '30m', showPostureReminder)
