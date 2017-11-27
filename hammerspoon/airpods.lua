--------------------------------------------------------------------------------
-- Display AirPods battery charge in the macOS menubar.
--------------------------------------------------------------------------------

-- TODO Style menu bar item nicely
-- TODO Detect when airpods connect/disconnect so that we can immediately refresh the menubar

function getAirpodsBatteryInfo(callback)
  -- TODO Dynamically determine path based on pwd
  local airpodsCLIPath = '~/.hammerspoon/vendor/AirPodsBatteryCLI/AirPodsPower.sh'

  hs.task.new(airpodsCLIPath, function(exitCode, stdOut, stdErr)
    local parts = hs.fnutils.split(stdOut, ' ')
    local leftAirpodBatteryPercentage = parts[7]
    local rightAirpodBatteryPercentage = parts[9]

    local toNumberOrNull = function(percentageString)
      if not percentageString then
        return null
      else
        local digitsOnly = string.gsub(percentageString, '[^%d]', '')
        return tonumber(digitsOnly)
      end
    end

    callback({
      left = toNumberOrNull(leftAirpodBatteryPercentage),
      right = toNumberOrNull(rightAirpodBatteryPercentage)
    })
  end):start()
end

airpodsBatteryMenubarItem = hs.menubar.new()

function updateMenubar()
  getAirpodsBatteryInfo(function(batteryInfo)
    local left = batteryInfo['left'] or '-'
    local right = batteryInfo['right'] or '-'

    airpodsBatteryMenubarItem:setTitle(left .. '/' .. right)
  end)
end

updateMenubar()

airpodsBatteryCheckTimer = hs.timer.doEvery(30, function()
  updateMenubar()
end)
