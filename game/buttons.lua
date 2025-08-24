buttons = {}

local allButtons = {} -- list of all the buttons

local buttonTypes = {}
buttonTypes.regular = 0 -- custom button that appears in whatever scene it needs to and runs a function when pressed while hot
buttonTypes.shop = 1 -- button that only appears in the shop and is set to an item or upgrade which allows it to change colour and buy said item or upgrade when the player has enough money

local buttonValues = {}

buttonValues.shop_size = 64 -- size of shop buttons

buttonValues.image = {} -- populate the image values
buttonValues.image.regular = nil
buttonValues.image.shop = nil

buttonValues.quads = {}
buttonValues.quads.items = {}
buttonValues.quads.upgrades = {}

buttonValues.colours = {} -- setup the colours
buttonValues.colours.shop_items_active = {R = 1, G = 0, B = 0}
buttonValues.colours.shop_items_hot = {R = 240/255, G = 90/255, B = 80/255}
buttonValues.colours.shop_items_inactive = {R = 50/255, G = 20/255, B = 20/255}
buttonValues.colours.shop_upgrades_active = {R = 0, G = 0, B = 1}
buttonValues.colours.shop_upgrades_hot = {R = 40/255, G = 100/255, B = 1}
buttonValues.colours.shop_upgrades_inactive = {R = 30/255, G = 64/255, B = 70/255}

local batchesPopulated = false

local buttonBatch = {}

local selectedIcon = {}

selectedIcon.quad = nil
selectedIcon.batch = nil
selectedIcon.currentX = -320
selectedIcon.currentY = 120
selectedIcon.draw = false





function buttons.newButton_Regular(name, x, y, width, height, screen, func)
    table.insert( allButtons, {

        name = name,
        buttonType = buttonTypes.regular, -- regular button
        x = x, -- position x
        y = y, -- position y
        screen = screen, -- screen button is displayed on
        enabled = true, -- if the button is clickable
        hot = false, -- if button has been touched once/hovered over
        width = width, -- width of button
        height = height, -- height of button
        func = func -- button's custom function

    })
end



function buttons.newButton_Shop(name, shopType, itemID, x, y)
    table.insert( allButtons, {

        name = name,
        buttonType = buttonTypes.shop, -- shop button
        shopType = shopType, -- 0 = items, 1 = upgrades
        itemID = itemID, -- id of item or upgrade
        x = x, -- position x
        y = y, -- position y
        screen = "shop", -- screen button is displayed on
        enabled = false, -- if the button is clickable
        hot = false, -- if button has been touched once/hovered over
        textBatch = textHandler:createTextBatch(10, "dynamic")

    })
    
end

function buttons:PopulateBatches()

    ----- Icons ------

    buttonBatch.shop:clear()

    for i, button in ipairs(allButtons) do

        if button.buttonType == buttonTypes.regular then
            
        elseif button.buttonType == buttonTypes.shop then -- Populate shop batch with icons and text. Not the base buttons because LovePotion 3.0.1 does not support changing the colours of batches.

            if button.shopType == 0 then
                quad = buttonValues.quads.items[button.itemID]
                textHandler:updateTextBatch(button.textBatch, {
                    textHandler:textSet("$" .. textHandler:numberToReadableText(values.items[button.itemID].price, false, true), button.x + 32, button.y + 51, 1, -1, 1),
                    textHandler:textSet("+" .. textHandler:numberToReadableText(values.items[button.itemID].power, false, true), button.x + 32, button.y + 61, 1, -1, 1),
                    textHandler:textSet(textHandler:numberToReadableText(values.items[button.itemID].count, false, true), button.x + 3, button.y + 12, 1, -1, 0)}
                )
            elseif button.shopType == 1 then
                quad = buttonValues.quads.upgrades[button.itemID]
                textHandler:updateTextBatch(button.textBatch, {
                    textHandler:textSet("$" .. textHandler:numberToReadableText(values.upgrades[button.itemID].price, false, true), button.x + 32, button.y + 51, 1, -1, 1),
                    textHandler:textSet("+" .. textHandler:numberToReadableText(values.upgrades[button.itemID].power, false, true), button.x + 32, button.y + 61, 1, -1, 1),
                    textHandler:textSet(textHandler:numberToReadableText(values.upgrades[button.itemID].count, false, true), button.x + 3, button.y + 12, 1, -1, 0)}
                )
            end

            buttonBatch.shop:add(quad, button.x + 2, (button.y + 2))
            
        end
        
    end

