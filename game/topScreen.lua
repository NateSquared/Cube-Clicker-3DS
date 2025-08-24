topScreen = {}

local sprites = {}
sprites.currentShape = nil
sprites.clickParticles = nil

local particleBatch_L = nil
local particleBatch_R = nil

local clickParticles = {}

local clickParticleSettings = {}
clickParticleSettings.maxPoolSize = 50
clickParticleSettings.maxXVelocity = 700
clickParticleSettings.maxYVelocity = 700
clickParticleSettings.maxZVelocity = 150
clickParticleSettings.maxRadianRotationVelocity = 10
clickParticleSettings.gravity = 1000
clickParticleSettings.friction = 0.3

local clickParticleNumber = 0

local text = {}
text.money = {}
text.moneyPerSecond = {}
text.clickPower = {}


local cubeSizing = {}

cubeSizing.targetCubeSize = 1
cubeSizing.currentCubeSize = 1
cubeSizing.velocity = 0
cubeSizing.springConstant = 2000
cubeSizing.dampingFactor = 20
cubeSizing.fixedStep = 1/120
cubeSizing.accumulator = 0


function topScreen:load()

    


    sprites.background = love.graphics.newImage("sprites/Background.png")
    sprites.currentShape = love.graphics.newImage("sprites/Cube_Red_Main.png")
    sprites.clickParticles = love.graphics.newImage("sprites/Cube_Red_Particle.png")

    particleBatch_L = love.graphics.newSpriteBatch(sprites.clickParticles, clickParticleSettings.maxPoolSize, "stream")
    particleBatch_R = love.graphics.newSpriteBatch(sprites.clickParticles, clickParticleSettings.maxPoolSize, "stream")
    
    for i = 1, clickParticleSettings.maxPoolSize do
        clickParticles[i] = {
            active = false,
            x = 0,
            y = 0,
            z = 0,
            xVelocity = 0,
            yVelocity = 0,
            zVelocity = 0,
            rotation = 0,
            radianVelocity = 0,
        }
    end

    text.money.text = "$" .. math.floor(values.stats.money)
    text.batch = textHandler:createTextBatch(30, "stream")

end



local function updateClickParticles(dt)

    local screenDepth = love.graphics.getDepth()

    clickParticleNumber = 0

    particleBatch_L:clear()
    particleBatch_R:clear()

    local activeParticles = {}

    for i = 1, clickParticleSettings.maxPoolSize do

        local particle = clickParticles[i]

        if particle.active then

            local friction = 1 - (clickParticleSettings.friction * dt)
            particle.xVelocity = particle.xVelocity * friction
            particle.x = particle.x + (particle.xVelocity * dt)
            particle.yVelocity = particle.yVelocity + (clickParticleSettings.gravity * dt)
            particle.y = particle.y + (particle.yVelocity * dt)
            particle.zVelocity = particle.zVelocity * friction
            particle.z = math.min(particle.z + (particle.zVelocity * dt), 75)
            particle.rotation = particle.rotation + (particle.radianVelocity * dt)
            
            
            if particle.y > 270 or particle.x > 432 or particle.x < -32 then
               particle.active = false
            else

                table.insert(activeParticles, particle)

            end

        end

    end

    table.sort(activeParticles, function (a, b)
        return a.z > b.z
    end)

    for _, particle in ipairs(activeParticles) do
        
        clickParticleNumber = clickParticleNumber + 1

        local size = (0.8 - particle.z * 0.005)
        particleBatch_L:add(particle.x + (-screenDepth * (6 / size)), particle.y, particle.rotation, size, size, 32, 32)
        if screenDepth > 0 then
            particleBatch_R:add(particle.x + (screenDepth * (6 / size)), particle.y, particle.rotation, size, size, 32, 32)
        end

    end



end



