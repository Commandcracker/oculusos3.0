local e=os.pullEvent os.pullEvent=os.pullEventRaw for t,a in
ipairs(fs.list("/lib_G"))do if string.sub(a,1,1)~="."then local o="/lib_G/"..a
if not fs.isDir(o)then dofile(o)end end end local i={}function
i.build(...)local n=table.pack(...)for s=1,1 do local arg=n[s]if arg~=nil then
if type(arg)=="function"then arg={arg}n[s]=arg end end end return
function(h,r,d,l)local arg=n[r]if not arg then if r<=n.n then return end
arg=n[n.n]if not arg or not arg.many then return end end return
arg[1](h,d,l,table.unpack(arg,2))end end function i.dir(u,c)return
fs.complete(c,u.dir(),false,true)end function i.file(m,f)return
fs.complete(f,m.dir(),true,false)end
shell.setPath(shell.path()..":/bin")shell.setCompletionFunction("bin/cat.lua",i.build(i.file))term.clear()term.setCursorPos(1,1)local
w=require("/lib/sha256")local y=require("/lib/oculus/autentification")if
y.hasPassword()then while true do term.write("Enter Password: ")local
p=read('*')if y.isRightPassword(p)then break else
printError("Incorrect password!")end end end
term.clear()term.setCursorPos(1,1)term.setTextColor(colors.green)term.write("Oculus OS 1.0b ")term.setTextColor(colors.lightGray)term.write("(")term.setTextColor(colors.orange)term.write(os.version())term.setTextColor(colors.lightGray)term.write(")")print()os.pullEvent=e