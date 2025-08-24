values = {}

local priceMultiplier = 1.2

----- Settings ------
values.settings = {}
local function defaultSettings()

    local processorCount = love.system.getProcessorCount( )

    if processorCount == 2 then
        values.settings.frameRate = 30
    else
        values.settings.frameRate = 60
    end
    

end
defaultSettings()

----- Stats -----
values.stats = {}
local function defaultStats()

    values.stats.money = 0
    values.stats.moneyPerSecond = 0
    values.stats.clickPower = 1

end
defaultStats()

----- Shop -----

local function newShopThing(price, power)
    return{
        basePrice = price,
        price = price,
        power = power,
        count = 0
    }
end

values.items = {}

table.insert(values.items, newShopThing(
    100, -- Price
    1 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    1000, -- Price
    10 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    5000, -- Price
    50 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    12500, -- Price
    150 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    75000, -- Price
    800 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    300000, -- Price
    2500 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    1000000, -- Price
    10000 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    100000000, -- Price
    500000 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    50000000000, -- Price
    5000000 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    1000000000000, -- Price
    100000000 -- Clicks Per Second
    ))
table.insert(values.items, newShopThing(
    100000000000000000, -- Price
    100000000000 -- Clicks Per Second
    ))

values.upgrades = {}

table.insert(values.upgrades, newShopThing(
    500, -- Price
    1 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    5000, -- Price
    10 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    25000, -- Price
    50 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    62500, -- Price
    150 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    375000, -- Price
    800 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    1500000, -- Price
    2500 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    5000000, -- Price
    10000 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    500000000, -- Price
    500000 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    250000000000, -- Price
    5000000 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    5000000000000, -- Price
    100000000 -- Click Power
    ))
table.insert(values.upgrades, newShopThing(
    1000000000000000000, -- Price
    1000000000000 -- Click Power
    ))

--- @param type "item"|"upgrade" type of thing
--- @param id number id of type
function values.incrementPrice(type, id)
    
    if type == "item" then
        values.items[id].price = math.floor(values.items[id].price * priceMultiplier)
    else
        values.upgrades[id].price = math.floor(values.upgrades[id].price * priceMultiplier)
    end

end

function values.resetValues()

    defaultSettings()
    defaultStats()

    -- Reseting Items to the base price and count
    for i, item in ipairs(values.items) do
        item.price = item.basePrice
        item.count = 0
    end

    -- Reseting Upgrades to the base price and count
    for i, upgrade in ipairs(values.upgrades) do
        upgrade.price = upgrade.basePrice
        upgrade.count = 0
    end
end


local sfx_buy = love.sound.newSoundData("audio/ChaChing.wav")
local sfx_buy_pool = {}
local sfx_buy_poolSize = 4

for i = 1, sfx_buy_poolSize do
        sfx_buy_pool[i] = love.audio.newSource(sfx_buy, "static")
    end

local function playBuySound()
    
    for i, source in ipairs(sfx_buy_pool) do
        if not source:isPlaying() then
            source:play()
            return
        end
    end

    sfx_buy_pool[#sfx_buy_pool + 1] = love.audio.newSource(sfx_buy, "static")

end


function values.shop_buy(type, id, free)

    if type == 0 then
        if not free then
            values.stats.money = values.stats.money - values.items[id].price
            playBuySound()
        end
        values.stats.moneyPerSecond = values.stats.moneyPerSecond + values.items[id].power
        values.items[id].count = values.items[id].count + 1
        values.incrementPrice("item", id)
    else
        if not free then
            values.stats.money = values.stats.money - values.upgrades[id].price
            playBuySound()
        end
        values.stats.clickPower = values.stats.clickPower + values.upgrades[id].power
        values.upgrades[id].count = values.upgrades[id].count + 1
        values.incrementPrice("upgrade", id)
    end
    
    
end