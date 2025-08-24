textHandler = {}

local textImage = nil
local fontData = {}

local function addCharacterToList(character, quad_x, quad_y, quad_width, quad_height, object_quadOffset_x, object_quadOffset_y, object_width)
    
    local ID = string.byte(character, 1, 1)

    fontData[ID] = 
    {
        quad = love.graphics.newQuad(quad_x, quad_y, quad_width, quad_height, 128, 128),
        variables = {
            quadWidth = quad_width,
            quadHeight = quad_height,
            quadOffsetX = object_quadOffset_x,
            quadOffsetY = object_quadOffset_y,
            width = object_width}
    }

    print("character " .. character .. " added to the fontData list")

end

addCharacterToList("A", 1, 1, 9, 9, 0, 0, 10)
addCharacterToList("B", 11, 1, 9, 9, 0, 0, 10)
addCharacterToList("C", 21, 1, 9, 9, 0, 0, 10)
addCharacterToList("D", 31, 1, 9, 9, 0, 0, 10)
addCharacterToList("E", 41, 1, 9, 9, 0, 0, 10)
addCharacterToList("F", 51, 1, 9, 9, 0, 0, 10)
addCharacterToList("G", 61, 1, 9, 9, 0, 0, 10)
addCharacterToList("H", 71, 1, 9, 9, 0, 0, 10)
addCharacterToList("I", 81, 1, 8, 9, 0, 0, 9)
addCharacterToList("J", 90, 1, 9, 9, 0, 0, 10)
addCharacterToList("K", 100, 1, 9, 9, 0, 0, 10)
addCharacterToList("L", 110, 1, 8, 9, 0, 0, 9)

addCharacterToList("M", 1, 11, 9, 9, 0, 0, 10)
addCharacterToList("N", 11, 11, 9, 9, 0, 0, 10)
addCharacterToList("O", 21, 11, 9, 9, 0, 0, 10)
addCharacterToList("P", 31, 11, 9, 9, 0, 0, 10)
addCharacterToList("Q", 41, 11, 9, 9, 0, 0, 10)
addCharacterToList("R", 51, 11, 9, 9, 0, 0, 10)
addCharacterToList("S", 61, 11, 9, 9, 0, 0, 10)
addCharacterToList("T", 71, 11, 8, 9, 0, 0, 9)
addCharacterToList("U", 80, 11, 9, 9, 0, 0, 10)
addCharacterToList("V", 90, 11, 9, 9, 0, 0, 10)
addCharacterToList("W", 100, 11, 9, 9, 0, 0, 10)
addCharacterToList("X", 110, 11, 9, 9, 0, 0, 10)

addCharacterToList("Y", 1, 21, 8, 9, 0, 0, 9)
addCharacterToList("Z", 10, 21, 9, 9, 0, 0, 10)
addCharacterToList("0", 20, 21, 9, 9, 0, 0, 10)
addCharacterToList("1", 30, 21, 8, 9, 0, 0, 9)
addCharacterToList("2", 39, 21, 9, 9, 0, 0, 10)
addCharacterToList("3", 49, 21, 9, 9, 0, 0, 10)
addCharacterToList("4", 59, 21, 9, 9, 0, 0, 10)
addCharacterToList("5", 69, 21, 9, 9, 0, 0, 10)
addCharacterToList("6", 79, 21, 9, 9, 0, 0, 10)
addCharacterToList("7", 89, 21, 9, 9, 0, 0, 10)
addCharacterToList("8", 99, 21, 9, 9, 0, 0, 10)
addCharacterToList("9", 109, 21, 9, 9, 0, 0, 10)
addCharacterToList("!", 119, 21, 5, 9, 0, 0, 6)

addCharacterToList("#", 1, 31, 9, 9, 0, 0, 10)
addCharacterToList("$", 11, 31, 9, 9, 0, 0, 10)
addCharacterToList("%", 21, 31, 9, 9, 0, 0, 10)
addCharacterToList("^", 31, 31, 7, 4, 0, 0, 8)
addCharacterToList("&", 39, 31, 9, 9, 0, 0, 10)
addCharacterToList("*", 49, 32, 9, 7, 0, 0, 10)
addCharacterToList("(", 59, 31, 6, 9, 0, 0, 7)
addCharacterToList(")", 66, 31, 6, 9, 0, 0, 7)
addCharacterToList("-", 73, 34, 8, 3, 0, 0, 9)
addCharacterToList("_", 82, 38, 9, 3, 0, 0, 10)
addCharacterToList("+", 92, 32, 8, 7, 0, 1, 9)
addCharacterToList("=", 101, 33, 9, 5, 0, 0, 10)
addCharacterToList("{", 111, 31, 6, 9, 0, 0, 7)
addCharacterToList("}", 118, 31, 6, 9, 0, 0, 7)

