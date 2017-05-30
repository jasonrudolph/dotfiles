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
