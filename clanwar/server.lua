local clans = {}
local cwstates = {}
local spectators = nil
local cc = "#8667EB"
local prefix = cc.."[Clanwar]#ffffff "
function createDefaultTeams()

--[[Everything is based on dimensions.
First number indicates dimension second one indicates team
Ex: clans['0_1'].name would get the name of team1 in dimension 0.
Check setTeamPoints or setTeamname function for better examples.
]]

clans['0_1'] = {['dimension'] = 1, ['name'] = "Test1", ['points'] = 0, ['color'] = "#000000"}
clans['0_2'] = {['dimension'] = 1, ['name'] = "Test2", ['points'] = 0, ['color'] = "#000000"}
clans['1_1'] = {['dimension'] = 2, ['name'] = "Test3", ['points'] = 0, ['color'] = "#000000"}
clans['1_2'] = {['dimension'] = 2, ['name'] = "Test4", ['points'] = 0, ['color'] = "#000000"}
spectators = createTeam("Spectators")
setTeamColor(spectators, 255,255,255)  
  for i, v in pairs(clans) do
  local team = createTeam(v.name)
  local r,g,b = getColorFromString(v.color)
  setTeamColor(team, r,g,b)
    for i, v in pairs(getElementsByType("player")) do
    local mydimension = getElementDimension(v)
    checkPlayerTeam(v, mydimension)
    end
end

--Same as clans table, the index indicates which dimension it is on.
--cwstates['0'].state would get you the state of clanwar in dimension(room) 0.
cwstates['0'] = {['state'] = "Free", ['speckill'] = "no", ['specchat'] = "no", ['voteredo'] = "no", ['votestarter'] = "none", ['stop'] = "no", ['roundsleft'] = 20, ['rounds'] = 20}
cwstates['1'] = {['state'] = "Free", ['speckill'] = "no", ['specchat'] = "no", ['voteredo'] = "no", ['votestarter'] = "none", ['stop'] = "no", ['roundsleft'] = 20, ['rounds'] = 20}
end
addEventHandler("onResourceStart", resourceRoot, createDefaultTeams)

--This is temporary used for testing
function changeMyDimension(source, cmd, num)
setElementDimension(source, num)
outputChatBox("Dimension changed to "..num)
end
addCommandHandler("cd",changeMyDimension)

function setSpecChat(source, cmd)
local mydimension = tostring(getElementDimension(source))
local myname = getPlayerName(source)
  if cwstates[mydimension].specchat == "no" then
    cwstates[mydimension].specchat = "yes"
    outputChatBox(prefix.."Spectators chat was disabled by "..myname.."#ffffff.",root,255,255,255,true)
  elseif cwstates[mydimension].specchat == "yes" then
    cwstates[mydimension].specchat = "no"
    outputChatBox(prefix.."Spectators chat was enabled by "..myname.."#ffffff.",root,255,255,255,true)
  end
end
addCommandHandler("specchat",setSpecChat) 

function setSpecKill(source, cmd)
local mydimension = tostring(getElementDimension(source))
local myname = getPlayerName(source)
  if cwstates[mydimension].speckill == "no" then
    cwstates[mydimension].speckill = "yes"
    outputChatBox(prefix.."Auto spectators kill was enabled by "..myname.."#ffffff.",root,255,255,255,true)
  elseif cwstates[mydimension].speckill == "yes" then
    cwstates[mydimension].speckill = "no"
    outputChatBox(prefix.."Auto spectators kill was disabled by "..myname.."#ffffff.",root,255,255,255,true)
  end
end
addCommandHandler("speckill",setSpecKill) 

function setTeamname(source, cmd, num, cname)
local mydimension = tostring(getElementDimension(source))
local myname = getPlayerName(source)
local tableindex = mydimension.."_"..num
local team = getTeamFromName(clans[tableindex].name)
setTeamName(team, cname)
outputChatBox(prefix..clans[tableindex].color..clans[tableindex].name.."#ffffff name was changed to "..clans[tableindex].color..cname.." #ffffffby "..myname.."#ffffff.",root,255,255,255,true)
clans[tableindex].name = cname
sendSettings(tableindex, "name", cname)
  for i, player in pairs(getElementsByType("player")) do
  checkPlayerTeam(player, mydimension)
  end
end
addCommandHandler("stn",setTeamname)

function setTeamPoints(source, cmd, num, cpoints)
local myname = getPlayerName(source)
local mydimension = tostring(getElementDimension(source))
local tableindex = mydimension.."_"..num
clans[tableindex].points = cpoints
sendSettings(tableindex, "points", cpoints)
outputChatBox(prefix..clans[tableindex].color..clans[tableindex].name.."#ffffff points was changed to "..cc..cpoints.." #ffffffby "..myname.."#ffffff.",root,255,255,255,true)
local rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points
cwstates[mydimension].roundsleft = cwstates[mydimension].rounds - rounds
  if cwstates[mydimension].roundsleft <= 0 then
  cwstates[mydimension].roundsleft = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points + 4
  cwstates[mydimension].rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points + 4
  end