function topScreen:update(dt)

    clickParticleNumber = #clickParticles
    if clickParticleNumber > 0 then
        updateClickParticles(dt)
    end

    text.money.text = "$" .. textHandler:numberToReadableText(math.floor(values.stats.money), false, false)
    text.moneyPerSecond.text = "MPS: $" .. textHandler:numberToReadableText(math.floor(values.stats.moneyPerSecond), false, false)
    text.clickPower.text = "PWR: +" .. textHandler:numberToReadableText(math.floor(values.stats.clickPower), false, false)
    textHandler:updateTextBatch(text.batch, {
        textHandler:textSet(text.money.text, 200, 230, 3, -1, 1), 
        textHandler:textSet(text.moneyPerSecond.text, 10, 28, 2, -1, 0), 
        textHandler:textSet(text.clickPower.text, 390, 28, 2, -1, 2),
        textHandler:textSet(string.format("%d", 1/dt), 2, 238, 1, 0, 0)
    })

    if isGamepadDown("a") or isGamepadDown("b") or isGamepadDown("x") or isGamepadDown("y")
    or isGamepadDown("dpleft") or isGamepadDown("dpright") or isGamepadDown("dpup") or isGamepadDown("dpdown")
    or isGamepadDown("leftshoulder") or isGamepadDown("rightshoulder") then
        cubeSizing.targetCubeSize = 0.8
    else
        cubeSizing.targetCubeSize = 1
    end

    cubeSizing.accumulator = cubeSizing.accumulator + dt

    while cubeSizing.accumulator >= cubeSizing.fixedStep do

        cubeSizing.displacement = cubeSizing.targetCubeSize - cubeSizing.currentCubeSize
        cubeSizing.springForce = cubeSizing.displacement * cubeSizing.springConstant
        cubeSizing.dampingForce = -cubeSizing.velocity * cubeSizing.dampingFactor
        cubeSizing.acceleration = cubeSizing.springForce + cubeSizing.dampingForce

        cubeSizing.velocity = cubeSizing.velocity + cubeSizing.acceleration * cubeSizing.fixedStep
        cubeSizing.currentCubeSize = cubeSizing.currentCubeSize + cubeSizing.velocity * cubeSizing.fixedStep

        cubeSizing.accumulator = cubeSizing.accumulator - cubeSizing.fixedStep
    end


end



function topScreen:draw(depth, screen)

    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(sprites.background, 200, 120, 0, .8, .8, 256, 192)

    if depth == 0 then
        if screen == "left" then
            love.graphics.draw(particleBatch_L, 0, 0)
            love.graphics.draw(sprites.currentShape, 200, 120, 0, cubeSizing.currentCubeSize, cubeSizing.currentCubeSize, 64, 64)
            love.graphics.draw(text.batch, 0, 0)
        end
    else

        if screen == "left" then

            love.graphics.draw(particleBatch_L, 0, 0)
            love.graphics.draw(sprites.currentShape, 200 + (-depth * (4 / cubeSizing.currentCubeSize)), 120, 0, cubeSizing.currentCubeSize, cubeSizing.currentCubeSize, 64, 64)
            love.graphics.draw(text.batch, 0 + (depth * 2), 0)

        else

            love.graphics.draw(particleBatch_R, 0, 0)
            love.graphics.draw(sprites.currentShape, 200 + (-depth * (4 / cubeSizing.currentCubeSize)), 120, 0, cubeSizing.currentCubeSize, cubeSizing.currentCubeSize, 64, 64)
            love.graphics.draw(text.batch, 0 + (depth * 2), 0)

        end
    end

end

function topScreen:addClickParticle()

    for i = 1, clickParticleSettings.maxPoolSize do
        if not clickParticles[i].active then

            local particle = clickParticles[i]
            
            particle.active = true

            particle.x = 200
            particle.y = 120
            particle.z = 0
            particle.xVelocity = love.math.random(-clickParticleSettings.maxXVelocity, clickParticleSettings.maxXVelocity)
            particle.yVelocity = love.math.random(-clickParticleSettings.maxYVelocity, -200)
            particle.zVelocity = love.math.random(0, clickParticleSettings.maxZVelocity)
            particle.rotation = 0
            particle.radianVelocity = love.math.random(-clickParticleSettings.maxRadianRotationVelocity, clickParticleSettings.maxRadianRotationVelocity)

            return

        end
    end
end
