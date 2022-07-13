local e=require("/lib/oculus/autentification")if e.hasPassword()then
term.write("Enter Current Password: ")local
t=read('*')print("Checking password...")if not e.isRightPassword(t)then
printError("Incorrect password!")return end end
term.write("Enter New Password: ")local a=read('*')if#a<4 then
printError("Password must be 4 characters or more")return end
term.write("Repet the Password: ")local o=read('*')if a==o then
print("Saving new password...")e.newPassword(a)if term.isColor()then
term.setTextColour(colors.lime)end print("Password Changed")else
printError("Password does not match")end