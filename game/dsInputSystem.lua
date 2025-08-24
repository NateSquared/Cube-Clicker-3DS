dsInputSystem = {}

----- variables -----

-- settings

local leftStickDeadzone = 0
local rightStickDeadzone = 0

-- values

local currentConsole = ""
local controller = nil
local mouseWindowScale = 1

local buttons = {"dpleft", "dpright", "dpup", "dpdown", "a", "b", "x", "y", "leftshoulder", "rightshoulder", "start", "back"}
local buttonStates = {}

local axes = {"leftx", "lefty", "rightx", "righty", "triggerleft", "triggerright"}
local axisValues = {}

local touch = {
    state = 0,
    x = 0,
    y = 0,
    dx = 0,
    dy = 0
}

gyroscope = {
    x = 0,
    y = 0,
    z = 0
}

-- setup input system
function dsInputSystem:load(isNest, nestScale)
    
    -- setup controller immidiately if 3ds
    if not isNest then
        currentConsole = "3DS"
        controller = love.joystick.getJoysticks()[1]
        controller:setSensorEnabled("gyroscope", true)
    else
        currentConsole = "PC"
        mouseWindowScale = nestScale
    end

    print("the current console is a " .. currentConsole)

    -- button states
    for i, v in ipairs(buttons) do
        table.insert(buttonStates, 0)
    end

    --axis values
    for i, v in ipairs(axes) do
        table.insert(axisValues, 0)
    end

end

-- loop through button states
--- @param index integer index of button
--- @param id string button id
local function buttonStateChange(index, id)

    if controller:isGamepadDown(id) then
        -- up(0) -> pressed(1)
        if buttonStates[index] == 0 then
            buttonStates[index] = 1
        -- pressed(1) -> down(2)
        elseif buttonStates[index] == 1 then
            buttonStates[index] = 2
        -- released(3) -> pressed(1)
        elseif buttonStates[index] == 3 then
            buttonStates[index] = 1
        end
    else
        -- down(2) -> released(3)
        if buttonStates[index] == 2 then
            buttonStates[index] = 3
        -- released(3) -> up(0)
        elseif buttonStates[index] == 3 then
            buttonStates[index] = 0
        -- pressed(1) -> released(3)
        elseif buttonStates[index] == 1 then
            buttonStates[index] = 3
        end
    end

end

-- loop through axis changes
--- @param index integer index of axis
--- @param id string axis id
local function axisStateChange(index, id)
    
    -- getting axis value from list
    axisValues[index] = controller:getGamepadAxis(id)

end

-- look for index of button or axis
--- @param type string button or axis
--- @param id string name of input type
--- @return integer|nil
local function getInputIndex(type, id)
    
    if type == "button" then -- button search
        for i, v in ipairs(buttons) do
            if v == id then
                return i -- found index
            end
        end
        return nil -- failed to find index
    elseif type == "axis" then -- axis search
        for i, v in ipairs(axes) do
            if v == id then
                return i -- found index
            end
        end
        return nil --failed to find index
    else -- neither button or axis selected
        return nil -- did nothing
    end

end

local function touchStateChange()

    -- checking if touch is down on 3ds or mouse is down on pc
    local touchDown = false
    local touchID = nil
    local mouseDown = false

    if(currentConsole == "3DS") then
        touchID = love.touch.getTouches()[1]
    else
        mouseDown = love.mouse.isDown(1)
    end

    if (currentConsole == "3DS" and touchID ~= nil) or (currentConsole ~= "3DS" and mouseDown) then
        touchDown = true
    end

    if touchDown then
        
        local tempX = 0
        local tempY = 0

        
        if currentConsole == "3DS" then
            -- getting touch position on 3ds
            tempX, tempY = love.touch.getPosition(love.touch.getTouches()[1]) -- get current position of touch
        else
            --mouse position
            tempX, tempY = love.mouse.getPosition()
            -- accounting for screen size
            tempX = (tempX / mouseWindowScale) - 40
            tempY = (tempY / mouseWindowScale) - 240
            -- clamping to bottom screen
            tempX = math.min(math.max(tempX, 0), 320)
            tempY = math.min(math.max(tempY, 0), 240)
            -- flooring the result
            tempX = math.floor(tempX)
            tempY = math.floor(tempY)
        end

        -- up(0) -> pressed(1) + delta position = 0
        if touch.state == 0 then
            touch.state = 1
            touch.dx = 0
            touch.dy = 0
        -- pressed(1) -> down(2) + delta position calculation
        elseif (touch.state == 1) or (touch.state == 2) then
            touch.state = 2
            touch.dx = tempX - touch.x
            touch.dy = tempY - touch.y
        -- released(3) -> pressed(1) + delta position = 0
        elseif touch.state == 3 then
            touch.state = 1
            touch.dx = 0
            touch.dy = 0
        end

        -- set position of touch
        touch.x = tempX
        touch.y = tempY

    else
        -- down(2) -> released(3) + delta position doesn't change
        if touch.state == 2 then
            touch.state = 3
            touch.dx = touch.dx
            touch.dy = touch.dy
        -- released(3) -> up(0) + delta position = 0
        elseif touch.state == 3 then
            touch.state = 0
            touch.dx = 0
            touch.dy = 0
        -- pressed(1) -> released(3) + delta position = 0
        elseif touch.state == 1 then
            touch.state = 3
            touch.dx = 0
            touch.dy = 0
        end

        -- leave touch position unchanged
        touch.x = touch.x
        touch.y = touch.y

    end

