-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require("composer") -- load all of the information about the Composer scene

audio.reserveChannels( 1 ) -- Reserve channel 1 for background music

audio.setVolume( 0.5, { channel=1 } ) -- Reduce the overall volume of the channel

composer.gotoScene("menu") -- Go to the menu screen