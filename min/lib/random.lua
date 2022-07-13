local e=require("/lib/sha256")local function t(a)local o=""for i=1,a do
o=o..string.char(math.random(0,255))end return o end local function n()return
tostring(math.random(1,2^31-1))end local function s()return
tostring({}):sub(-8)end local function h(r)local d=r or""local function l()if
math.random(0,1)==0 then d=d..n()..s()else d=d..s()..n()end end local function
u(...)for c,m in ipairs({...})do d=d..tostring(m)end end
u(os.version())u(os.epoch())u(os.epoch("utc"))u(os.epoch("local"))u(os.getComputerID())u(os.getComputerLabel())u(_G._VERSION)u(_G._HOST)u(term.getCursorPos())u(term.getCursorBlink())u(term.getTextColor())u(term.getBackgroundColor())u(term.isColor())u(fs.getFreeSpace("/"))u(fs.getCapacity("/"))if
turtle then u(turtle.getFuelLevel())end for f,w in
pairs(peripheral.getNames())do u(w)local y=peripheral.wrap(w)local
p={peripheral.getType(y)}u(unpack(p))local function v(b,g)for f,k in pairs(b)do
if k==g then return true end end return false end if v(p,"computer")then
u(y.getID(),y.isOn(),y.getLabel())elseif v(p,"inventory")then u(y.size())for
f,q in pairs(y.list())do u(q.name,q.count,q.nbt)end elseif v(p,"printer")then
u(y.getPaperLevel(),y.getInkLevel())elseif v(p,"modem")then
u(y.isWireless())elseif v(p,"monitor")then
u(y.getTextScale())u(y.getCursorPos())u(y.getCursorBlink())u(y.getSize())u(y.getTextColour())u(y.getBackgroundColor())u(y.isColor())elseif
v(p,"drive")then
u(y.isDiskPresent())u(y.getDiskLabel())u(y.hasData())u(y.getMountPath())u(y.hasAudio())u(y.getAudioTitle())u(y.getDiskID())end
end for j=1,500 do l()end return e.digest(d)end
return{random=h,pseudo={randomString=t,randomMemoryAddress=s,bigRandom=n}}