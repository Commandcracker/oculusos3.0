local logging = {}

logging.Level = {}
logging.Level.__index = logging.Level

function logging.Level.new(name, level, textcolor, backgroundcolor)
    local self           = setmetatable({}, logging.Level)
    self.name            = name
    self.level           = level or 0
    self.textcolor       = textcolor or colours.white
    self.backgroundcolor = backgroundcolor or colours.black
    return self
end

logging.Record = {}
logging.Record.__index = logging.Record

function logging.Record.new(level, message, name)
    local self     = setmetatable({}, logging.Record)
    self.level     = level
    self.message   = message
    self.time      = os.time(os.date("*t"))
    self.localtime = os.time(os.date("!*t"))
    self.name      = name
    self.day       = os.day()
    return self
end

logging.Formatter = {}
logging.Formatter.__index = logging.Formatter

--[[
    %(name)s        Name of the logger
    %(levelname)s   Name of the Log level
    %(message)s     The Message to log
    %(time)s        The real live time formatted by datefmt
    %(localtime)s   The minecraft time formatted by datefmt
    %(day)s         The minecraft day
]]

function logging.Formatter.new(fmt, datefmt)
    local self   = setmetatable({}, logging.Formatter)
    self.fmt     = fmt or "[%(time) %(levelname)] %(message)"
    self.datefmt = datefmt or "%H:%M:%S"
    return self
end

function logging.Formatter:format(record)
    temp = self.fmt
    temp = temp:gsub("%%%(name%)", record.name)
    temp = temp:gsub("%%%(levelname%)", record.level.name)
    temp = temp:gsub("%%%(message%)", record.message)
    temp = temp:gsub("%%%(time%)", os.date(self.datefmt, record.time))
    temp = temp:gsub("%%%(localtime%)", os.date(self.datefmt, record.localtime))
    temp = temp:gsub("%%%(day%)", record.day)
    return temp
end

logging.WebsocketHandler = {}
logging.WebsocketHandler.__index = logging.WebsocketHandler

function logging.WebsocketHandler.new(formatter, websocket)
    local self     = setmetatable({}, logging.WebsocketHandler)
    self.websocket = websocket
    self.formatter = formatter
    return self
end

function logging.WebsocketHandler:handle(record)
    self.websocket.send(self.formatter:format(record))
end

logging.RawWebsocketHandler = {}
logging.RawWebsocketHandler.__index = logging.RawWebsocketHandler

function logging.RawWebsocketHandler.new(formatter, websocket)
    local self     = setmetatable({}, logging.RawWebsocketHandler)
    self.websocket = websocket
    self.formatter = formatter
    return self
end

function logging.RawWebsocketHandler:handle(record)
    record.formatter = self.formatter
    self.websocket.send(record)
end

local function convertTrueColor(color)
    --[[
        24-bit/true Colors
        https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit
    ]]

    local r, g, b

    if color == colours.white then
        r, g, b = 240, 240, 240
    elseif color == colours.orange then
        r, g, b = 242, 178, 51
    elseif color == colours.magenta then
        r, g, b = 229, 127, 216
    elseif color == colours.lightBlue then
        r, g, b = 153, 178, 242
    elseif color == colours.yellow then
        r, g, b = 222, 222, 108
    elseif color == colours.lime then
        r, g, b = 127, 204, 25
    elseif color == colours.pink then
        r, g, b = 242, 178, 204
    elseif color == colours.gray then
        r, g, b = 76, 76, 76
    elseif color == colours.lightGray then
        r, g, b = 153, 153, 153
    elseif color == colours.cyan then
        r, g, b = 76, 153, 178
    elseif color == colours.purple then
        r, g, b = 178, 102, 229
    elseif color == colours.blue then
        r, g, b = 51, 102, 204
    elseif color == colours.brown then
        r, g, b = 127, 102, 76
    elseif color == colours.green then
        r, g, b = 87, 166, 78
    elseif color == colours.red then
        r, g, b = 204, 76, 76
    elseif color == colours.black then
        r, g, b = 17, 17, 17
    end

    return r, g, b
end

local function convertForgroundColor(color)
    --[[
        3-bit and 4-bit Colors
        https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
        Note: Some colors like pink and purple need to share the same color code.
        Note: Colors are not acurate, they vary on your os and terminal settings.
    ]]

    local code

    if color == colours.white then
        code = 97
    elseif color == colours.orange then
        code = 33
    elseif color == colours.magenta then
        code = 95
    elseif color == colours.lightBlue then
        code = 94
    elseif color == colours.yellow then
        code = 93
    elseif color == colours.lime then
        code = 92
    elseif color == colours.pink then
        code = 35
    elseif color == colours.gray then
        code = 37
    elseif color == colours.lightGray then
        code = 90
    elseif color == colours.cyan then
        code = 36
    elseif color == colours.purple then
        code = 35
    elseif color == colours.blue then
        code = 34
    elseif color == colours.brown then
        code = 93
    elseif color == colours.green then
        code = 32
    elseif color == colours.red then
        code = 31
    elseif color == colours.black then
        code = 30
    end

    return code
end

