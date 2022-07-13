local e=require("/lib/bytearray")local t=2^32 local a=bit32 and bit32.band or
bit.band local o=bit32 and bit32.bor or bit.bor local i=bit32 and bit32.bnot or
bit.bnot local n=bit32 and bit32.bxor or bit.bxor local s=bit32 and
bit32.lshift or bit.blshift local h=unpack local r=function(d,l)local
u=d/(2^l)return u-u%1 end local c=function(m,f)local w=m/(2^(32-f))local y=w%1
return(w-y)+y*t end local
p={0x67452301,0xefcdab89,0x98badcfe,0x10325476,0xc3d2e1f0,}local function
v(b)local g,k=0,0 if 0xFFFFFFFF-g<b then k=k+1 g=b-(0xFFFFFFFF-g)-1 else g=g+b
end return k,g end local function q(j,x)return s((j[x]or 0),24)+s((j[x+1]or
0),16)+s((j[x+2]or 0),8)+(j[x+3]or 0)end local function z(E)local T=#E local
A={}E[#E+1]=0x80 while#E%64~=56 do E[#E+1]=0 end local O=math.ceil(#E/64)for
I=1,O do A[I]={}for N=1,16 do A[I][N]=q(E,1+((I-1)*64)+((N-1)*4))end end
A[O][15],A[O][16]=v(T*8)return A end local function S(H,R)for D=17,80 do
H[D]=c(n(H[D-3],H[D-8],H[D-14],H[D-16]),1)end local L,U,C,M,F=h(R)for W=1,80 do
local Y,P=0,0 if W<=20 then Y=o(a(U,C),a(i(U),M))P=0x5a827999 elseif W<=40 then
Y=n(U,C,M)P=0x6ed9eba1 elseif W<=60 then Y=o(a(U,C),a(U,M),a(C,M))P=0x8f1bbcdc
elseif W<=80 then Y=n(U,C,M)P=0xca62c1d6 end local V=(c(L,5)+Y+F+P+H[W])%t
L,U,C,M,F=V,L,c(U,30),C,M end R[1]=(R[1]+L)%t R[2]=(R[2]+U)%t R[3]=(R[3]+C)%t
R[4]=(R[4]+M)%t R[5]=(R[5]+F)%t return R end local function B(G,K)local Q={}for
J=1,K do
Q[(J-1)*4+1]=a(r(G[J],24),0xFF)Q[(J-1)*4+2]=a(r(G[J],16),0xFF)Q[(J-1)*4+3]=a(r(G[J],8),0xFF)Q[(J-1)*4+4]=a(G[J],0xFF)end
return setmetatable(Q,e)end local function X(Z)local Z=Z
or""Z=type(Z)=="table"and{h(Z)}or{tostring(Z):byte(1,-1)}Z=z(Z)local
et={h(p)}for tt=1,#Z do et=S(Z[tt],et)end return B(et,5)end local function
at(ot,it)local ot=type(ot)=="table"and{h(ot)}or{tostring(ot):byte(1,-1)}local
it=type(it)=="table"and{h(it)}or{tostring(it):byte(1,-1)}local nt=64 it=#it>nt
and X(it)or it local st={}local ht={}local rt={}for dt=1,nt do
st[dt]=n(0x36,it[dt]or 0)ht[dt]=n(0x5C,it[dt]or 0)end for lt=1,#ot do
st[nt+lt]=ot[lt]end st=X(st)for ut=1,nt do rt[ut]=ht[ut]rt[nt+ut]=st[ut]end
return X(rt)end
return{digest=X,hmac=at,}