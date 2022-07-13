local e=require("/lib/bytearray")local t=2^32 local a=bit32 and bit32.band or
bit.band local o=bit32 and bit32.bnot or bit.bnot local i=bit32 and bit32.bxor
or bit.bxor local n=bit32 and bit32.lshift or bit.blshift local s=unpack local
function h(r,d)local l=r/(2^d)local u=l%1 return(l-u)+u*t end local function
c(m,f)local w=m/(2^f)return w-w%1 end local
y={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19,}local
p={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2,}local
function v(b)local g,k=0,0 if 0xFFFFFFFF-g<b then k=k+1 g=b-(0xFFFFFFFF-g)-1
else g=g+b end return k,g end local function q(j,x)return n((j[x]or
0),24)+n((j[x+1]or 0),16)+n((j[x+2]or 0),8)+(j[x+3]or 0)end local function
z(E)local T=#E local A={}E[#E+1]=0x80 while#E%64~=56 do E[#E+1]=0 end local
O=math.ceil(#E/64)for I=1,O do A[I]={}for N=1,16 do
A[I][N]=q(E,1+((I-1)*64)+((N-1)*4))end end A[O][15],A[O][16]=v(T*8)return A end
local function S(H,R)for D=17,64 do local L=H[D-15]local
U=i(h(H[D-15],7),h(H[D-15],18),c(H[D-15],3))local
C=i(h(H[D-2],17),h(H[D-2],19),c(H[D-2],10))H[D]=(H[D-16]+U+H[D-7]+C)%t end
local M,F,W,Y,P,V,B,G=s(R)for K=1,64 do local Q=i(h(P,6),h(P,11),h(P,25))local
J=i(a(P,V),a(o(P),B))local X=(G+Q+J+p[K]+H[K])%t local
Z=i(h(M,2),h(M,13),h(M,22))local et=i(i(a(M,F),a(M,W)),a(F,W))local tt=(Z+et)%t
G,B,V,P,Y,W,F,M=B,V,P,(Y+X)%t,W,F,M,(X+tt)%t end R[1]=(R[1]+M)%t
R[2]=(R[2]+F)%t R[3]=(R[3]+W)%t R[4]=(R[4]+Y)%t R[5]=(R[5]+P)%t R[6]=(R[6]+V)%t
R[7]=(R[7]+B)%t R[8]=(R[8]+G)%t return R end local function at(ot,it)local
nt={}for st=1,it do
nt[(st-1)*4+1]=a(c(ot[st],24),0xFF)nt[(st-1)*4+2]=a(c(ot[st],16),0xFF)nt[(st-1)*4+3]=a(c(ot[st],8),0xFF)nt[(st-1)*4+4]=a(ot[st],0xFF)end
return setmetatable(nt,e)end local function ht(rt)local rt=rt
or""rt=type(rt)=="table"and{s(rt)}or{tostring(rt):byte(1,-1)}rt=z(rt)local
dt={s(y)}for lt=1,#rt do dt=S(rt[lt],dt)end return at(dt,8)end local function
ut(ct,mt)local ct=type(ct)=="table"and{s(ct)}or{tostring(ct):byte(1,-1)}local
mt=type(mt)=="table"and{s(mt)}or{tostring(mt):byte(1,-1)}local ft=64 mt=#mt>ft
and ht(mt)or mt local wt={}local yt={}local pt={}for vt=1,ft do
wt[vt]=i(0x36,mt[vt]or 0)yt[vt]=i(0x5C,mt[vt]or 0)end for bt=1,#ct do
wt[ft+bt]=ct[bt]end wt=ht(wt)for gt=1,ft do pt[gt]=yt[gt]pt[ft+gt]=wt[gt]end
return ht(pt)end local function kt(qt,jt,xt,zt)local jt=type(jt)=="table"and jt
or{tostring(jt):byte(1,-1)}local Et=32 local zt=zt or 32 local Tt=1 local
At={}while zt>0 do local Ot={}local It={s(jt)}local Nt=zt>Et and Et or zt
It[#It+1]=a(c(Tt,24),0xFF)It[#It+1]=a(c(Tt,16),0xFF)It[#It+1]=a(c(Tt,8),0xFF)It[#It+1]=a(Tt,0xFF)for
St=1,xt do It=ut(It,qt)for Ht=1,Nt do Ot[Ht]=i(It[Ht],Ot[Ht]or 0)end if
St%200==0 then os.queueEvent("PBKDF2",St)coroutine.yield("PBKDF2")end end
zt=zt-Nt Tt=Tt+1 for Rt=1,Nt do At[#At+1]=Ot[Rt]end end return
setmetatable(At,e)end
return{digest=ht,hmac=ut,pbkdf2=kt}