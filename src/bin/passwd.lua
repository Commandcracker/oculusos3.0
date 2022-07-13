-- Functions

local autentification = require("/lib/oculus/autentification")

if autentification.hasPassword() then
    term.write("Enter Current Password: ")
    local passwd = read('*')
    print("Checking password...")
    if not autentification.isRightPassword(passwd) then
        printError("Incorrect password!")
        return
    end
end

term.write("Enter New Password: ")
local new_passwd = read('*')
if #new_passwd < 4 then
    printError("Password must be 4 characters or more")
    return
end

term.write("Repet the Password: ")
local repet_passwd = read('*')
if new_passwd == repet_passwd then
    print("Saving new password...")
    autentification.newPassword(new_passwd)
    if term.isColor() then
        term.setTextColour(colors.lime)
    end
    print("Password Changed")
else
    printError("Password does not match")
end
