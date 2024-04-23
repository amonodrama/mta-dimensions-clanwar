local playerStats = {}

function showKill(player)
local playerName = getPlayerName(player)
local playerSerial = getPlayerSerial(player)
local playerDimension = getElementDimension(player)
local msg = playerName.." #ffffffdied."
local killer = getElementData(player, "myKiller")
local assister = getElementData(source, "myAssister")
  if killer and isElement(killer) and killer ~= nil then
    local killerName = getPlayerName(killer)
    local killerSerial = getPlayerSerial(killer)
    msg = playerName.." #ffffffdied ("..killerName.."#ffffff)."
    if playerStats[killerSerial] then
    playerStats[killerSerial].kills = playerStats[killerSerial].kills + 1
    else
    playerStats[killerSerial] = {['dimension'] = playerDimension, ['name'] = killerName, ['kills'] = 1, ['deaths'] = 0, ['assists'] = 0}  
    end   
    local assister2 = getElementData(killer, "myKiller")
      if assister2 and assister2 ~= source then
        local assister2Name = getPlayerName(assister2)
        local assister2Serial = getPlayerSerial(assister2)
        if playerStats[assister2Serial] then
        playerStats[assister2Serial].assists = playerStats[assister2Serial].assists + 1 
        else
        playerStats[assister2Serial] = {['dimension'] = playerDimension, ['name'] = assister2Name, ['kills'] = 0, ['deaths'] = 0, ['assists'] = 1}
        end
      end
  end
  if assister and isElement(assister) and assister ~= nil then
    local killerName = getPlayerName(killer)
    local killerSerial = getPlayerSerial(killer)
    local assisterName = getPlayerName(assister)
    local assisterSerial = getPlayerSerial(assister)
    msg = playerName.." #ffffffdied ("..killerName.."#ffffff+"..assisterName.."#ffffff)."
    if playerStats[killerSerial] and playerStats[assisterSerial] then
    playerStats[killerSerial].kills = playerStats[killerSerial].kills + 1
    playerStats[assisterSerial].assists = playerStats[assisterSerial].assists + 1
    else
    playerStats[killerSerial] = {['dimension'] = playerDimension, ['name'] = killerName, ['kills'] = 1, ['deaths'] = 0, ['assists'] = 0}
    playerStats[assisterSerial] = {['dimension'] = playerDimension,  ['name'] = assisterName, ['kills'] = 0, ['deaths'] = 0, ['assists'] = 1}
    end
  end
    if playerStats[playerSerial] then
    playerStats[playerSerial].deaths = playerStats[playerSerial].deaths + 1
    else
    playerStats[playerSerial] = {['dimension'] = playerDimension,  ['name'] = playerName, ['kills'] = 0, ['deaths'] = 1, ['assists'] = 0}
    end
    outputChatBox(msg,root,255,255,255,true)
end    
addEvent( "killsystem:showKill", true )
addEventHandler( "killsystem:showKill", resourceRoot, showKill)

function sortTable()
sortedTable = {}
  for i, v in pairs(playerStats) do
  local dimension = v.dimension
  local name = v.name
  local kills = v.kills
  local deaths = v.deaths
  local assists = v.assists
  local ratio = kills+(assists/2) - (deaths/2)
  table.insert(sortedTable,{['dimension'] = dimension, ['name'] = name ,['kills'] = kills, ['deaths'] = deaths, ['assists'] = assists, ['ratio'] = ratio })
  end
table.sort(sortedTable, function(a, b) return b.ratio > a.ratio end)
return sortedTable
end

function clanwarEnded(dimension)
  for i, v in ipairs(sortTable()) do
    if tostring(v.dimension) == tostring(dimension) then
    outputChatBox("("..i..") "..v.name.." #ffffffKills:"..v.kills.." Deaths:"..v.deaths.." Assists:"..v.assists, root,255,255,255,true)
    end
  end
end
addEvent( "killsystem:clanwarEnded", true )
addEventHandler( "killsystem:clanwarEnded", resourceRoot, clanwarEnded)

function clearKill()
setElementData(source, "myKiller", nil)
setElementData(source, "myAssister", nil)
end
addEventHandler ( "onPlayerVehicleEnter", root, clearKill) --This should be changed to onMapStarting or onRoundStarting something similiar.
--It can also be added right at the end of showkill function.        

