-- Disable STRG + T
local oldOsPullEvent = os.pullEvent
os.pullEvent         = os.pullEventRaw

local sha256          = require("/lib/sha256")
local autentification = require("/lib/oculus/autentification")

-- Main
if autentification.hasPassword() then
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1, 1)

    while true do
        term.write("Enter Password: ")
        local password = read('*')
        if autentification.isRightPassword(password) then
            term.setBackgroundColor(colors.black)
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

            break
        else
            printError("Incorrect password!")
        end
    end
else
    printError("No password has been set")
end

-- Enable STRG + T
os.pullEvent = oldOsPullEvent