end

function buttons:load()

    -- Load shop image
    buttonValues.image.shop = love.graphics.newImage("sprites/Buttons_Shop.png")
    local width = buttonValues.image.shop:getWidth()
    local height = buttonValues.image.shop:getHeight()

    -- Setup shop quads
    buttonValues.quads.button = love.graphics.newQuad(183, 156, 64, 64, width, height) -- quad of button

    table.insert(buttonValues.quads.items, love.graphics.newQuad(0, 0, 60, 38, width, height)) -- quad of item 1
    table.insert(buttonValues.quads.items, love.graphics.newQuad(61, 0, 60, 38, width, height)) -- quad of item 2
    table.insert(buttonValues.quads.items, love.graphics.newQuad(122, 0, 60, 38, width, height)) -- quad of item 3
    table.insert(buttonValues.quads.items, love.graphics.newQuad(183, 0, 60, 38, width, height)) -- quad of item 4
    table.insert(buttonValues.quads.items, love.graphics.newQuad(0, 39, 60, 38, width, height)) -- quad of item 5
    table.insert(buttonValues.quads.items, love.graphics.newQuad(61, 39, 60, 38, width, height)) -- quad of item 6
    table.insert(buttonValues.quads.items, love.graphics.newQuad(122, 39, 60, 38, width, height)) -- quad of item 7
    table.insert(buttonValues.quads.items, love.graphics.newQuad(183, 39, 60, 38, width, height)) -- quad of item 8
    table.insert(buttonValues.quads.items, love.graphics.newQuad(0, 78, 60, 38, width, height)) -- quad of item 9
    table.insert(buttonValues.quads.items, love.graphics.newQuad(61, 78, 60, 38, width, height)) -- quad of item 10
    table.insert(buttonValues.quads.items, love.graphics.newQuad(122, 78, 60, 38, width, height)) -- quad of item 11

    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(183, 78, 60, 38, width, height)) -- quad of upgrade 1
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(0, 117, 60, 38, width, height)) -- quad of upgrade 2
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(61, 117, 60, 38, width, height)) -- quad of upgrade 3
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(122, 117, 60, 38, width, height)) -- quad of upgrade 4
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(183, 117, 60, 38, width, height)) -- quad of upgrade 5
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(0, 156, 60, 38, width, height)) -- quad of upgrade 6
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(61, 156, 60, 38, width, height)) -- quad of upgrade 7
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(122, 156, 60, 38, width, height)) -- quad of upgrade 8
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(0, 195, 60, 38, width, height)) -- quad of upgrade 9
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(61, 195, 60, 38, width, height)) -- quad of upgrade 10
    table.insert(buttonValues.quads.upgrades, love.graphics.newQuad(122, 195, 60, 38, width, height)) -- quad of upgrade 11

    buttonBatch.shop = love.graphics.newSpriteBatch(buttonValues.image.shop, 20, "stream")

    selectedIcon.quad = love.graphics.newQuad(183, 221, 16, 16, width, height)

    selectedIcon.batch = love.graphics.newSpriteBatch(buttonValues.image.shop, 8, "dynamic")
    selectedIcon.batch:add(selectedIcon.quad, -5, -5)
    selectedIcon.batch:add(selectedIcon.quad, 69, -5, 1.5708)
    selectedIcon.batch:add(selectedIcon.quad, 69, 69, 3.14159)
    selectedIcon.batch:add(selectedIcon.quad, -5, 69, 4.71239)






end



