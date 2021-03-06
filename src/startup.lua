-- Disable STRG + T
local oldOsPullEvent = os.pullEvent
os.pullEvent         = os.pullEventRaw

-- Load _G libs
for _, sFile in ipairs(fs.list("/lib_G")) do
    if string.sub(sFile, 1, 1) ~= "." then
        local sPath = "/lib_G/" .. sFile
        if not fs.isDir(sPath) then
            dofile(sPath)
        end
    end
end

local completion = {}

function completion.build(...)
    local arguments = table.pack(...)
    for i = 1, 1 do
        local arg = arguments[i]
        if arg ~= nil then
            if type(arg) == "function" then
                arg = { arg }
                arguments[i] = arg
            end
        end
    end

    return function(shell, index, text, previous)
        local arg = arguments[index]
        if not arg then
            if index <= arguments.n then return end

            arg = arguments[arguments.n]
            if not arg or not arg.many then return end
        end

        return arg[1](shell, text, previous, table.unpack(arg, 2))
    end
end

function completion.dir(shell, text)
    return fs.complete(text, shell.dir(), false, true)
end

function completion.file(shell, text)
    return fs.complete(text, shell.dir(), true, false)
end

shell.setPath(shell.path() .. ":/bin")
shell.setCompletionFunction("bin/cat.lua", completion.build(completion.file))

term.clear()
term.setCursorPos(1, 1)

local sha256          = require("/lib/sha256")
local autentification = require("/lib/oculus/autentification")

if autentification.hasPassword() then
    while true do
        term.write("Enter Password: ")
        local input = read('*')
        if autentification.isRightPassword(input) then
            break
        else
            printError("Incorrect password!")
        end
    end
end

term.clear()
term.setCursorPos(1, 1)

term.setTextColor(colors.green)
term.write("Oculus OS 1.0b ")

term.setTextColor(colors.lightGray)
term.write("(")

term.setTextColor(colors.orange)
term.write(os.version())

term.setTextColor(colors.lightGray)
term.write(")")

print()

-- Enable STRG + T
os.pullEvent = oldOsPullEvent
