local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local json = require( "json" )

local filePath = system.pathForFile("cookieData.json", system.DocumentsDirectory)

local cookies
local cursorText
local cursorNumText
local abueText
local abueNumText

local data = {}
local inventary = {}
local production = {1, 2}
local price = {}

local cookiesText
 
-- Set up display groups
local backGroup  -- Background group
local mainGroup  -- Principal group
local uiGroup    -- Information group
 
local musicTrack

local function loadData()
    local file = io.open( filePath, "r")

    if (file) then
        local contents = file:read("*a") 
        io.close(file)
        data = json.decode(contents);
    end

    if (data == nil and #data == 0) then
        data = { 
            ["inventary"]={
                0, -- "cursor"
                0  -- "grandma"
            },
            ["price"]={
                100, -- "cursor"
                200  -- "grandma"
            },
            ["cookies"] = {
                0
            }
        }
    end

    cookies = data.cookies[1];

    table.insert(inventary, data.inventary[1])
    table.insert(inventary, data.inventary[2])

    table.insert(price, data.price[1])
    table.insert(price, data.price[2])

end

local function saveData()

    data.cookies[1] = cookies

    data.inventary[1] = inventary[1]
    data.inventary[2] = inventary[2]

    data.price[1] = price[1]
    data.price[2] = price[2]

    local file = io.open( filePath, "w")

    if (file) then
        file:write(json.encode(data))
        io.close(file)
    end
end

local function tapCookie()
    cookies = cookies + 1
    cookiesText.text = "Cookies: "..cookies
end

local function buyCursor()
    if (cookies >= price[1]) then
        inventary[1] = inventary[1] + 1
        cookies = cookies - price[1]
        price[1] = price[1] + 50
        cursorText.text = price[1]
        cursorNumText.text = inventary[1]
    else
        alert = native.showAlert( "Cookie Clicker", "No tienes suficientes galletas. 😢 ", { "OK" })
    end
end

local function buyGrandma()
    if (cookies >= price[2]) then
        inventary[2] = inventary[2] + 1
        cookies = cookies - price[2]
        price[2] = price[2] + 100
        abueText.text = price[2]
        abueNumText.text = inventary[2]
    else
        alert = native.showAlert( "Cookie Clicker", "No tienes suficientes galletas. 😢 ", { "OK" })
    end
end

local function produce()
    for cont = 1, #inventary do
        cookies = cookies + inventary[cont]*production[cont]
    end

    cookiesText.text = "Cookies: "..cookies
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    loadData()

    backGroup = display.newGroup()
    sceneGroup:insert(backGroup)

    mainGroup = display.newGroup()
    sceneGroup:insert(mainGroup)

    uiGroup = display.newGroup()
    sceneGroup:insert(uiGroup)

    local background = display.newImageRect(backGroup, "images/MYHGC1.jpg", 800, 1400)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    cookie = display.newImageRect(mainGroup, "images/cookie.png", 400, 400)
    cookie.x = display.contentCenterX
    cookie.y = display.contentCenterY - 150

    cookiesText = display.newText(uiGroup, "Cookies: "..cookies, 400, 100, native.systemFont, 40)
    cookiesText:setFillColor( 0, 0, 0 )

    local cursorButton = display.newImageRect(mainGroup, "images/cursor.jpg", 250, 250)
    cursorButton.x = display.contentWidth - 520
    cursorButton.y = display.contentHeight - 200

    cursorText = display.newText(uiGroup, price[1], display.contentWidth - 510, display.contentHeight - 120, native.systemFont, 45)
    cursorText:setFillColor( 1, 1, 1 )

    cursorNumText = display.newText(uiGroup, inventary[1], display.contentWidth - 480, display.contentHeight - 250, native.systemFont, 60)
    cursorNumText:setFillColor( 1, 1, 1 )

    local abueButton = display.newImageRect(mainGroup, "images/grandma.jpg", 250, 250)
    abueButton.x = display.contentWidth - 250
    abueButton.y = display.contentHeight - 200

    abueText = display.newText(uiGroup, price[2], display.contentWidth - 240, display.contentHeight - 120, native.systemFont, 45)
    abueText:setFillColor( 1, 1, 1 )

    abueNumText = display.newText(uiGroup, inventary[2], display.contentWidth - 210, display.contentHeight - 250, native.systemFont, 60)
    abueNumText:setFillColor( 1, 1, 1 )

    cookie:addEventListener("tap", tapCookie)
    cursorButton:addEventListener("tap", buyCursor)
    abueButton:addEventListener("tap", buyGrandma)

    musicTrack = audio.loadStream("audio/Pim_Poy_Pocket.wav")
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        gameLoopTimer = timer.performWithDelay( 1000, produce, 0 )
        saveDataTimer = timer.performWithDelay( 60000, saveData, 0 )
        audio.play( musicTrack, { channel=1, loops=-1 } )
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
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
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