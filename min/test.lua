local e=coroutine.create(function()print("Hello World!")end)local function
t(a)local o="{"for i,n in pairs(a)do if type(i)=="string"then
o=o.."[\""..i.."\"]".."="end if type(n)=="table"then o=o..t(n)elseif
type(n)=="boolean"then o=o..tostring(n)else o=o.."\""..tostring(n).."\""end
o=o..","end if o~=""then o=o:sub(1,o:len()-1)end return o.."}"end
print(e)print(t(processes))coroutine.resume(e)