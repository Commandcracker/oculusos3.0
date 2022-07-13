local function e(t)local a=setmetatable({},{__index=_ENV or getfenv()})if
setfenv then setfenv(t,a)end return t(a)or a end local o=e(function(i,...)local
n=math.floor local s,h h=function(r,d)return n(r%4294967296/2^d)end
s=function(l,u)return(l*2^u)%4294967296 end
return{bnot=bit.bnot,band=bit.band,bor=bit.bor,bxor=bit.bxor,rshift=h,lshift=s,}end)local
c=e(function(m,...)local f=o.bxor local y=o.lshift local p=0x100 local v=0xff
local b=0x11b local g={}local k={}local function q(j,x)return f(j,x)end local
function z(E,T)return f(E,T)end local function A(O)if(O==1)then return 1 end
local I=v-k[O]return g[I]end local function N(S,H)if(S==0 or H==0)then return 0
end local R=k[S]+k[H]if(R>=v)then R=R-v end return g[R]end local function
D(L,U)if(L==0)then return 0 end local C=k[L]-k[U]if(C<0)then C=C+v end return
g[C]end local function M()for F=1,p do print("log(",F-1,")=",k[F-1])end end
local function W()for Y=1,p do print("exp(",Y-1,")=",g[Y-1])end end local
function P()local V=1 for B=0,v-1 do g[B]=V k[V]=B V=f(y(V,1),V)if V>v then
V=z(V,b)end end end
P()return{add=q,sub=z,invert=A,mul=N,div=dib,printLog=M,printExp=W,}end)local
G=e(function(K,...)local Q=o.bxor local J=o.rshift local X=o.band local
Z=o.lshift local et local function
tt(at)at=Q(at,J(at,4))at=Q(at,J(at,2))at=Q(at,J(at,1))return X(at,1)end local
function ot(it,nt)if(nt==0)then return X(it,0xff)else return
X(J(it,nt*8),0xff)end end local function st(ht,rt)if(rt==0)then return
X(ht,0xff)else return Z(X(ht,0xff),rt*8)end end local function
dt(lt,ut,ct)local mt={}for ft=0,ct-1 do
mt[ft+1]=st(lt[ut+(ft*4)],3)+st(lt[ut+(ft*4)+1],2)+st(lt[ut+(ft*4)+2],1)+st(lt[ut+(ft*4)+3],0)if
ct%10000==0 then et()end end return mt end local function wt(yt,pt,vt,bt)bt=bt
or#yt for gt=0,bt-1 do for kt=0,3 do pt[vt+gt*4+(3-kt)]=ot(yt[gt+1],kt)end if
bt%10000==0 then et()end end return pt end local function qt(jt)local xt=""for
zt,Et in ipairs(jt)do xt=xt..string.format("%02x ",Et)end return xt end local
function Tt(At)local Ot={}for It=1,#At,2 do
Ot[#Ot+1]=tonumber(At:sub(It,It+1),16)end return Ot end local function
Nt(St)local Ht=type(St)if(Ht=="number")then return
string.format("%08x",St)elseif(Ht=="table")then return
qt(St)elseif(Ht=="string")then local Rt={string.byte(St,1,#St)}return
qt(Rt)else return St end end local function Dt(Lt)local Ut=#Lt local
Ct=math.random(0,255)local Mt=math.random(0,255)local
Ft=string.char(Ct,Mt,Ct,Mt,ot(Ut,3),ot(Ut,2),ot(Ut,1),ot(Ut,0))Lt=Ft..Lt local
Wt=math.ceil(#Lt/16)*16-#Lt local Yt=""for Pt=1,Wt do
Yt=Yt..string.char(math.random(0,255))end return Lt..Yt end local function
Vt(Bt)local Gt={string.byte(Bt,1,4)}if(Gt[1]==Gt[3]and Gt[2]==Gt[4])then return
true end return false end local function Kt(Qt)if(not Vt(Qt))then return nil
end local
Jt=st(string.byte(Qt,5),3)+st(string.byte(Qt,6),2)+st(string.byte(Qt,7),1)+st(string.byte(Qt,8),0)return
string.sub(Qt,9,8+Jt)end local function Xt(Zt,ea)for ta=1,16 do
Zt[ta]=Q(Zt[ta],ea[ta])end end local function aa(oa)local ia=16 while true do
local na=oa[ia]+1 if na>=256 then oa[ia]=na-256 ia=(ia-2)%16+1 else oa[ia]=na
break end end end local sa,ha,ra=os.queueEvent,coroutine.yield,os.time local
da=ra()local function et()local la=ra()if la-da>=0.03 then da=la
sa("sleep")ha("sleep")end end local function ua(ca)local
ma,fa,wa,ya=string.char,math.random,et,table.insert local pa={}for va=1,ca do
ya(pa,fa(0,255))if va%10240==0 then wa()end end return pa end local function
ba(ga)local ka,qa,ja,xa=string.char,math.random,et,table.insert local za={}for
Ea=1,ga do xa(za,ka(qa(0,255)))if Ea%10240==0 then ja()end end return
table.concat(za)end
return{byteParity=tt,getByte=ot,putByte=st,bytesToInts=dt,intsToBytes=wt,bytesToHex=qt,hexToBytes=Tt,toHexString=Nt,padByteString=Dt,properlyDecrypted=Vt,unpadByteString=Kt,xorIV=Xt,increment=aa,sleepCheckIn=et,getRandomData=ua,getRandomString=ba,}end)local
Ta=e(function(Aa,...)local Oa=G.putByte local Ia=G.getByte local
Na='rounds'local Sa="type"local Ha=1 local Ra=2 local Da={}local La={}local
Ua={}local Ca={}local Ma={}local Fa={}local Wa={}local Ya={}local Pa={}local
Va={}local
Ba={0x01000000,0x02000000,0x04000000,0x08000000,0x10000000,0x20000000,0x40000000,0x80000000,0x1b000000,0x36000000,0x6c000000,0xd8000000,0xab000000,0x4d000000,0x9a000000,0x2f000000,}local
function Ga(Ka)mask=0xf8 local Qa=0 for Ja=1,8 do
Qa=o.lshift(Qa,1)parity=G.byteParity(o.band(Ka,mask))Qa=Qa+parity
lastbit=o.band(mask,1)mask=o.band(o.rshift(mask,1),0xff)if(lastbit~=0)then
mask=o.bor(mask,0x80)else mask=o.band(mask,0x7f)end end return
o.bxor(Qa,0x63)end local function Xa()for Za=0,255 do if(Za~=0)then
inverse=c.invert(Za)else inverse=Za end mapped=Ga(inverse)Da[Za]=mapped
La[mapped]=Za end end local function eo()for to=0,255 do local
ao=Da[to]Ua[to]=Oa(c.mul(0x03,ao),0)+Oa(ao,1)+Oa(ao,2)+Oa(c.mul(0x02,ao),3)Ca[to]=Oa(ao,0)+Oa(ao,1)+Oa(c.mul(0x02,ao),2)+Oa(c.mul(0x03,ao),3)Ma[to]=Oa(ao,0)+Oa(c.mul(0x02,ao),1)+Oa(c.mul(0x03,ao),2)+Oa(ao,3)Fa[to]=Oa(c.mul(0x02,ao),0)+Oa(c.mul(0x03,ao),1)+Oa(ao,2)+Oa(ao,3)end
end local function oo()for io=0,255 do local
no=La[io]Wa[io]=Oa(c.mul(0x0b,no),0)+Oa(c.mul(0x0d,no),1)+Oa(c.mul(0x09,no),2)+Oa(c.mul(0x0e,no),3)Ya[io]=Oa(c.mul(0x0d,no),0)+Oa(c.mul(0x09,no),1)+Oa(c.mul(0x0e,no),2)+Oa(c.mul(0x0b,no),3)Pa[io]=Oa(c.mul(0x09,no),0)+Oa(c.mul(0x0e,no),1)+Oa(c.mul(0x0b,no),2)+Oa(c.mul(0x0d,no),3)Va[io]=Oa(c.mul(0x0e,no),0)+Oa(c.mul(0x0b,no),1)+Oa(c.mul(0x0d,no),2)+Oa(c.mul(0x09,no),3)end
end local function so(ho)local
ro=o.band(ho,0xff000000)return(o.lshift(ho,8)+o.rshift(ro,24))end local
function lo(uo)return
Oa(Da[Ia(uo,0)],0)+Oa(Da[Ia(uo,1)],1)+Oa(Da[Ia(uo,2)],2)+Oa(Da[Ia(uo,3)],3)end
local function co(mo)local fo={}local wo=math.floor(#mo/4)if((wo~=4 and wo~=6
and wo~=8)or(wo*4~=#mo))then error("Invalid key size: "..tostring(wo))return
nil end fo[Na]=wo+6 fo[Sa]=Ha for yo=0,wo-1 do
fo[yo]=Oa(mo[yo*4+1],3)+Oa(mo[yo*4+2],2)+Oa(mo[yo*4+3],1)+Oa(mo[yo*4+4],0)end
for po=wo,(fo[Na]+1)*4-1 do local vo=fo[po-1]if(po%wo==0)then
vo=so(vo)vo=lo(vo)local bo=math.floor(po/wo)vo=o.bxor(vo,Ba[bo])elseif(wo>6 and
po%wo==4)then vo=lo(vo)end fo[po]=o.bxor(fo[(po-wo)],vo)end return fo end local
function go(ko)local qo=Ia(ko,3)local jo=Ia(ko,2)local xo=Ia(ko,1)local
zo=Ia(ko,0)return
Oa(c.add(c.add(c.add(c.mul(0x0b,jo),c.mul(0x0d,xo)),c.mul(0x09,zo)),c.mul(0x0e,qo)),3)+Oa(c.add(c.add(c.add(c.mul(0x0b,xo),c.mul(0x0d,zo)),c.mul(0x09,qo)),c.mul(0x0e,jo)),2)+Oa(c.add(c.add(c.add(c.mul(0x0b,zo),c.mul(0x0d,qo)),c.mul(0x09,jo)),c.mul(0x0e,xo)),1)+Oa(c.add(c.add(c.add(c.mul(0x0b,qo),c.mul(0x0d,jo)),c.mul(0x09,xo)),c.mul(0x0e,zo)),0)end
local function Eo(To)local Ao=Ia(To,3)local Oo=Ia(To,2)local Io=Ia(To,1)local
No=Ia(To,0)local So=o.bxor(No,Io)local Ho=o.bxor(Oo,Ao)local
Ro=o.bxor(So,Ho)Ro=o.bxor(Ro,c.mul(0x08,Ro))w=o.bxor(Ro,c.mul(0x04,o.bxor(Io,Ao)))Ro=o.bxor(Ro,c.mul(0x04,o.bxor(No,Oo)))return
Oa(o.bxor(o.bxor(No,Ro),c.mul(0x02,o.bxor(Ao,No))),0)+Oa(o.bxor(o.bxor(Io,w),c.mul(0x02,So)),1)+Oa(o.bxor(o.bxor(Oo,Ro),c.mul(0x02,o.bxor(Ao,No))),2)+Oa(o.bxor(o.bxor(Ao,w),c.mul(0x02,Ho)),3)end
local function Do(Lo)local Uo=co(Lo)if(Uo==nil)then return nil end Uo[Sa]=Ra
for Co=4,(Uo[Na]+1)*4-5 do Uo[Co]=go(Uo[Co])end return Uo end local function
Mo(Fo,Wo,Yo)for Po=0,3 do Fo[Po+1]=o.bxor(Fo[Po+1],Wo[Yo*4+Po])end end local
function
Vo(Bo,Go)Go[1]=o.bxor(o.bxor(o.bxor(Ua[Ia(Bo[1],3)],Ca[Ia(Bo[2],2)]),Ma[Ia(Bo[3],1)]),Fa[Ia(Bo[4],0)])Go[2]=o.bxor(o.bxor(o.bxor(Ua[Ia(Bo[2],3)],Ca[Ia(Bo[3],2)]),Ma[Ia(Bo[4],1)]),Fa[Ia(Bo[1],0)])Go[3]=o.bxor(o.bxor(o.bxor(Ua[Ia(Bo[3],3)],Ca[Ia(Bo[4],2)]),Ma[Ia(Bo[1],1)]),Fa[Ia(Bo[2],0)])Go[4]=o.bxor(o.bxor(o.bxor(Ua[Ia(Bo[4],3)],Ca[Ia(Bo[1],2)]),Ma[Ia(Bo[2],1)]),Fa[Ia(Bo[3],0)])end
local function
Ko(Qo,Jo)Jo[1]=Oa(Da[Ia(Qo[1],3)],3)+Oa(Da[Ia(Qo[2],2)],2)+Oa(Da[Ia(Qo[3],1)],1)+Oa(Da[Ia(Qo[4],0)],0)Jo[2]=Oa(Da[Ia(Qo[2],3)],3)+Oa(Da[Ia(Qo[3],2)],2)+Oa(Da[Ia(Qo[4],1)],1)+Oa(Da[Ia(Qo[1],0)],0)Jo[3]=Oa(Da[Ia(Qo[3],3)],3)+Oa(Da[Ia(Qo[4],2)],2)+Oa(Da[Ia(Qo[1],1)],1)+Oa(Da[Ia(Qo[2],0)],0)Jo[4]=Oa(Da[Ia(Qo[4],3)],3)+Oa(Da[Ia(Qo[1],2)],2)+Oa(Da[Ia(Qo[2],1)],1)+Oa(Da[Ia(Qo[3],0)],0)end
local function
Xo(Zo,ei)ei[1]=o.bxor(o.bxor(o.bxor(Wa[Ia(Zo[1],3)],Ya[Ia(Zo[4],2)]),Pa[Ia(Zo[3],1)]),Va[Ia(Zo[2],0)])ei[2]=o.bxor(o.bxor(o.bxor(Wa[Ia(Zo[2],3)],Ya[Ia(Zo[1],2)]),Pa[Ia(Zo[4],1)]),Va[Ia(Zo[3],0)])ei[3]=o.bxor(o.bxor(o.bxor(Wa[Ia(Zo[3],3)],Ya[Ia(Zo[2],2)]),Pa[Ia(Zo[1],1)]),Va[Ia(Zo[4],0)])ei[4]=o.bxor(o.bxor(o.bxor(Wa[Ia(Zo[4],3)],Ya[Ia(Zo[3],2)]),Pa[Ia(Zo[2],1)]),Va[Ia(Zo[1],0)])end
local function
ti(ai,oi)oi[1]=Oa(La[Ia(ai[1],3)],3)+Oa(La[Ia(ai[4],2)],2)+Oa(La[Ia(ai[3],1)],1)+Oa(La[Ia(ai[2],0)],0)oi[2]=Oa(La[Ia(ai[2],3)],3)+Oa(La[Ia(ai[1],2)],2)+Oa(La[Ia(ai[4],1)],1)+Oa(La[Ia(ai[3],0)],0)oi[3]=Oa(La[Ia(ai[3],3)],3)+Oa(La[Ia(ai[2],2)],2)+Oa(La[Ia(ai[1],1)],1)+Oa(La[Ia(ai[4],0)],0)oi[4]=Oa(La[Ia(ai[4],3)],3)+Oa(La[Ia(ai[3],2)],2)+Oa(La[Ia(ai[2],1)],1)+Oa(La[Ia(ai[1],0)],0)end
local function ii(ni,si,hi,ri,di)hi=hi or 1 ri=ri or{}di=di or 1 local
li={}local ui={}if(ni[Sa]~=Ha)then
error("No encryption key: "..tostring(ni[Sa])..", expected "..Ha)return end
li=G.bytesToInts(si,hi,4)Mo(li,ni,0)local ci=1 while(ci<ni[Na]-1)do
Vo(li,ui)Mo(ui,ni,ci)ci=ci+1 Vo(ui,li)Mo(li,ni,ci)ci=ci+1 end
Vo(li,ui)Mo(ui,ni,ci)ci=ci+1 Ko(ui,li)Mo(li,ni,ci)G.sleepCheckIn()return
G.intsToBytes(li,ri,di)end local function mi(fi,wi,yi,pi,vi)yi=yi or 1 pi=pi
or{}vi=vi or 1 local bi={}local gi={}if(fi[Sa]~=Ra)then
error("No decryption key: "..tostring(fi[Sa]))return end
bi=G.bytesToInts(wi,yi,4)Mo(bi,fi,fi[Na])local ki=fi[Na]-1 while(ki>2)do
Xo(bi,gi)Mo(gi,fi,ki)ki=ki-1 Xo(gi,bi)Mo(bi,fi,ki)ki=ki-1 end
Xo(bi,gi)Mo(gi,fi,ki)ki=ki-1 ti(gi,bi)Mo(bi,fi,ki)G.sleepCheckIn()return
G.intsToBytes(bi,pi,vi)end
Xa()eo()oo()return{ROUNDS=Na,KEY_TYPE=Sa,ENCRYPTION_KEY=Ha,DECRYPTION_KEY=Ra,expandEncryptionKey=co,expandDecryptionKey=Do,encrypt=ii,decrypt=mi,}end)local
qi=e(function(ji,...)local function xi()return{}end local function
zi(Ei,Ti)table.insert(Ei,Ti)end local function Ai(Oi)return table.concat(Oi)end
return{new=xi,addString=zi,toString=Ai,}end)local Ii=e(function(Ni,...)local
Si={}local Hi=math.random function Si.encryptString(Ri,Di,Li,Ui)if Ui then
local Ci={}for Mi=1,16 do Ci[Mi]=Ui[Mi]end Ui=Ci else
Ui={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}end local
Fi=Ta.expandEncryptionKey(Ri)local Wi=qi.new()for Yi=1,#Di/16 do local
Pi=(Yi-1)*16+1 local
Vi={string.byte(Di,Pi,Pi+15)}Ui=Li(Fi,Vi,Ui)qi.addString(Wi,string.char(unpack(Vi)))end
return qi.toString(Wi)end function
Si.encryptECB(Bi,Gi,Ki)Ta.encrypt(Bi,Gi,1,Gi,1)end function
Si.encryptCBC(Qi,Ji,Xi)G.xorIV(Ji,Xi)Ta.encrypt(Qi,Ji,1,Ji,1)return Ji end
function Si.encryptOFB(Zi,en,tn)Ta.encrypt(Zi,tn,1,tn,1)G.xorIV(en,tn)return tn
end function
Si.encryptCFB(an,on,nn)Ta.encrypt(an,nn,1,nn,1)G.xorIV(on,nn)return on end
function Si.encryptCTR(sn,hn,rn)local dn={}for ln=1,16 do dn[ln]=rn[ln]end
Ta.encrypt(sn,rn,1,rn,1)G.xorIV(hn,rn)G.increment(dn)return dn end function
Si.decryptString(un,cn,mn,fn)if fn then local wn={}for yn=1,16 do
wn[yn]=fn[yn]end fn=wn else fn={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}end local pn if
mn==Si.decryptOFB or mn==Si.decryptCFB or mn==Si.decryptCTR then
pn=Ta.expandEncryptionKey(un)else pn=Ta.expandDecryptionKey(un)end local
vn=qi.new()for bn=1,#cn/16 do local gn=(bn-1)*16+1 local
kn={string.byte(cn,gn,gn+15)}fn=mn(pn,kn,fn)qi.addString(vn,string.char(unpack(kn)))end
return qi.toString(vn)end function
Si.decryptECB(qn,jn,xn)Ta.decrypt(qn,jn,1,jn,1)return xn end function
Si.decryptCBC(zn,En,Tn)local An={}for On=1,16 do An[On]=En[On]end
Ta.decrypt(zn,En,1,En,1)G.xorIV(En,Tn)return An end function
Si.decryptOFB(In,Nn,Sn)Ta.encrypt(In,Sn,1,Sn,1)G.xorIV(Nn,Sn)return Sn end
function Si.decryptCFB(Hn,Rn,Dn)local Ln={}for Un=1,16 do Ln[Un]=Rn[Un]end
Ta.encrypt(Hn,Dn,1,Dn,1)G.xorIV(Rn,Dn)return Ln end Si.decryptCTR=Si.encryptCTR
return Si end)local Cn=16 local Mn=24 local Fn=32 local Wn=1 local Yn=2 local
Pn=3 local Vn=4 local Bn=4 local function Gn(Kn,Qn,Jn)local Xn=Qn
if(Qn==Mn)then Xn=32 end if(Xn>#Kn)then local Zn=""for es=1,Xn-#Kn do
Zn=Zn..string.char(0)end Kn=Kn..Zn else Kn=string.sub(Kn,1,Xn)end local
ts={string.byte(Kn,1,#Kn)}Kn=Ii.encryptString(ts,Kn,Ii.encryptCBC,Jn)Kn=string.sub(Kn,1,Qn)return{string.byte(Kn,1,#Kn)}end
local function
as(is,ns,ss,hs,rs)assert(is~=nil,"Empty password.")assert(is~=nil,"Empty data.")local
hs=hs or Yn local ss=ss or Cn local ds=Gn(is,ss,rs)local
ls=G.padByteString(ns)if hs==Wn then return
Ii.encryptString(ds,ls,Ii.encryptECB,rs)elseif hs==Yn then return
Ii.encryptString(ds,ls,Ii.encryptCBC,rs)elseif hs==Pn then return
Ii.encryptString(ds,ls,Ii.encryptOFB,rs)elseif hs==Vn then return
Ii.encryptString(ds,ls,Ii.encryptCFB,rs)elseif hs==Bn then return
Ii.encryptString(ds,ls,Ii.encryptCTR,rs)else error("Unknown mode",2)end end
local function us(cs,ms,fs,ws,ys)local ws=ws or Yn local fs=fs or Cn local
ps=Gn(cs,fs,ys)local vs if ws==Wn then
vs=Ii.decryptString(ps,ms,Ii.decryptECB,ys)elseif ws==Yn then
vs=Ii.decryptString(ps,ms,Ii.decryptCBC,ys)elseif ws==Pn then
vs=Ii.decryptString(ps,ms,Ii.decryptOFB,ys)elseif ws==Vn then
vs=Ii.decryptString(ps,ms,Ii.decryptCFB,ys)elseif ws==Bn then
vs=Ii.decryptString(ps,ms,Ii.decryptCTR,ys)else error("Unknown mode",2)end
local bs=G.unpadByteString(vs)if(bs==nil)then return nil end return bs end
return{AES128=16,AES192=24,AES256=32,ECBMODE=1,CBCMODE=2,OFBMODE=3,CFBMODE=4,CTRMODE=4,encrypt=as,decrypt=us,util=G,ciphermode=Ii,aes=Ta}