end
addCommandHandler("sp",setTeamPoints)

function resetTeamPoints(source, cmd)
local myname = getPlayerName(source)
local mydimension = tostring(getElementDimension(source))
clans[mydimension.."_"..1].points = 0 
clans[mydimension.."_"..2].points = 0
sendSettings(mydimension.."_"..1, "points", clans[mydimension.."_"..1].points)
sendSettings(mydimension.."_"..2, "points", clans[mydimension.."_"..2].points) 
outputChatBox(prefix.." Clan points were reset by "..myname.."#ffffff.",root,255,255,255,true)
cwstates[mydimension].roundsleft = 20
cwstates[mydimension].rounds = 20
end
addCommandHandler("rp",resetTeamPoints)

function sendSettings(tableindex, setting, value)
triggerClientEvent ("clanwar:receiveSettings", root, tableindex, setting, value)
end

function setTeamcolor(source, cmd, num, ccolor)
local myname = getPlayerName(source)
local mydimension = getElementDimension(source)
local tableindex = mydimension.."_"..num
local team = getTeamFromName(clans[tableindex].name)
local newcolor = "#"..ccolor
local r, g, b = getColorFromString(newcolor)
setTeamColor(team, r,g,b)
clans[tableindex].color = newcolor
sendSettings(tableindex, "color", newcolor)
outputChatBox(prefix..clans[tableindex].color..clans[tableindex].name.."#ffffff color was changed to "..newcolor..ccolor.." #ffffffby "..myname.."#ffffff.",root,255,255,255,true)
end
addCommandHandler("stc",setTeamcolor)


local autoDeclineTimer
function autoDeclineVote(mydimension)
  cwstates[mydimension].voteredo = "no"
  cwstates[mydimension].votestarter = "none"
  outputChatBox(prefix.."Voteredo was declined automaticly.", root, 255, 255, 255, true)
end

function changeState(message, messageType)
	if messageType == 0 then
    local mydimension = tostring(getElementDimension(source))
    if cwstates[mydimension].specchat == "yes" then
      if getPlayerTeam(source) == spectators then
        cancelEvent()
      end
    end
    if message == "s" or message == "stop" then
      if cwstates[mydimension].state == "Free" then return end
      if getPlayerTeam(source) == spectators then return end
        if cwstates[mydimension].stop == "yes" then
          outputChatBox(prefix.."Clanwar is already stopped.",source,255,255,255,true)
        else
          sendSettings(mydimension, "stop", "yes") -- This has to be outside the timer so we can display a 'countdown' for 3 seconds before the cw stops.
          setTimer ( function()
          setGameSpeed(0)
          outputChatBox(prefix.."Clanwar has been stopped", root,255, 255, 255, true)
          cwstates[mydimension].stop = "yes"
          end, 3000, 1 )
        end
    elseif message == "g" or message == "go" then
      if cwstates[mydimension].state == "Free" then return end 
      if getPlayerTeam(source) == spectators then return end
        if cwstates[mydimension].stop == "no" then
        else
          setTimer ( function()
          setGameSpeed(1)
          outputChatBox(prefix.."Clanwar has been started.", root,255, 255, 255, true)
          sendSettings(mydimension, "stop", "no") -- This has to be inside the timer because the clanwar actually starts after timer ends.
          end, 3000, 1 )
        end             
    elseif message == "r" or message == "redo" then
      if cwstates[mydimension].state == "Free" then return end
      if getPlayerTeam(source) == spectators then return end
        if cwstates[mydimension].voteredo == "yes" then 
        else
          autoDeclineTimer = setTimer(autoDeclineVote, 5000, 1, mydimension)
          cwstates[mydimension].voteredo = "yes"
          cwstates[mydimension].votestarter = getPlayerTeam(source)
          local tr, tb, tc = getTeamColor(getPlayerTeam(source))
          local teamcolor = RGBToHex(tr,tb,tc)
          outputChatBox(prefix..teamcolor..getTeamName(getPlayerTeam(source)).."#ffffff is asking for a redo. Answer in 5 seconds.",root,255,255,255,true)
        end
        if cwstates[mydimension].votestarter == getPlayerTeam(source) then
        else
          if cwstates[mydimension].voteredo == "yes" then
            if isTimer(autoDeclineTimer) then killTimer(autoDeclineTimer) end
            local tr, tb, tc = getTeamColor(getPlayerTeam(source))
            local teamcolor = RGBToHex(tr,tb,tc)
            cwstates[mydimension].voteredo = "no"
            cwstates[mydimension].votestarter = "none"
            outputChatBox(prefix..teamcolor..getTeamName(getPlayerTeam(source)).."#ffffff answered, map is restarting.")
            --THIS IS WHERE redoMap event would go when we create a mapmanager for multirooms.
          end
        end    
		elseif message == "f" or message == "free" then
			if cwstates[mydimension].state == "Free" then return end
			cwstates[mydimension].state = "Free"
      outputChatBox(prefix.."Clanwar state was changed to #ff0000free#ffffff.",root,255,255,255,true)
			sendSettings(mydimension, "state", "Free")
		elseif message == "l" or message == "live" then
			if cwstates[mydimension].state == "Live" then return end
			cwstates[mydimension].state = "Live"
      outputChatBox(prefix.."Clanwar state was changed to #00FF46live#ffffff.",root,255,255,255,true)
			sendSettings(mydimension, "state", "Live")
		end
	end
