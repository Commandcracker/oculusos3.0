if _G.tracker then
    return false, "Tracker has already been loaded."
end

_G.tracker = {
    x      = 0,
    y      = 0,
    z      = 0,
    facing = "north"
}

local filename = ".tracker.txt"

local function loadFile()
    local file = fs.open(filename, "r")
    if file then
        local x, y, z, facing = file.readLine():match("(%d+);(%d+);(%d+);(%a+)")
        file.close()
        tracker.x, tracker.y, tracker.z, tracker.facing = tonumber(x), tonumber(y), tonumber(z), facing
    end
end

loadFile()

local function updateFile()
    local file = fs.open(filename, "w")
    file.write(
        tostring(tracker.x) .. ";" ..
        tostring(tracker.y) .. ";" ..
        tostring(tracker.z) .. ";" ..
        tracker.facing
    )
    file.close()
end

local old_turtle     = {}
old_turtle.up        = turtle.up
old_turtle.down      = turtle.down
old_turtle.forward   = turtle.forward
old_turtle.back      = turtle.back
old_turtle.turnLeft  = turtle.turnLeft
old_turtle.turnRight = turtle.turnRight

function turtle.up()
    successfull, reason = old_turtle.up()
    if successfull then
        tracker.y = tracker.y + 1
        updateFile()
        return successfull
    end
    return successfull, reason
end

function turtle.down()
    successfull, reason = old_turtle.down()
    if successfull then
        tracker.y = tracker.y - 1
        updateFile()
        return successfull
    end
    return successfull, reason
end

function turtle.forward()
    successfull, reason = old_turtle.forward()
    if successfull then
        if tracker.facing == "north" then
            tracker.z = tracker.z - 1
        elseif tracker.facing == "east" then
            tracker.x = tracker.x + 1
        elseif tracker.facing == "south" then
            tracker.z = tracker.z + 1
        elseif tracker.facing == "west" then
            tracker.x = tracker.x - 1
        end
        updateFile()
        return successfull
    end
    return successfull, reason
end

function turtle.back()
    successfull, reason = old_turtle.back()
    if successfull then
        if tracker.facing == "north" then
            tracker.z = tracker.z + 1
        elseif tracker.facing == "east" then
            tracker.x = tracker.x - 1
        elseif tracker.facing == "south" then
            tracker.z = tracker.z - 1
        elseif tracker.facing == "west" then
            tracker.x = tracker.x + 1
        end
        updateFile()
        return successfull
    end
    return successfull, reason
end

function turtle.turnLeft()
    successfull, reason = old_turtle.turnLeft()
    if successfull then
        if tracker.facing == "north" then
            tracker.facing = "west"
        elseif tracker.facing == "west" then
            tracker.facing = "south"
        elseif tracker.facing == "south" then
            tracker.facing = "east"
        elseif tracker.facing == "east" then
            tracker.facing = "north"
        end
        updateFile()
        return successfull
    end
    return successfull, reason
end

function turtle.turnRight()
    successfull, reason = old_turtle.turnRight()
    if successfull then
        if tracker.facing == "north" then
            tracker.facing = "east"
        elseif tracker.facing == "east" then
            tracker.facing = "south"
        elseif tracker.facing == "south" then
            tracker.facing = "west"
        elseif tracker.facing == "west" then
            tracker.facing = "north"
        end
        updateFile()
        return successfull
    end
    return successfull, reason
end

return true
