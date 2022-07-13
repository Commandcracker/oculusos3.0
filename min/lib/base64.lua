local e=require("/lib/bytearray")local
t="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="local
a,o={},{}local i=bit32 and bit32.lshift or bit.blshift local n=bit32 and
bit32.rshift or bit.brshift local s=bit32 and bit32.band or bit.band local
h=bit32 and bit32.bor or bit.bor for r=1,#t do local d=t:sub(r,r)a[r-1]=d
o[d]=r-1 end local function l(u)local u=type(u)=="table"and u
or{tostring(u):byte(1,-1)}local c={}local m for f=1,#u,3 do
m=n(s(u[f],0xFC),2)c[#c+1]=a[m]m=i(s(u[f],0x03),4)if f+0<#u then
m=h(m,n(s(u[f+1],0xF0),4))c[#c+1]=a[m]m=i(s(u[f+1],0x0F),2)if f+1<#u then
m=h(m,n(s(u[f+2],0xC0),6))c[#c+1]=a[m]m=s(u[f+2],0x3F)c[#c+1]=a[m]else
c[#c+1]=a[m].."="end else c[#c+1]=a[m].."=="end end return table.concat(c)end
local function w(y)local p={}local v={}for b in y:gmatch(".")do v[#v+1]=b end
for g=1,#v,4 do local
k={o[v[g]],o[v[g+1]],o[v[g+2]],o[v[g+3]]}p[#p+1]=h(i(k[1],2),n(k[2],4))%256 if
k[3]<64 then p[#p+1]=h(i(k[2],4),n(k[3],2))%256 if k[4]<64 then
p[#p+1]=h(i(k[3],6),k[4])%256 end end end return setmetatable(p,e)end
return{encode=l,decode=w,}