end
addEventHandler("onPlayerChat", root, changeState)


--Count Points
addEventHandler("onPlayerWasted", root,
  function(player)
 	local mydimension = tostring(getElementDimension(source))
  local myname = getPlayerName(source)
  if cwstates[mydimension].state == "Live" then
    if getPlayerTeam(source) == spectators or myname:find("%(%S%)") then return end
  triggerEvent("killsystem:showKill", root, source)
  end
 	local t1name = clans[mydimension.."_"..1].name
  local t1color = clans[mydimension.."_"..1].color
 	local t2name = clans[mydimension.."_"..2].name
  local t2color = clans[mydimension.."_"..2].color
  local t1dead = 0
  local t2dead = 1
      if t1dead > 0 and t2dead == 0 then
        if getPlayerTeam(source) == getTeamFromName(t2name) then
          if t2dead == 0 then
              if cwstates[mydimension].roundsleft == 1 and tonumber(clans[mydimension.."_"..1].points) > tonumber(clans[mydimension.."_"..2].points) then
              local rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points
              cwstates[mydimension].roundsleft = cwstates[mydimension].rounds - rounds
              clans[mydimension.."_"..1].points = clans[mydimension.."_"..1].points + 1
              sendSettings(mydimension.."_"..1, "points", clans[mydimension.."_"..1].points)  
              outputChatBox(prefix..t1color..t1name.." #ffffffwon the clanwar.", root, 255,255,255,true)
              triggerEvent("killsystem:clanwarEnded", root, mydimension)
              cwstates[mydimension].state = "Free"
              sendSettings(mydimension, "state", "Free")
              elseif cwstates[mydimension].roundsleft == 1 and tonumber(clans[mydimension.."_"..2].points) > tonumber(clans[mydimension.."_"..1].points) then
              local rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points
              cwstates[mydimension].roundsleft = cwstates[mydimension].rounds - rounds
              clans[mydimension.."_"..1].points = clans[mydimension.."_"..1].points + 1
              sendSettings(mydimension.."_"..1, "points", clans[mydimension.."_"..1].points)  
              outputChatBox(prefix..t2color..t2name.." #ffffffwon the clanwar.", root, 255,255,255,true)
              triggerEvent("killsystem:clanwarEnded", root, mydimension)
              cwstates[mydimension].state = "Free"
              sendSettings(mydimension, "state", "Free")
              elseif cwstates[mydimension].roundsleft == 1 and clans[mydimension.."_"..1].points == clans[mydimension.."_"..2].points - 1 then
              clans[mydimension.."_"..1].points = clans[mydimension.."_"..1].points + 1
              sendSettings(mydimension.."_"..1, "points", clans[mydimension.."_"..1].points)  
              outputChatBox(prefix.." It is a draw!",root,255,255,255,true)
              outputChatBox(prefix.." You may contuniue this clanwar by turning state to live!",root,255,255,255,true)
              cwstates[mydimension].rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points + 4
              cwstates[mydimension].roundsleft = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points + 4
              elseif cwstates[mydimension].roundsleft > 1 then
            outputChatBox(prefix..t1color..t1name.." #ffffffwon the round.", root, 255, 255, 255, true)
            if cwstates[mydimension].state == "Live" then
               clans[mydimension.."_"..1].points = clans[mydimension.."_"..1].points + 1
               local rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points
               cwstates[mydimension].roundsleft = cwstates[mydimension].rounds - rounds
               sendSettings(mydimension.."_"..1, "points", clans[mydimension.."_"..1].points)  
             end
            end
          end
        end
      elseif t1dead == 0 and t2dead > 0 then
        if getPlayerTeam(source) == getTeamFromName(t1name) then
          if t1dead == 0 then
              if cwstates[mydimension].roundsleft == 1 and tonumber(clans[mydimension.."_"..2].points) > tonumber(clans[mydimension.."_"..1].points) then
              local rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points
              cwstates[mydimension].roundsleft = cwstates[mydimension].rounds - rounds
              clans[mydimension.."_"..2].points = clans[mydimension.."_"..2].points + 1
              sendSettings(mydimension.."_"..2, "points", clans[mydimension.."_"..2].points)  
              outputChatBox(prefix..t2color..t2name.." #ffffffwon the clanwar.", root, 255,255,255,true)
              triggerEvent("killsystem:clanwarEnded", root, mydimension)
              cwstates[mydimension].state = "Free"
              sendSettings(mydimension, "state", "Free")
            elseif cwstates[mydimension].roundsleft == 1 and tonumber(clans[mydimension.."_"..1].points) > tonumber(clans[mydimension.."_"..2].points) then
              local rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points
              cwstates[mydimension].roundsleft = cwstates[mydimension].rounds - rounds
              clans[mydimension.."_"..2].points = clans[mydimension.."_"..2].points + 1
              sendSettings(mydimension.."_"..2, "points", clans[mydimension.."_"..2].points)  
              outputChatBox(prefix..t1color..t1name.." #ffffffwon the clanwar.", root, 255,255,255,true)
              triggerEvent("killsystem:clanwarEnded", root, mydimension)
              cwstates[mydimension].state = "Free"
              sendSettings(mydimension, "state", "Free")
              elseif cwstates[mydimension].roundsleft == 1 and clans[mydimension.."_"..2].points == clans[mydimension.."_"..1].points - 1 then
              clans[mydimension.."_"..2].points = clans[mydimension.."_"..2].points + 1
              sendSettings(mydimension.."_"..2, "points", clans[mydimension.."_"..2].points)  
              outputChatBox(prefix.." It is a draw!",root,255,255,255,true)
              outputChatBox(prefix.." You may contuniue this clanwar by turning state to live!",root,255,255,255,true)
              cwstates[mydimension].rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points + 4
              cwstates[mydimension].roundsleft = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points + 4
              elseif cwstates[mydimension].roundsleft > 1 then
            outputChatBox(prefix..t2color..t2name.." #ffffffwon the round.", root, 255, 255, 255, true)
            if cwstates[mydimension].state == "Live" then
               clans[mydimension.."_"..2].points = clans[mydimension.."_"..2].points + 1
               local rounds = clans[mydimension.."_"..1].points + clans[mydimension.."_"..2].points
               cwstates[mydimension].roundsleft = cwstates[mydimension].rounds - rounds
               sendSettings(mydimension.."_"..2, "points", clans[mydimension.."_"..2].points)  
             end
            end
          end
        end
      end
  end
)

