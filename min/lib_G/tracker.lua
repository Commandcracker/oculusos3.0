if _G.tracker then return false,"Tracker has already been loaded."end if not
turtle then return false,"Tracker can only be loaded on a turtle."end
_G.tracker={x=0,y=0,z=0,facing="north"}local e="/etc/tracker.txt"local function
t()local a=fs.open(e,"r")if a then local
o,i,n,s=a.readLine():match("(%d+);(%d+);(%d+);(%a+)")a.close()tracker.x,tracker.y,tracker.z,tracker.facing=tonumber(o),tonumber(i),tonumber(n),s
end end t()local function h()local
r=fs.open(e,"w")r.write(tostring(tracker.x)..";"..tostring(tracker.y)..";"..tostring(tracker.z)..";"..tracker.facing)r.close()end
local d={}d.up=turtle.up d.down=turtle.down d.forward=turtle.forward
d.back=turtle.back d.turnLeft=turtle.turnLeft d.turnRight=turtle.turnRight
function turtle.up()successfull,reason=d.up()if successfull then
tracker.y=tracker.y+1 h()return successfull end return successfull,reason end
function turtle.down()successfull,reason=d.down()if successfull then
tracker.y=tracker.y-1 h()return successfull end return successfull,reason end
function turtle.forward()successfull,reason=d.forward()if successfull then if
tracker.facing=="north"then tracker.z=tracker.z-1 elseif
tracker.facing=="east"then tracker.x=tracker.x+1 elseif
tracker.facing=="south"then tracker.z=tracker.z+1 elseif
tracker.facing=="west"then tracker.x=tracker.x-1 end h()return successfull end
return successfull,reason end function
turtle.back()successfull,reason=d.back()if successfull then if
tracker.facing=="north"then tracker.z=tracker.z+1 elseif
tracker.facing=="east"then tracker.x=tracker.x-1 elseif
tracker.facing=="south"then tracker.z=tracker.z-1 elseif
tracker.facing=="west"then tracker.x=tracker.x+1 end h()return successfull end
return successfull,reason end function
turtle.turnLeft()successfull,reason=d.turnLeft()if successfull then if
tracker.facing=="north"then tracker.facing="west"elseif
tracker.facing=="west"then tracker.facing="south"elseif
tracker.facing=="south"then tracker.facing="east"elseif
tracker.facing=="east"then tracker.facing="north"end h()return successfull end
return successfull,reason end function
turtle.turnRight()successfull,reason=d.turnRight()if successfull then if
tracker.facing=="north"then tracker.facing="east"elseif
tracker.facing=="east"then tracker.facing="south"elseif
tracker.facing=="south"then tracker.facing="west"elseif
tracker.facing=="west"then tracker.facing="north"end h()return successfull end
return successfull,reason end return
true