local laptopDisplay = 'Color LCD'
local thunderboltDisplay = 'Thunderbolt Display'
hs.layout.left40 = { x = 0, y = 0, w = 0.4, h = 1 }
hs.layout.right60 = { x = 0.4, y = 0, w = 0.6, h = 1 }
local windowLayout = {
  { 'Atom',          nil, thunderboltDisplay, hs.layout.right60,   nil, nil },

  { 'Slack',         nil, thunderboltDisplay, hs.layout.left40,    nil, nil },
  { 'Google Chrome', nil, thunderboltDisplay, hs.layout.left40,    nil, nil },
  { 'iTerm2',        nil, thunderboltDisplay, hs.layout.left40,    nil, nil },
  { 'Slack',         nil, thunderboltDisplay, hs.layout.left40,    nil, nil },

  { 'Sonos',         nil, laptopDisplay,      hs.layout.maximized, nil, nil },
}
hs.hotkey.bind({'shift', 'ctrl', 'alt', 'cmd'}, '1', function()
  hs.layout.apply(windowLayout)
end)