addCharacterToList("[", 1, 41, 6, 9, 0, 0, 7)
addCharacterToList("]", 8, 41, 6, 9, 0, 0, 7)
addCharacterToList("/", 15, 41, 9, 9, 0, 0, 10)
addCharacterToList([[\]], 25, 41, 9, 9, 0, 0, 10)
addCharacterToList("|", 35, 41, 4, 9, 0, 0, 5)
addCharacterToList(":", 40, 41, 4, 7, 0, 1, 5)
addCharacterToList(";", 45, 41, 5, 8, 0, 0, 6)
addCharacterToList([["]], 51, 41, 8, 5, 0, 0, 9)
addCharacterToList("'", 60, 41, 5, 5, 0, 0, 6)
addCharacterToList("<", 66, 41, 7, 9, 0, 0, 8)
addCharacterToList(">", 74, 41, 7, 9, 0, 0, 8)
addCharacterToList(",", 82, 42, 5, 5, 0, 0, 6)
addCharacterToList(".", 88, 42, 4, 4, 0, 5, 5)
addCharacterToList("?", 93, 41, 9, 9, 0, 0, 10)
addCharacterToList("~", 103, 41, 9, 5, 0, 0, 10)
addCharacterToList("`", 113, 41, 4, 4, 0, 0, 5)

addCharacterToList(" ", 0, 0, 0, 0, 0, 0, 3)


function textHandler:load()

    textImage = love.graphics.newImage("sprites/PressStart2P.png")

end

function textHandler:update()
    
end

function textHandler:draw()
    
end


-- Struct to set up text batch
--- @param spriteNumber number approximately the number of sprites found within the batch
--- @param bufferDataUsage "dynamic"|"static"|"stream" dynamic = The object's data will change fairly frequently during its lifetime | static = The object will not be modified frequently or at all | stream = The object data will always change every frame.
function textHandler:createTextBatch(spriteNumber, bufferDataUsage)
    
    local newTextBatch = love.graphics.newSpriteBatch(textImage, spriteNumber, bufferDataUsage)

    textHandler:updateTextBatch(newTextBatch, self:textSet("TEST TEXT", 0, 0, 1, 0, 0))

    return newTextBatch

end



function textHandler:updateTextBatch(textBatch, textStruct)

    textBatch:clear()

    for i, textSet in ipairs(textStruct) do
    
        local xOffset = textSet.initialXOffset

        for j = 1, #textSet.text do

            local ID = string.byte(textSet.text, j, j)
            local character = fontData[ID]

            textBatch:add(character.quad, math.floor(textSet.x + xOffset) + (character.variables.quadOffsetX * textSet.size), math.floor(textSet.y) + (character.variables.quadOffsetY * textSet.size), 0, textSet.size, textSet.size, 0, 9)
            xOffset = xOffset + ((character.variables.width + textSet.widthOffset) * textSet.size)

        end
    end


end

function textHandler:textWidth(text, widthOffset)

    local width = 0

    for i = 1, #text do
        local ID = string.byte(text, i, i)
        local character = fontData[ID]

        width = width + character.variables.width + widthOffset
    end

    return width
    
end

-- Struct to set up text batch
--- @param text string text
--- @param x number x position
--- @param y number y position
--- @param size number size of text, recommended to be a whole number
--- @param widthOffset number width between 2 characters
--- @param alignment number text allignment -> 0 = left, 1 = middle, 2 = right
function textHandler:textSet(text, x, y, size, widthOffset, alignment)
    
    text = string.upper(text)
    local initialXOffset = 0

    if alignment == 1 then -- middle aligned
        local width = self:textWidth(text, widthOffset) / 2
        initialXOffset = -width * size
    elseif alignment == 2 then -- right aligned
        local width = self:textWidth(text, widthOffset)
        initialXOffset = -width * size
    end

    return {
        text = text,
        x = x,
        y = y,
        size = size,
        widthOffset = widthOffset,
        initialXOffset = initialXOffset
    }

end

-- Struct to set up text batch
--- @param num number number to change
--- @param useScientificNotiation boolean if true, use Scientific Notation. (15.4e+06 vs 15.4M)
--- @param wholeNumberShrink boolean if true, whole numbers shave off the decimals
function textHandler:numberToReadableText(num, useScientificNotiation, wholeNumberShrink)

    -- return 0 if 0
    if num == 0 then
        return "0"
    end

    -- return the scientific notation if it is needed
    if useScientificNotiation then
        return string.format("%.2e", num)
    end

    -- standard notation
    local suffixes = {
        {suffix = "N", value = 1e27 },
        {suffix = "O", value = 1e24 },
        {suffix = "S", value = 1e21 },
        {suffix = "QI", value = 1e18 },
        {suffix = "Q", value = 1e15 },
        {suffix = "T", value = 1e12 },
        {suffix = "B", value = 1e9 },
        {suffix = "M", value = 1e6 },
        {suffix = "K", value = 1e3 }
    }

    for i, suffix in ipairs(suffixes) do
        if num >= suffix.value then

            local formattedNum = num / suffix.value
            if wholeNumberShrink and formattedNum % 1 == 0 then
                return string.format("%d%s", formattedNum, suffix.suffix)
            else
                if formattedNum >= 100 then
                    return string.format("%.1f%s", formattedNum, suffix.suffix)
                else
                    return string.format("%.2f%s", formattedNum, suffix.suffix)
                end
            end
            
        end
    end

    return tostring(num)

end