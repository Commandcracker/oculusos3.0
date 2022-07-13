local e=require("/lib/bytearray")local t=2^32 local a=bit32.bor local
o=bit32.band local i=bit32.bnot local n=bit32.bxor local s=bit32.lshift local
h=unpack local function r(d,l)local u=d/(2^(32-l))local c=u%1 return(u-c)+c*t
end local function m(f,w)local y=f/(2^w)return y-y%1 end local
p={7,12,17,22,5,9,14,20,4,11,16,23,6,10,15,21,}local
v={0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,0x6b901122,0xfd987193,0xa679438e,0x49b40821,0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,0xd62f105d,0x02441453,0xd8a1e681,0xe7d3fbc8,0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,0x289b7ec6,0xeaa127fa,0xd4ef3085,0x04881d05,0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391,}local
b={0x67452301,0xefcdab89,0x98badcfe,0x10325476}local function g(k)local q,j=0,0
if 0xFFFFFFFF-q<k then j=j+1 q=k-(0xFFFFFFFF-q)-1 else q=q+k end return j,q end
local function x(z,E)return(z[E]or 0)+s((z[E+1]or 0),8)+s((z[E+2]or
0),16)+s((z[E+3]or 0),24)end local function T(A)local O=#A local
I={}A[#A+1]=0x80 while#A%64~=56 do A[#A+1]=0 end local N=math.ceil(#A/64)for
S=1,N do I[S]={}for H=1,16 do I[S][H]=x(A,1+((S-1)*64)+((H-1)*4))end end
I[N][16],I[N][15]=g(O*8)return I end local function R(D,L)local U,C,M,F=h(L)for
W=0,63 do local Y,P,V=0,W,m(W,4)if V==0 then Y=a(o(C,M),o(i(C),F))elseif V==1
then Y=a(o(F,C),o(i(F),M))P=(5*W+1)%16 elseif V==2 then Y=n(C,M,F)P=(3*W+5)%16
elseif V==3 then Y=n(M,a(C,i(F)))P=(7*W)%16 end local B=F
U,C,M,F=B,(C+r((U+Y+v[W+1]+D[P+1])%t,p[a(s(V,2),o(W,3))+1]))%t,C,M end
L[1]=(L[1]+U)%t L[2]=(L[2]+C)%t L[3]=(L[3]+M)%t L[4]=(L[4]+F)%t return L end
local function G(K,Q)local J={}for X=1,Q do
J[(X-1)*4+1]=o(K[X],0xFF)J[(X-1)*4+2]=o(m(K[X],8),0xFF)J[(X-1)*4+3]=o(m(K[X],16),0xFF)J[(X-1)*4+4]=o(m(K[X],24),0xFF)end
return setmetatable(J,e)end function digest(Z)Z=Z
or""Z=type(Z)=="string"and{Z:byte(1,-1)}or Z Z=T(Z)local et={h(b)}for tt=1,#Z
do et=R(Z[tt],et)end return G(et,4)end
return{digest=digest,}