function buttons:update(dt, yOffset, screen)

    -- getting touch values

    local touchPressed = touchpressed()
    local touchReleased = touchreleased()
    local touchDown = touchDown()
    local touch_x, touch_y = touchPosition()

    if screen == "shop" then
        touch_y = touch_y - yOffset -- offsetting touchY by the scroll of the shop if the shop is active
    end
    

    -- do button logic
    local anyButtonHot = false

    for i, button in ipairs(allButtons) do

        if button.screen == menus.currentMenu then

            if button.shopType == 0 then

                button.enabled = values.stats.money >= values.items[button.itemID].price
                if not button.enabled and button.hot then
                    button.hot = false
                end

            elseif button.shopType == 1 then
                
                button.enabled = values.stats.money >= values.upgrades[button.itemID].price
                if not button.enabled and button.hot then
                    button.hot = false
                end

            end

            if button.buttonType == buttonTypes.regular or button.buttonType == buttonTypes.shop then
                
                local previousHot = button.hot

                if touchPressed then

                    if button.buttonType == buttonTypes.regular and screen == "settings" then
                        if touch_x > button.x and touch_x < button.x + button.width and touch_y > button.y and touch_y < button.y + button.height then
                            button.func()
                        end

                    elseif button.buttonType == buttonTypes.shop and screen == "shop" then

                        button.hot = touch_x > button.x and touch_x < button.x + buttonValues.shop_size and touch_y > button.y and touch_y < button.y + buttonValues.shop_size
                        if button.hot and button.enabled then
                            anyButtonHot = true
                            selectedIcon.draw = true
                        end

                        if button.hot and previousHot then

                            values.shop_buy(button.shopType, button.itemID, false)
                            self:PopulateBatches()
                        
                        end
                    end
                    
                    
                end
            end

        end

    end

    if touchPressed and (anyButtonHot == false) then
        selectedIcon.draw = false
    end

    if not batchesPopulated then
        self:PopulateBatches()
        batchesPopulated = true
    end

end



function buttons:draw(yOffset)


    if menus.currentMenu == "shop" then

        for i, button in ipairs(allButtons) do
            
            if button.screen == menus.currentMenu then

                local globalPosition = (button.y + yOffset)

                if globalPosition < 240 and globalPosition > -64 then

                    if button.buttonType == buttonTypes.shop then -- Base Buttons

                        -- get colour of this button
                        local colour = buttonValues.colours.shop_items_active
                        if button.shopType == 0 then
                            if not button.enabled then
                                colour = buttonValues.colours.shop_items_inactive
                            elseif button.hot then
                                colour = buttonValues.colours.shop_items_hot
                                selectedIcon.currentX = button.x
                                selectedIcon.currentY = button.y
                            else
                                colour = buttonValues.colours.shop_items_active
                            end
                        elseif button.shopType == 1 then
                            if not button.enabled then
                                colour = buttonValues.colours.shop_upgrades_inactive
                            elseif button.hot then
                                colour = buttonValues.colours.shop_upgrades_hot
                                selectedIcon.currentX = button.x
                                selectedIcon.currentY = button.y
                            else
                                colour = buttonValues.colours.shop_upgrades_active
                            end
                        end

                        -- set colour of this button then draw
                        love.graphics.setColor(colour.R, colour.G, colour.B, 1)
                        love.graphics.draw(buttonValues.image.shop, buttonValues.quads.button, button.x, button.y + math.floor(yOffset + 0.5))
                    end

                    -- draw text
                    love.graphics.setColor(1, 1, 1, 1)

                end
                love.graphics.setColor(1, 1, 1, 1)

            end
        
        end

        -- Draw Batches

        if menus.currentMenu == "shop" then

            love.graphics.draw(buttonBatch.shop, 0, yOffset)
            if selectedIcon.draw then
                love.graphics.draw(selectedIcon.batch, selectedIcon.currentX, selectedIcon.currentY + yOffset)
            end
            
        end

        for i, button in ipairs(allButtons) do

            if button.screen == menus.currentMenu then

                local screenPosition = button.y + yOffset

                if screenPosition < 240 and screenPosition > -64 then
                    love.graphics.draw(button.textBatch, 0, math.floor(yOffset + 0.5))
                end

            end

        end

    elseif menus.currentMenu == "settings" then

        

    end

end