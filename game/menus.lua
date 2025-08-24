menus = {}

menus.currentMenu = "shop"
menus.shopMenu = {}
menus.settingsMenu = {}

menus.settingsMenu.fpsColour_default = {r = 10/255, g = 110/255, b = 40/255}
menus.settingsMenu.fpsColour_selected = {r = 30/255, g = 220/255, b = 80/255}
menus.settingsMenu.deleteSaveDateColour = {r = 240/255, g = 30/255, b = 30/255}

local scroll = {}
scroll.y = 0
scroll.threshold_position = 10
scroll.threshold_time = 1
scroll.min = -290
scroll.max = 0
scroll.friction = 1.2
scroll.velocity = 0
scroll.clamp = 0.25
scroll.active = false
scroll.touch_Timer = 0
scroll.touch_originPositionY = 0

function menus:load()

    self.currentMenu = "shop"

    self.shopMenu.sprite = love.graphics.newImage("sprites/Shop.png")
    local w, h = self.shopMenu.sprite:getDimensions()
    self.shopMenu.quad_foreground = love.graphics.newQuad(0, 0, 320, 40, w, h)
    self.shopMenu.quad_background = love.graphics.newQuad(0, 40, 320, 240, w, h)

    self.settingsMenu.sprite = love.graphics.newImage("sprites/SettingsMenu.png")
    w, h = self.settingsMenu.sprite:getDimensions()
    self.settingsMenu.quad_background = love.graphics.newQuad(1, 1, 320, 240, w, h)
    self.settingsMenu.quad_deleteSaveButton = love.graphics.newQuad(1, 242, 228, 32, w, h)
    self.settingsMenu.quad_fpsButton = love.graphics.newQuad(1, 275, 102, 32, w, h)
    self.settingsMenu.quad_deleteSaveText = love.graphics.newQuad(1, 308, 220, 18, w, h)
    self.settingsMenu.quad_60fpsText = love.graphics.newQuad(1, 327, 94, 18, w, h)
    self.settingsMenu.quad_30fpsText = love.graphics.newQuad(1, 346, 94, 18, w, h)
    self.settingsMenu.quad_15fpsText = love.graphics.newQuad(1, 365, 92, 18, w, h)
    self.settingsMenu.quad_recommendedText = love.graphics.newQuad(1, 384, 104, 9, w, h)

    self.settingsMenu.batch = love.graphics.newSpriteBatch(self.settingsMenu.sprite, 5, "static")
    self.settingsMenu.batch:add(self.settingsMenu.quad_60fpsText, 7, 91)
    self.settingsMenu.batch:add(self.settingsMenu.quad_30fpsText, 113, 91)
    self.settingsMenu.batch:add(self.settingsMenu.quad_15fpsText, 219, 91)
    if new3ds then
        self.settingsMenu.batch:add(self.settingsMenu.quad_recommendedText, 2, 122)
    else
        self.settingsMenu.batch:add(self.settingsMenu.quad_recommendedText, 108, 122)
    end
    self.settingsMenu.batch:add(self.settingsMenu.quad_deleteSaveText, 44, 183)

    buttons.newButton_Shop( -- Shop Item Buttons
        "Item 1",
        0, 1,
        8, 48)
    buttons.newButton_Shop(
        "Item 2",
        0, 2,
        88, 48)
    buttons.newButton_Shop(
        "Item 3",
        0, 3,
        8, 128)
    buttons.newButton_Shop(
        "Item 4",
        0, 4,
        88, 128)
    buttons.newButton_Shop(
        "Item 5",
        0, 5,
        8, 208)
    buttons.newButton_Shop(
        "Item 6",
        0, 6,
        88, 208)
    buttons.newButton_Shop(
        "Item 7",
        0, 7,
        8, 288)
    buttons.newButton_Shop(
        "Item 8",
        0, 8,
        88, 288)
    buttons.newButton_Shop(
        "Item 9",
        0, 9,
        8, 368)
    buttons.newButton_Shop(
        "Item 10",
        0, 10,
        88, 368)
    buttons.newButton_Shop(
        "Item 11",
        0, 11,
        48, 448)

    buttons.newButton_Shop( -- Shop Upgrade Buttons
        "Upgrade 1",
        1, 1,
        168, 48)
    buttons.newButton_Shop(
        "Upgrade 2",
        1, 2,
        248, 48)
    buttons.newButton_Shop(
        "Upgrade 3",
        1, 3,
        168, 128)
    buttons.newButton_Shop(
        "Upgrade 4",
        1, 4,
        248, 128)
    buttons.newButton_Shop(
        "Upgrade 5",
        1, 5,
        168, 208)
    buttons.newButton_Shop(
        "Upgrade 6",
        1, 6,
        248, 208)
    buttons.newButton_Shop(
        "Upgrade 7",
        1, 7,
        168, 288)
    buttons.newButton_Shop(
        "Upgrade 8",
        1, 8,
        248, 288)
    buttons.newButton_Shop(
        "Upgrade 9",
        1, 9,
        168, 368)
    buttons.newButton_Shop(
        "Upgrade 10",
        1, 10,
        248, 368) 
    buttons.newButton_Shop(
        "Upgrade 11",
        1, 11,
        208, 448)

    buttons.newButton_Regular( -- Settings Buttons
        "60 FPS",
        3, 84, 102, 32,
        "settings",
        function ()
            values.settings.frameRate = 60
            updateFrameRate()
        end)
    buttons.newButton_Regular( -- Settings Buttons
        "30 FPS",
        109, 84, 102, 32,
        "settings",
        function ()
            values.settings.frameRate = 30
            updateFrameRate()
        end)
    buttons.newButton_Regular( -- Settings Buttons
        "15 FPS",
        215, 84, 102, 32,
        "settings",
        function ()
            values.settings.frameRate = 15
            updateFrameRate()
        end)
    buttons.newButton_Regular( -- Settings Buttons
        "Delete Save",
        40, 176, 240, 32,
        "settings",
        function ()
            saveSystem:deleteSaveData()
            menus.currentMenu = "shop"
        end)