end

local function gyroStateChange()

    if currentConsole == "3DS" then
        gyroscope.x, gyroscope.y, gyroscope.z = controller:getSensorData("gyroscope")
    else
        gyroscope.x = 0
        gyroscope.y = 0
        gyroscope.z = 0
    end
    
end

-- dsInputSystem update
function dsInputSystem:update()
    
    if controller ~= nil then
    
        -- Change all button states/values
        for i, v in ipairs(buttons) do
            buttonStateChange(i,v)
        end

        -- Change all axis states/values
        for i, v in ipairs(axes) do
            axisStateChange(i,v)
        end

    end

    -- Change all touch states/values
    touchStateChange()

    gyroStateChange()

end

-- add joystick if none already present
--- @param joystick love.Joystick joystick
function dsInputSystem:joystickadded(joystick)
    
    -- check for controller, replace if none pressent
    if controller == nil then
        controller = joystick
    end

end

-- remove joystick if the one that was connected is disconnected
--- @param joystick love.Joystick joystick
function dsInputSystem:joystickremoved(joystick)
    
    --check for if controller is equal to removed controller, controller set to nil if that is the case
    if controller == joystick then
        controller = nil
    end

end

-- return true if button is down
--- @param button string button name -> dpleft, dpright, dpup, dpdown, a, b, x, y, leftshoulder, rightshoulder, start, back
--- @return boolean
function isGamepadDown(button)

    -- look for button index, if none found return false
    local index = getInputIndex("button", button)
    if index == nil then return false end

    -- return button down
    if buttonStates[index] == 1 or buttonStates[index] == 2 then
        return true
    else
        return false
    end

end

-- return true if button pressed this frame
--- @param button string button name -> dpleft, dpright, dpup, dpdown, a, b, x, y, leftshoulder, rightshoulder, start, back
--- @return boolean
function gamepadpressed(button)

    -- look for button index, if none found return false
    local index = getInputIndex("button", button)
    if index == nil then return false end

    -- return button pressed
    if buttonStates[index] == 1 then
        return true
    else
        return false
    end

end

-- return true if button released this frame 
--- @param button string button name -> dpleft, dpright, dpup, dpdown, a, b, x, y, leftshoulder, rightshoulder, start, back
--- @return boolean
function gamepadreleased(button)

    -- look for button index, if none found return false
    local index = getInputIndex("button", button)
    if index == nil then return false end

    -- return button released
    if buttonStates[index] == 3 then
        return true
    else
        return false
    end

end

-- return axis value
--- @param axis string axis name -> leftx, lefty, rightx, righty, triggerleft, triggerright
--- @return number
function getAxis(axis)

    -- look for axis index, if none found return 0
    local index = getInputIndex("axis", axis)
    if index == nil then return 0 end

    -- return axis value
    return axisValues[index]

end

-- return true if bottom screen touched this frame
--- @return boolean 
function touchpressed()
    if touch.state == 1 then
        return true
    end
    return false
end

-- return true if bottom screen released this frame
--- @return boolean 
function touchreleased()
    if touch.state == 3 then
        return true
    end
    return false
end

-- return true if bottom screen being touched at all
--- @return boolean 
function touchDown()
    if (touch.state == 1) or (touch.state == 2)  then
        return true
    end
    return false
end

-- return touch.x and touch.y
--- @return number, number
function touchPosition()
    return touch.x, touch.y
end

-- return only touch.x
--- @return number
function touchPositionX()
    return touch.x
end

-- return only touch.y
--- @return number
function touchPositionY() 
    return touch.y
end

-- return touch.dx and touch.dy
--- @return number, number
function touchDeltaPosition()
    return touch.dx, touch.dy
end

-- return only touch.dx
--- @return number
function touchDeltaPositionX()
    return touch.dx
end

-- return only touch.dy
--- @return number
function touchDeltaPositionY()
    return touch.dy
end

-- return gyroscope values
--- @return number, number, number
function gyroGetSensorData()
    return gyroscope.x, gyroscope.y, gyroscope.z
end

function gyroGetSensorDataX()
    return gyroscope.x
end

function gyroGetSensorDataY()
    return gyroscope.y
end

function gyroGetSensorDataZ()
    return gyroscope.z
end

