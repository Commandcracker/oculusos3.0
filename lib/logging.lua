local logging = {}

logging.NOTSET   = 0
logging.DEBUG    = 10
logging.INFO     = 20
logging.WARN     = 30
logging.ERROR    = 40
logging.CRITICAL = 50

logging.level = logging.NOTSET

local level_names = {
    [logging.NOTSET]   = "NOTSET",
    [logging.DEBUG]    = "DEBUG",
    [logging.INFO]     = "INFO",
    [logging.WARN]     = "WARN",
    [logging.ERROR]    = "ERROR",
    [logging.CRITICAL] = "CRITICAL",
}

local names_to_level = {
    ["NOTSET"]   = logging.NOTSET,
    ["DEBUG"]    = logging.DEBUG,
    ["INFO"]     = logging.INFO,
    ["WARN"]     = logging.WARN,
    ["ERROR"]    = logging.ERROR,
    ["CRITICAL"] = logging.CRITICAL,
}

local level_colors = {
    [logging.NOTSET]   = "white",
    [logging.DEBUG]    = "cyan",
    [logging.INFO]     = "green",
    [logging.WARN]     = "yellow",
    [logging.ERROR]    = "red",
    [logging.CRITICAL] = "magenta",
}
-------------------------------------

logging.levels = {}

logging.Level = {}
logging.Level.__index = logging.Level

function logging.Level.new(name, level, textcolor, backgroundcolor)
    local self           = setmetatable({}, logging.Level)
    self.name            = name
    self.level           = level or logging.NOTSET
    self.textcolor       = textcolor or "white"
    self.backgroundcolor = backgroundcolor or "black"
    return self
end

------------------------------
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
    temp = temp:gsub("%%%(levelname%)", level_names[record.level])
    temp = temp:gsub("%%%(message%)", record.message)
    temp = temp:gsub("%%%(time%)", os.date(self.datefmt, record.time))
    temp = temp:gsub("%%%(localtime%)", os.date(self.datefmt, record.localtime))
    temp = temp:gsub("%%%(day%)", record.day)
    return temp
end

logging.Logger = {}
logging.Logger.__index = logging.Logger

function logging.Logger.new(name, level)
    local self     = setmetatable({}, logging.Logger)
    self.name      = name
    self.level     = level or logging.NOTSET
    self.file      = nil
    self.formatter = logging.Formatter.new()
    self.websocket = nil
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

function logging.Logger:log(level, ...)
    local msg        = tableConcatForamt(...)
    local record     = logging.Record.new(level, msg, self.name)
    local fmt_record = self.formatter:format(record)

    local old_text_colour = term.getTextColor()
    term.setTextColor(colours[level_colors[level]])
    print(fmt_record)
    term.setTextColor(old_text_colour)

    if self.file then
        local file = fs.open(self.file, 'a')
        file.writeLine(fmt_record)
        file.close()
    end

    if self.websocket then
        self.websocket.send(fmt_record)
    end

end

function logging.Logger:info(...)
    self:log(logging.INFO, ...)
end

function logging.Logger:debug(...)
    self:log(logging.DEBUG, ...)
end

function logging.Logger:warn(...)
    self:log(logging.WARN, ...)
end

function logging.Logger:error(...)
    self:log(logging.ERROR, ...)
end

function logging.Logger:critical(...)
    self:log(logging.CRITICAL, ...)
end

local root = logging.Logger.new("root")

function logging.debug(...)
    root:debug(...)
end

function logging.info(...)
    root:info(...)
end

function logging.warn(...)
    root:warn(...)
end

function logging.error(...)
    root:error(...)
end

function logging.critical(...)
    root:critical(...)
end

return logging
