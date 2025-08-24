io.stdout:setvbuf("no")

-- Nest Initialisation --

love.graphics.setDefaultFilter("nearest")

runningOnPC = true
new3ds = true

require "values"

if love._console == nil then
    print("Running on: PC")

    print("Activating Nest")
    nestScale = 2
    local nest = require("libraries.nest").init({ console = "3ds", scale = nestScale })
    love._nest = true
    love._console_name = "PC"
else
    print("Running on: " .. love._console)
    runningOnPC = false
    love._nest = false
    love._console_name = "3ds"

    local processorCount = love.system.getProcessorCount()

    if processorCount ~= 2 then
        print("Running on: New3DS")
    else
        print("Running on: Old3DS")
        new3ds = false
    end

end

local min_dt = 1/values.settings.frameRate

local shopImage = nil
local shopQuad_Foreground = nil
local shopQuad_Background = nil
local bgm = nil
local next_time = 0
local printTime = 0

local mockupSettingsImage = nil

function love.load() -- Runs once the game has been started

    -- Requiring

    print("Requiring Prerequisites")
    require "textHandler"
    require "saveSystem"
    require "dsInputSystem"

    print("Requiring Main Scripts")
    require "clicker"
    require "menus"
    require "buttons"
    require "topScreen"


    -- Loading

    print("Loading Scripts")

    textHandler:load()
    saveSystem:load()
    dsInputSystem:load(love._nest, nestScale)
    
    clicker:load()
    buttons:load()
    menus:load()
    topScreen:load()

    mockupSettingsImage = love.graphics.newImage("sprites/MockupSettingsLayout.png")



    shopImage = love.graphics.newImage("sprites/Shop.png")
    shopQuad_Foreground = love.graphics.newQuad(0, 0, 320, 40, shopImage:getWidth(), shopImage:getHeight())
    shopQuad_Background = love.graphics.newQuad(0, 40, 320, 240, shopImage:getWidth(), shopImage:getHeight())

    bgm = love.audio.newSource("audio/CubeClickerTheme.ogg", "stream")
    sfx_buy = love.audio.newSource("audio/ChaChing.wav", "static")


    if runningOnPC then
        love.audio.setVolume(0)
    else
        love.audio.setVolume(5)
    end
    bgm:setLooping(true)
    bgm:play()


    updateFrameRate()
    next_time = love.timer.getTime()

    print("all done loading")
end

function love.update(dt) -- Runs once per frame, do calculations here   

    next_time = next_time + min_dt

    dt = math.min(dt, 1/10)

    dsInputSystem:update() -- update input system
    topScreen:update(dt)
    saveSystem:update(dt)

    clicker:update(dt) -- Update Clicker

    menus:update(dt) -- Update Menus

end

local function printInfo(dt)

    printTime = printTime + dt

    if printTime > .2 then
        
        local fps = love.timer.getFPS()
        local stats = love.graphics.getStats()
        print("FPS: " .. fps .. "| drawcalls:" .. stats.drawcalls, "| Texture Memory Used: " .. string.format("%.2f", stats.texturememory / 1000000) .. "MB")
        printTime = 0
    end
    
end


function love.draw(screen) -- Runs once per frame, draw graphics here

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBackgroundColor(.2,.2,.2,1)

    local screenHeight = 240
    
    if screen ~= "bottom" then
        ----- Top Screen -----
        local screenWidth = 400

        -- Get 3D Depth
        local sysDepth = love.graphics.getDepth()
        if screen == "right" then
            sysDepth = -sysDepth
        end

        if not(math.abs(sysDepth) == lastSysDepth) then
            lastSysDepth = sysDepth
        end

        ----- Draw -----
        love.graphics.setColor(1, 1, 1, 1)

        topScreen:draw(sysDepth, screen)
        saveSystem:draw(sysDepth, screen)

    else

        ----- Bottom Screen -----
        local screenWidth = 320
        
        menus:draw()
        


        printInfo(love.timer.getDelta())

        local cur_time = love.timer.getTime()
        if next_time <= cur_time then
            next_time = cur_time
            return
        end
        love.timer.sleep(next_time - cur_time)

    end

end

function love.joystickadded(joystick)
    dsInputSystem:joystickadded(joystick)
end

function love.joystickremoved(joystick)
    dsInputSystem:joystickremoved(joystick)
end

function updateFrameRate()
    min_dt = 1/values.settings.frameRate
end