end

function menus:update(dt)

    -- Shop to Settings switch
    if gamepadpressed("back") then
        if self.currentMenu == "shop" then
            self.currentMenu = "settings"
        else
            self.currentMenu = "shop"
        end
        print(self.currentMenu)
    end



    -- Cache Touch
    local touchPressed = touchpressed()
    local touchReleased = touchreleased()

    local touchDown = touchDown()
    local touch_x, touch_y = touchPosition()
    touch_y = touch_y - scroll.y
    local touch_delta_x, touch_delta_y = touchDeltaPosition()



    -- Touch Timer

    if touchPressed then
        scroll.touch_Timer = 0
        scroll.touch_originPositionY = touch_y
    elseif touchReleased then
        scroll.touch_Timer = 0
    elseif touchDown then
        scroll.touch_Timer = scroll.touch_Timer + dt
    end



    -- Drag Scrolling

    if self.currentMenu == "shop" then

        if (math.abs(touch_y - scroll.touch_originPositionY) > scroll.threshold_position or scroll.touch_Timer > scroll.threshold_time) and not scroll.active then
            scroll.active = true
        end

        if scroll.active then

            if touchDown then

                scroll.y = scroll.y + touch_delta_y

            else

                if touchReleased then
                    scroll.velocity = touch_delta_y
                end

                if scroll.y > scroll.max then
                    scroll.velocity = scroll.velocity - ((scroll.y + scroll.max) / 64)
                elseif scroll.y < scroll.min  then
                    scroll.velocity = scroll.velocity - ((scroll.y - scroll.min) / 64)
                end

                scroll.velocity = scroll.velocity / scroll.friction
                scroll.y = scroll.y + scroll.velocity

                if math.abs(scroll.velocity) < scroll.clamp and scroll.y <= scroll.max and scroll.y >= scroll.min then
                    scroll.velocity = 0
                    scroll.active = false
                end
                
            end

        end
    
    else
        scroll.velocity = 0
    end

    

    buttons:update(dt, scroll.y, self.currentMenu)

    



end



local function drawShopMenu()

    -- Draw Background
    love.graphics.draw(menus.shopMenu.sprite, menus.shopMenu.quad_background)

    -- Draw Shop Buttons
    buttons:draw(scroll.y)

    -- Draw Shop Foreground
    if menus.currentMenu == "shop" then
        love.graphics.draw(menus.shopMenu.sprite, menus.shopMenu.quad_foreground, 0, 0)
    end
end

local function frameRateButtonColour(frameRate)
    local clr = {r = 1, g = 1, b = 1}

    if values.settings.frameRate == frameRate then
        clr.r = menus.settingsMenu.fpsColour_selected.r
        clr.g = menus.settingsMenu.fpsColour_selected.g
        clr.b = menus.settingsMenu.fpsColour_selected.b
    else
        clr.r = menus.settingsMenu.fpsColour_default.r
        clr.g = menus.settingsMenu.fpsColour_default.g
        clr.b = menus.settingsMenu.fpsColour_default.b
    end

    return clr
end

local function drawSettingsMenu()

    -- Draw Background
    love.graphics.draw(menus.settingsMenu.sprite, menus.settingsMenu.quad_background)

    local currentColour = {}

    currentColour = frameRateButtonColour(60)
    love.graphics.setColor(currentColour.r, currentColour.g, currentColour.b, 1) 
    love.graphics.draw(menus.settingsMenu.sprite, menus.settingsMenu.quad_fpsButton, 3, 84)

    currentColour = frameRateButtonColour(30)
    love.graphics.setColor(currentColour.r, currentColour.g, currentColour.b, 1) 
    love.graphics.draw(menus.settingsMenu.sprite, menus.settingsMenu.quad_fpsButton, 109, 84)

    currentColour = frameRateButtonColour(15)
    love.graphics.setColor(currentColour.r, currentColour.g, currentColour.b, 1) 
    love.graphics.draw(menus.settingsMenu.sprite, menus.settingsMenu.quad_fpsButton, 215, 84)

    currentColour = menus.settingsMenu.deleteSaveDateColour
    love.graphics.setColor(currentColour.r, currentColour.g, currentColour.b, 1) 
    love.graphics.draw(menus.settingsMenu.sprite, menus.settingsMenu.quad_deleteSaveButton, 40, 176)

    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(menus.settingsMenu.batch)


end



function menus:draw()

    local window_width = 320
    local window_height = 240

    if menus.currentMenu == "shop" then
        drawShopMenu()
    elseif menus.currentMenu == "settings" then
        drawSettingsMenu()
    end

end
