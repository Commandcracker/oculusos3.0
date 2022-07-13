local e=os.pullEvent os.pullEvent=os.pullEventRaw local
t=require("/lib/sha256")local a=require("/lib/oculus/autentification")if
a.hasPassword()then
term.setBackgroundColor(colors.black)term.clear()term.setCursorPos(1,1)while
true do term.write("Enter Password: ")local o=read('*')if
a.isRightPassword(o)then
term.setBackgroundColor(colors.black)term.clear()term.setCursorPos(1,1)term.setTextColor(colors.green)term.write("Oculus OS 1.0b ")term.setTextColor(colors.lightGray)term.write("(")term.setTextColor(colors.orange)term.write(os.version())term.setTextColor(colors.lightGray)term.write(")")print()break
else printError("Incorrect password!")end end else
printError("No password has been set")end
os.pullEvent=e