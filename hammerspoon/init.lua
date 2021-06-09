require('keyboard') -- Load Hammerspoon bits from https://github.com/jasonrudolph/keyboard

-- Make Hammerspoon accessible via the command line
-- http://www.hammerspoon.org/docs/hs.ipc.html
require("hs.ipc")

--------------------------------------------------------------------------------
-- Load Hammerspoon bits from https://github.com/jasonrudolph/dotfiles
--------------------------------------------------------------------------------
require('airpods')
require('do-not-disturb')
require('night-shift')
require('layout')
require('screen-sharing')
require('wifi')

-- TODO Consider auto-generating an HTML bookmarks file containing all of URLs
-- that are bound to Hammerspoon functions, so that LaunchBar can automatically
-- add those URLs to its index.
