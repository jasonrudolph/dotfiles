local log = hs.logger.new('init.lua', 'debug')

function launchOrFocus(appName)
  local app = hs.application.get(appName)
  if app then
    app:activate()
  else
    hs.application.launchOrFocus(appName)
  end
end

function layoutForXcodeDev()
  local frame = hs.screen.mainScreen():frame()

  -- Bring Simulator to front
  local simulator = hs.application.get('Simulator')
  launchOrFocus(simulator:name())

  -- Position Simulator at right of screen
  local simulatorWindow = simulator:mainWindow()
  local simulatorSize = simulatorWindow:size()
  simulatorWindow:move(
    hs.geometry.rect(
      frame.w - simulatorSize.w,
      frame.y,
      simulatorSize.w,
      simulatorSize.h
    )
  )

  -- Bring Xcode to front of screen
  local xcode = hs.application.get('Xcode')
  launchOrFocus(xcode:name())

  -- Position Xcode at left of screen and resize it to take up remaining screen real estate
  local xcodeWindow = xcode:mainWindow()
  local xcodeSize = xcodeWindow:size()
  xcodeWindow:move(
    hs.geometry.rect(
      frame.x,
      frame.y,
      frame.w - simulatorSize.w,
      frame.h
    )
  )
end

hs.hotkey.bind({'shift', 'ctrl', 'alt', 'cmd'}, '1', function()
  layoutForXcodeDev()
end)
