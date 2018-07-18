local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local function gotoGame()
    composer.gotoScene("game", { time = 800, effect = "flipFadeOutIn" })
 end

local function RGB( value ) -- Convert windows RGB to corona RGB
    return value / 255
end

 local musicTrack
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.setDefault("background", RGB(41),RGB(93),RGB(178))

    local title = display.newText(sceneGroup, "Cookie Clicker", display.contentCenterX, display.contentCenterY - 350, native.systemFont, 90 )

    local cookie = display.newImageRect(sceneGroup, "images/cookie.png", 300, 300)
    cookie.x = display.contentCenterX - 50
    cookie.y = display.contentCenterY - 100

    local cursor = display.newImageRect(sceneGroup, "images/cursorlogo.png", 300, 300)
    cursor.x = display.contentCenterX + 130
    cursor.y = display.contentCenterY

    local playButton = display.newText(sceneGroup, "Play", display.contentCenterX, 800, native.systemFont, 44 )
    
    playButton:addEventListener( "tap", gotoGame )

    musicTrack = audio.loadStream("audio/Patakas_World.wav")
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        audio.play(musicTrack, { channel = 1 , loops = -1 }) -- Start the music!
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        audio.stop( 1 ) -- Stop the music
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    audio.dispose(musicTrack)
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene