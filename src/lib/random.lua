-- Random
-- By Commandcracker
-- GNU Lesser General Public License v3
-- Last updated: July 5 2022

local sha256 = require("/lib/sha256")

local function pseudoRandomString(length)
    local str = ""
    for i = 1, length do
        str = str .. string.char(math.random(0, 255))
    end
    return str
end

local function pseudoBigRandom()
    return tostring(math.random(1, 2 ^ 31 - 1))
end

local function pseudoRandomMemoryAddress()
    return tostring({}):sub(-8)
end

-- Crating a random number generator is like cooking a bad soup.
-- Just put everyting you find in a bowl and mix it together.

local function random(bowl)
    local soup = bowl or ""

    local function addrandom()
        if math.random(0, 1) == 0 then
            soup = soup .. pseudoBigRandom() .. pseudoRandomMemoryAddress()
        else
            soup = soup .. pseudoRandomMemoryAddress() .. pseudoBigRandom()
        end
    end

    local function add(...)
        for _, ingredient in ipairs({ ... }) do
            soup = soup .. tostring(ingredient)
        end
    end

    -- add some ingredients that we can find on the computer.

    add(os.version())
    add(os.epoch()) -- ingame
    add(os.epoch("utc"))
    add(os.epoch("local"))
    add(os.getComputerID())
    add(os.getComputerLabel())

    add(_G._VERSION)
    add(_G._HOST)

    add(term.getCursorPos())
    add(term.getCursorBlink())
    add(term.getTextColor())
    add(term.getBackgroundColor())
    add(term.isColor())

    add(fs.getFreeSpace("/"))
    add(fs.getCapacity("/"))

    if turtle then
        add(turtle.getFuelLevel())
    end

    for _, side in pairs(peripheral.getNames()) do
        add(side)

        local per     = peripheral.wrap(side)
        local perType = { peripheral.getType(per) }

        add(unpack(perType))

        local function hasValue(t, val)
            for _, v in pairs(t) do
                if v == val then
                    return true
                end
            end
            return false
        end

        if hasValue(perType, "computer") then

            add(per.getID(), per.isOn(), per.getLabel())

        elseif hasValue(perType, "inventory") then

            add(per.size())
            for _, item in pairs(per.list()) do
                add(item.name, item.count, item.nbt)
            end

        elseif hasValue(perType, "printer") then

            add(per.getPaperLevel(), per.getInkLevel())

        elseif hasValue(perType, "modem") then

            add(per.isWireless())

        elseif hasValue(perType, "monitor") then

            add(per.getTextScale())
            add(per.getCursorPos())
            add(per.getCursorBlink())
            add(per.getSize())
            add(per.getTextColour())
            add(per.getBackgroundColor())
            add(per.isColor())

        elseif hasValue(perType, "drive") then

            add(per.isDiskPresent())
            add(per.getDiskLabel())
            add(per.hasData())
            add(per.getMountPath())
            add(per.hasAudio())
            add(per.getAudioTitle())
            add(per.getDiskID())

        end

    end

    -- adds 500 pseudo random ingredients
    -- we only add 500 because adding more would make the sha256 algorithm too slow
    -- and adding moor would not make the random generator any more random.
    for _ = 1, 500 do
        addrandom()
    end

    -- hash the soup to always get a 32 character long string.
    return sha256.digest(soup)

end

return {
    random = random,
    pseudo = {
        randomString        = pseudoRandomString,
        randomMemoryAddress = pseudoRandomMemoryAddress,
        bigRandom           = pseudoBigRandom
    }
}
