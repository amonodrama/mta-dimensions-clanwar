local clans = {}
local cwstates = {}

--[[Everything is based on dimensions.
First number indicates dimension second one indicates team
Ex: clans['0_1'].name would get the name of team1 in dimension 0.
]]

clans['0_1'] = {['dimension'] = 1, ['name'] = "Test1", ['points'] = 0, ['color'] = "#000000"}
clans['0_2'] = {['dimension'] = 1, ['name'] = "Test2", ['points'] = 0, ['color'] = "#000000"}
clans['1_1'] = {['dimension'] = 2, ['name'] = "Test3", ['points'] = 0, ['color'] = "#000000"}
clans['1_2'] = {['dimension'] = 2, ['name'] = "Test4", ['points'] = 0, ['color'] = "#000000"}

--Same as clans table, the index indicates which dimension it is on.
--cwstates['0'].state would get you the state of clanwar in dimension(room) 0.
cwstates['0'] = {['state'] = "Free", ['stop'] = "no"}
cwstates['1'] = {['state'] = "Free", ['stop'] = "no"}

function receiveSettings(tableindex, setting, value)
	if setting == "name" then
	clans[tableindex].name = value
	elseif setting == "points" then
	clans[tableindex].points = value
	elseif setting == "color" then 
	clans[tableindex].color = value
	elseif setting == "state" then
	cwstates[tableindex].state = value
	elseif setting == "stop" then
	cwstates[tableindex].stop = value
	end
end
addEvent( "clanwar:receiveSettings", true )
addEventHandler("clanwar:receiveSettings", root, receiveSettings)

local sw, sh = guiGetScreenSize()

--This is very temporary.
function clanwarHud()
local len1 = dxGetTextWidth("Test: 10", 1, "default-bold")
local mydimension = tostring(getElementDimension(localPlayer))
local t1name = clans[mydimension.."_1"].name
local t2name = clans[mydimension.."_2"].name
local t1points = clans[mydimension.."_1"].points
local t2points = clans[mydimension.."_2"].points
dxDrawText(cwstates[mydimension].state, sw-15, (sh/2.2)-3, sw-40-len1, 20, tocolor(255, 255, 255,255), 1, "default-bold", "center")
dxDrawRectangle(sw-40-len1, (sh/2.1)-6, len1+25, 55, tocolor(0, 0, 0, 120))
dxDrawText(t1name.." "..t1points.."\n"
		..t2name.." "..t2points,sw-40-len1+5, sh/2.1, sw-25, sh,_, 1, "default-bold", "right", "top", false, false, false, true)
end
addEventHandler("onClientRender", root, clanwarHud)


