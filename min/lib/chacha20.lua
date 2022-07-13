local e=require("/lib/bytearray")local t=2^32 local a=bit32.bor local
o=bit32.bxor local i=bit32.band local n=bit32.lshift local s=bit32.arshift
local h={("expand 16-byte k"):byte(1,-1)}local
r={("expand 32-byte k"):byte(1,-1)}local d={("A"):rep(32):byte(1,-1)}local
l={("A"):rep(12):byte(1,-1)}local function u(c,m)local f=c/(2^(32-m))local
w=f%1 return(f-w)+w*t end local function
y(p,v,b,g,k)p[v]=(p[v]+p[b])%t;p[k]=u(o(p[k],p[v]),16)p[g]=(p[g]+p[k])%t;p[b]=u(o(p[b],p[g]),12)p[v]=(p[v]+p[b])%t;p[k]=u(o(p[k],p[v]),8)p[g]=(p[g]+p[k])%t;p[b]=u(o(p[b],p[g]),7)return
p end local function q(j,x)local z={unpack(j)}for E=1,x do local T=E%2==1 z=T
and y(z,1,5,9,13)or y(z,1,6,11,16)z=T and y(z,2,6,10,14)or y(z,2,7,12,13)z=T
and y(z,3,7,11,15)or y(z,3,8,9,14)z=T and y(z,4,8,12,16)or y(z,4,5,10,15)end
for A=1,16 do z[A]=(z[A]+j[A])%t end return z end local function
O(I,N)return(I[N+1]or 0)+n((I[N+2]or 0),8)+n((I[N+3]or 0),16)+n((I[N+4]or
0),24)end local function S(H,R,D)local L=#H==32 local U=L and r or h local
C={}C[1]=O(U,0)C[2]=O(U,4)C[3]=O(U,8)C[4]=O(U,12)C[5]=O(H,0)C[6]=O(H,4)C[7]=O(H,8)C[8]=O(H,12)C[9]=O(H,L
and 16 or 0)C[10]=O(H,L and 20 or 4)C[11]=O(H,L and 24 or 8)C[12]=O(H,L and 28
or 12)C[13]=D C[14]=O(R,0)C[15]=O(R,4)C[16]=O(R,8)return C end local function
M(F)local W={}for Y=1,16 do
W[#W+1]=i(F[Y],0xFF)W[#W+1]=i(s(F[Y],8),0xFF)W[#W+1]=i(s(F[Y],16),0xFF)W[#W+1]=i(s(F[Y],24),0xFF)end
return W end local function
P(V,B,G,K,Q)assert(type(B)=="table","ChaCha20: Invalid key format ("..type(B).."), must be table")assert(type(G)=="table","ChaCha20: Invalid nonce format ("..type(G).."), must be table")assert(#B==16
or#B==32,"ChaCha20: Invalid key length ("..#B.."), must be 16 or 32")assert(#G==12,"ChaCha20: Invalid nonce length ("..#G.."), must be 12")local
V=type(V)=="table"and{unpack(V)}or{tostring(V):byte(1,-1)}K=tonumber(K)or 1
Q=tonumber(Q)or 20 local J={}local X=S(B,G,K)local Z=math.floor(#V/64)for
et=0,Z do local tt=M(q(X,Q))X[13]=(X[13]+1)%t local at={}for ot=1,64 do
at[ot]=V[((et)*64)+ot]end for it=1,#at do J[#J+1]=o(at[it],tt[it])end if
et%1000==0 then os.queueEvent("")os.pullEvent("")end end return
setmetatable(J,e)end local function nt(st)local ht={}for rt=1,st do
ht[rt]=math.random(0,0xFF)end return setmetatable(ht,e)end local dt={}local
lt={__index=dt}local function ut(ct)local mt={}mt.seed=ct mt.cnt=0
mt.block={}return setmetatable(mt,lt)end function dt:nextInt(ft)if not ft or
ft<1 or ft>6 then error("Can only return 1-6 bytes",2)end local wt=0 for
yt=0,ft-1 do if#self.block==0 then self.cnt=self.cnt+1
self.block=P(d,self.seed,l,self.cnt)end local
pt=table.remove(self.block)wt=wt+(pt*(2^(8*yt)))end return wt end
return{crypt=P,genNonce=nt,newRNG=ut}