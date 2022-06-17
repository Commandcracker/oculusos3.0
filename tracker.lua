local logging = dofile("lib/logging.lua")

local logger     = logging.Logger.new(shell.getRunningProgram())
logger.file      = "tracker.log"
logger.websocket = http.websocket("ws://127.0.0.1:8080")

local function debugloc()
    local x, y, z = tracker.x, tracker.y, tracker.z
    local facing  = tracker.facing
    logger:debug(x, y, z, "facing:", facing)
end

logger:debug(turtle.turnRight())
debugloc()

logger:debug(turtle.forward())
debugloc()

logger:debug(turtle.up())
debugloc()

logger:debug(turtle.up())
debugloc()

logger:debug(turtle.down())
debugloc()

logger:debug(turtle.down())
debugloc()
