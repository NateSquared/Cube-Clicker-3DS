saveSystem = {}

local lume = nil
local saveFileName = "CubeClicker3DS.sav"

local timeBetweenSaves = 120
local currentSaveTime = 0
local timeBetweenSaveErasure = 10
local currentSaveErasureTime = 8

local saveTextBatch = nil

function saveSystem:load()
    
    lume = require "libraries.lume"

    if love.filesystem.getInfo(saveFileName) then
        saveSystem:loadGame(love.filesystem.read(saveFileName))
    end

    saveTextBatch = textHandler:createTextBatch(9, "dynamic")
    textHandler:updateTextBatch(saveTextBatch, {textHandler:textSet("SAVING...", 200, 142, 5, 0, 1)})

end

function saveSystem:update(dt)
    
    if currentSaveTime >= timeBetweenSaves then
        while currentSaveTime >= timeBetweenSaves do
            currentSaveTime = currentSaveTime - timeBetweenSaves
        end
        saveSystem:saveGame()
        if isGamepadDown("start") or gamepadreleased("start") then
            love.event.quit()
        end
    end

    if gamepadpressed("start") then
        currentSaveTime = timeBetweenSaves
    end

    currentSaveTime = currentSaveTime + dt
    currentSaveErasureTime = currentSaveErasureTime + dt

end

function saveSystem:draw(depth, screen)
    
    if currentSaveTime >= timeBetweenSaves then
        love.graphics.draw(saveTextBatch, 0 + (depth * 4), 0)
    end


end

function saveSystem:saveGame()
    
    local data = {}

    data.settings = values.settings

    data.money = math.floor(values.stats.money)

    data.itemCount = {}
    for i, item in ipairs(values.items) do
        table.insert(data.itemCount, item.count)
    end

    data.upgradeCount = {}
    for i, upgrade in ipairs(values.upgrades) do
        table.insert(data.upgradeCount, upgrade.count)
    end

    serializedData = lume.serialize(data)
    love.filesystem.write(saveFileName, serializedData)
    print("saved game: " .. serializedData)

end

function saveSystem:loadGame(saveFile)
    
    print("loaded game: " .. saveFile)
    local data = lume.deserialize(saveFile)

    values.settings = data.settings

    values.stats.money = data.money

    for i, itemCount in ipairs(data.itemCount) do
        for j = 1, itemCount do
            values.shop_buy(0, i, true)
        end
    end

    for i, upgradeCount in ipairs(data.upgradeCount) do
        for j = 1, upgradeCount do
            values.shop_buy(1, i, true)
        end
    end


end

function saveSystem:deleteSaveData()
    
    if love.filesystem.getInfo(saveFileName) then
        love.filesystem.remove(saveFileName)
    end

    values.resetValues()

    buttons:PopulateBatches()

end