function getTeamAlivePlayersCount(team)
  if team then
    local tbl = getPlayersInTeam(team)
    local alivePlayers = 0
    for k, v in ipairs(tbl) do
      if getElementData(v, "State") == "alive" then
        alivePlayers = alivePlayers + 1
      end
    end
    return alivePlayers or false
  end
end


function checkPlayerTeam(player, dimension)
local nick = getPlayerName(player)
local t1name = clans[dimension.."_"..1].name
local t2name = clans[dimension.."_"..2].name
local t1 = getTeamFromName(clans[dimension.."_"..1].name)
local t2 = getTeamFromName(clans[dimension.."_"..2].name)
  if nick:find(t1name, 1, true) then
  setPlayerTeam(player, t1)
  elseif nick:find(t2name, 1, true) then
  setPlayerTeam(player, t2)
  else
  setPlayerTeam(player, spectators)
  end
end   


function vehiclecolor(player)
    if (getPlayerTeam (player)) then
        local r,g,b = getTeamColor(getPlayerTeam(player))
        setVehicleColor ( source, r, g, b, 0, 0, 0 )
    end
end
addEventHandler ("onVehicleEnter",root, vehiclecolor)

function killSpectators(player)
local mydimension = tostring(getElementDimension(player))
local vehicle = getPedOccupiedVehicle(player)
  if cwstates[mydimension].state == "Live" and cwstates[mydimension].speckill == "yes" then
    if getPlayerTeam(player) == spectators or getPlayerName(player):find("%(%S%)") then
    toggleAllControls(player, false, true, false)
    setVehicleOverrideLights(vehicle,1)
    setElementAlpha(vehicle,0)
    setElementCollisionsEnabled(vehicle, false)
    setElementAlpha(player, 0)
      setTimer ( function()
      if isElement(player) then
      triggerEvent("onClientRequestSpectate", player, false)
      triggerEvent("onRequestKillPlayer", player)
      if isElement(vehicle) then
      setElementPosition(vehicle, 0,0,-22, false)
      end
      end
      end, 50, 1 )
      setTimer ( function()
      blowVehicle(vehicle)
      end, 500, 1 )  
    end
  end
end

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, 
function(mapState)
  if mapState == "Running" then
    for i,v in pairs(getElementsByType("player")) do
    killSpectators(v)
    end
  end
end)

