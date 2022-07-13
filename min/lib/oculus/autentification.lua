local e=require("/lib/base64")local t=require("/lib/sha256")local
a=require("/lib/random")local function o()local
i=fs.open("/etc/shadow","r")local
n,s,h,r,d,l,u,c,m=i.readLine():match("(.*):(.*):(.*):(.*):(.*):(.*):(.*):(.*):")i.close()local
f,w,y=s:match("$(.*)$(.*)$(.*)")return{name=n,passwordDetails={hashType=f,salt=e.decode(w),password=e.decode(y)},change=h,minAge=r,maxAge=d,warning=l,inactivity=u,expiration=c,unused=m}end
local function p()return fs.exists("/etc/shadow")end local function v(b,g)local
k=a.random(g)local q=t.pbkdf2(b,k,2000)local j=e.encode(q)local
x=fs.open("/etc/shadow","w")x.write("root:".."$5$"..e.encode(k).."$"..j..":"..os.epoch("utc")..":0:99999:7:::")x.close()end
local function z(E)local T=o()local
A=t.pbkdf2(E,T.passwordDetails.salt,2000)return
T.passwordDetails.password:isEqual(A)end
return{hasPassword=p,newPassword=v,isRightPassword=z}