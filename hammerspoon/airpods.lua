--------------------------------------------------------------------------------
-- Display AirPods battery charge in the macOS menubar.
--------------------------------------------------------------------------------

local log = hs.logger.new('airpods.lua', 'debug')

-- TODO Detect when airpods connect/disconnect so that we can immediately refresh the menubar

airpodsBatteryMenubarItem = hs.menubar.new()

local log = hs.logger.new('airpods.lua', 'debug')

function updateMenubar()
  local batteryInfoForConnectedDevices = hs.battery.privateBluetoothBatteryInfo()

  local airpodsBatteryInfo = hs.fnutils.find(batteryInfoForConnectedDevices, function(element)
    return element['productID'] == '8207'
  end)

  left = '-'
  right = '-'
  if not (airpodsBatteryInfo == nil) then
    if airpodsBatteryInfo['batteryPercentLeft'] then left = airpodsBatteryInfo['batteryPercentLeft'] end
    if airpodsBatteryInfo['batteryPercentRight'] then right = airpodsBatteryInfo['batteryPercentRight'] end
  end

  airpodsBatteryMenubarItem:setTitle(left .. '/' .. right)
end

updateMenubar()

airpodsBatteryCheckTimer = hs.timer.doEvery(15, function()
  updateMenubar()
end)