local function convertBackgroundColor(color)
    --[[
        3-bit and 4-bit Colors
        https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
        Note: Some colors like pink and purple need to share the same color code.
        Note: Colors are not acurate, they vary on your os and terminal settings.
    ]]
    local code

    if color == colours.white then
        code = 107
    elseif color == colours.orange then
        code = 43
    elseif color == colours.magenta then
        code = 105
    elseif color == colours.lightBlue then
        code = 104
    elseif color == colours.yellow then
        code = 103
    elseif color == colours.lime then
        code = 102
    elseif color == colours.pink then
        code = 45
    elseif color == colours.gray then
        code = 47
    elseif color == colours.lightGray then
        code = 100
    elseif color == colours.cyan then
        code = 46
    elseif color == colours.purple then
        code = 45
    elseif color == colours.blue then
        code = 44
    elseif color == colours.brown then
        code = 103
    elseif color == colours.green then
        code = 42
    elseif color == colours.red then
        code = 41
    elseif color == colours.black then
        code = 40
    end

    return code
end

logging.ColordWebsocketHandler = {}
logging.ColordWebsocketHandler.__index = logging.ColordWebsocketHandler

function logging.ColordWebsocketHandler.new(formatter, websocket)
    local self     = setmetatable({}, logging.ColordWebsocketHandler)
    self.websocket = websocket
    self.formatter = formatter
    return self
end

function logging.ColordWebsocketHandler:handle(record)
    --local ForgroundColor  = convertForgroundColor(record.level.textcolor)
    --local BackgroundColor = convertBackgroundColor(record.level.backgroundcolor)

    local fr, fg, fb = convertTrueColor(record.level.textcolor)
    local br, bg, bb = convertTrueColor(record.level.backgroundcolor)

    local ForgroundColor  = "38;2;" .. fr .. ";" .. fg .. ";" .. fb
    local BackgroundColor = "48;2;" .. br .. ";" .. bg .. ";" .. bb

    self.websocket.send(
        "\x1b[" .. ForgroundColor .. "m" ..
        "\x1b[" .. BackgroundColor .. "m" ..
        self.formatter:format(record) ..
        "\x1b[39m" ..
        "\x1b[49m"
    )
end

logging.FileHandler = {}
logging.FileHandler.__index = logging.FileHandler

function logging.FileHandler.new(formatter, file)
    local self     = setmetatable({}, logging.FileHandler)
    self.file      = file
    self.formatter = formatter
    return self
end

function logging.FileHandler:handle(record)
    self.file.writeLine(self.formatter:format(record))
end

logging.TerminalHandler = {}
logging.TerminalHandler.__index = logging.TerminalHandler

function logging.TerminalHandler.new(formatter)
    local self     = setmetatable({}, logging.TerminalHandler)
    self.formatter = formatter
    return self
end

function logging.TerminalHandler:handle(record)
    local old_text_colour = term.getTextColor()
    local old_background_colour = term.getBackgroundColor()

    term.setTextColor(record.level.textcolor)
    term.setBackgroundColor(record.level.backgroundcolor)

    write(self.formatter:format(record))

    term.setTextColor(old_text_colour)
    term.setBackgroundColor(old_background_colour)

    write("\n")
end

logging.Logger = {}
logging.Logger.__index = logging.Logger

function logging.Logger.new(name, level)
    local self     = setmetatable({}, logging.Logger)
    self.name      = name
    self.level     = level or 0
    self.formatter = logging.Formatter.new()
    self.levels    = {
        ["DEBUG"]    = logging.Level.new("DEBUG", 10, colours.cyan),
        ["INFO"]     = logging.Level.new("INFO", 20, colours.green),
        ["WARN"]     = logging.Level.new("WARN", 30, colours.yellow),
        ["ERROR"]    = logging.Level.new("ERROR", 40, colours.red),
        ["CRITICAL"] = logging.Level.new("CRITICAL", 50, colours.magenta),
    }
    self.handlers  = {
        logging.TerminalHandler.new(self.formatter),
    }
    return self
end

local function tableConcatForamt(...)
    local fstring = ""
    for i = 0, #{ ... }, 1 do
        if i == 1 then
            fstring = "%s"
        else
            fstring = fstring .. " " .. "%s"
        end
    end
    return string.format(fstring, ...)
end

function logging.Logger:addHandler(handler)
    table.insert(self.handlers, handler)
end

function logging.Logger:registerLevel(level)
    self.levels[level.name] = level
end

function logging.Logger:log(level, ...)
    local msg    = tableConcatForamt(...)
    local record = logging.Record.new(level, msg, self.name)

    for i = 1, #self.handlers, 1 do
        self.handlers[i]:handle(record)
    end

end

function logging.Logger:debug(...)
    self:log(self.levels.DEBUG, ...)
end

function logging.Logger:info(...)
    self:log(self.levels.INFO, ...)
end

function logging.Logger:warn(...)
    self:log(self.levels.WARN, ...)
end

function logging.Logger:error(...)
    self:log(self.levels.ERROR, ...)
end

function logging.Logger:critical(...)
    self:log(self.levels.CRITICAL, ...)
end

local rootLogger = logging.Logger.new("root")

function logging.debug(...)
    rootLogger:debug(...)
end

function logging.info(...)
    rootLogger:info(...)
end

function logging.warn(...)
    rootLogger:warn(...)
end

function logging.error(...)
    rootLogger:error(...)
end

function logging.critical(...)
    rootLogger:critical(...)
end

function logging.log(level, ...)
    rootLogger:log(level, ...)
end

logging.levels = rootLogger.levels

return logging
