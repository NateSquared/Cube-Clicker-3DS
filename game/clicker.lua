clicker = {}

local maxSpawnParticleAmount = 10
local sfx_click = nil
local sfx_click_pool = {}
local sfx_click_poolSize = 4

function clicker:load()

    sfx_click = love.sound.newSoundData("audio/Click.wav")

    for i = 1, sfx_click_poolSize do
        sfx_click_pool[i] = love.audio.newSource(sfx_click, "static")
    end

end

function clicker:update(dt)

    if gamepadpressed("a") or gamepadpressed("b") or gamepadpressed("x") or gamepadpressed("y")
    or gamepadpressed("dpleft") or gamepadpressed("dpright") or gamepadpressed("dpup") or gamepadpressed("dpdown")
    or gamepadpressed("leftshoulder") or gamepadpressed("rightshoulder") then
        maingame_click()
    end

    maingame_tick(dt)

end

function clicker:draw()
    
end

local function playClickSound()

    for i, source in ipairs(sfx_click_pool) do
        if not source:isPlaying() then
            source:play()
            return
        end
    end

    print("all sfx_click_pool sources are being used")

end


function maingame_click()

    values.stats.money = values.stats.money + values.stats.clickPower

    local spawnParticleAmount = love.math.random(1, maxSpawnParticleAmount)

    for i = 1, spawnParticleAmount do
        topScreen:addClickParticle()
    end  

    playClickSound()
    
end

function maingame_tick(dt)

    values.stats.money = values.stats.money + (values.stats.moneyPerSecond*dt)
    
end
