local logging = dofile("lib/logging.lua")

local logger = logging.Logger.new(shell.getRunningProgram())

logger.levels["DEBUG"] = logging.Level.new("DEBUG", 10, colours.lime)

local websocket        = http.websocket("ws://127.0.0.1:8080")
local websocketHandler = logging.ColordWebsocketHandler.new(logger.formatter, websocket)
logger:addHandler(websocketHandler)

local file        = fs.open("main.log", "a")
local fileHandler = logging.FileHandler.new(logger.formatter, file)
logger:addHandler(fileHandler)

print("Logger Name:", logger.name)
logger:debug("Tets: debug")
logger:info("Tets: info")
logger:warn("Tets: warn")
logger:error("Tets: error")
logger:critical("Tets: critical")

--local level = logging.Level.new("NSA", 20, colours.black, colours.white)
--logger:log(level, "Tets: hello")

local cols = {
    ["White"] = colours.white,
    ["Orange"] = colours.orange,
    ["Magenta"] = colours.magenta,
    ["LightBlue"] = colours.lightBlue,
    ["Yellow"] = colours.yellow,
    ["Lime"] = colours.lime,
    ["Pink"] = colours.pink,
    ["Gray"] = colours.gray,
    ["LightGray"] = colours.lightGray,
    ["Cyan"] = colours.cyan,
    ["Purple"] = colours.purple,
    ["Blue"] = colours.blue,
    ["Brown"] = colours.brown,
    ["Green"] = colours.green,
    ["Red"] = colours.red,
    ["Black"] = colours.black
}

for k, v in pairs(cols) do
    local level
    if v == colours.black then
        level = logging.Level.new(k, 20, v, colours.white)
    else
        level = logging.Level.new(k, 20, v, colours.black)
    end
    logger:log(level, k)
end

websocket.close()
file.close()
