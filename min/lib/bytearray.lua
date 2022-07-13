local e=bit32 and bit32.bxor or bit.bxor local t=bit32 and bit32.bor or bit.bor
local a a={fromBytes=function(o)return
setmetatable({o:byte(1,-1)},a)end,fromHex=function(i)local n={}for s in
i:gmatch("(%x%x)")do table.insert(n,tonumber(s,16))end return
setmetatable(n,a)end,__tostring=function(h)return
string.char(unpack(h))end,__index={toHex=function(r,d)return("%02x"):rep(#r):format(unpack(r))end,isEqual=function(l,u)if
type(u)~="table"then return false end if#l~=#u then return false end local c=0
for m=1,#l do c=t(c,e(l[m],u[m]))end return c==0 end,sub=function(f,w,y)local
p=#f+1 local v=w%p local b=(y or p-1)%p local g={}local k=1 for q=v,b,v<b and 1
or-1 do g[k]=f[q]k=k+1 end return setmetatable(g,a)end}}return
a