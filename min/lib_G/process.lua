_G.processes={}local e={}e.create=coroutine.create function
coroutine.create(t)local a={}local function
o(...)print("fff")print()a.status=coroutine.status(coroutine.running())a.name=math.random(1,100)t(...)end
local i=e.create(o)a.thread=i table.insert(processes,a)return i
end