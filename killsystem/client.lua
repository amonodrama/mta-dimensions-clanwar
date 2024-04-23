addEventHandler("onClientVehicleCollision", root,
function(hitElement)
	if hitElement then
		theCar = getPedOccupiedVehicle(getLocalPlayer())
		if theCar then
			if getElementType(hitElement) == "vehicle" and source == theCar then
				local hitPlayer = getVehicleOccupant(hitElement)
				if hitPlayer then
					local myKiller = getElementData(getLocalPlayer(), "myKiller")
					if isTimer(clearKillerTimer) then killTimer(clearKillerTimer) end
					if myKiller == nil or myKiller == hitPlayer then
						setElementData(getLocalPlayer(), "myKiller", hitPlayer)
						clearKillerTimer = setTimer(clearKill, 5000, 1)
					elseif myKiller ~= hitPlayer then
						setElementData(getLocalPlayer(), "myKiller", hitPlayer)
						setElementData(getLocalPlayer(), "myAssister", myKiller)
						clearKillerTimer = setTimer(clearKill, 5000, 1)
					end
				end
			end
		end
	end
end)

function clearKill()
	local theCar = getPedOccupiedVehicle(getLocalPlayer())
	if not theCar then return end
	if isVehicleOnGround(theCar) == true and isElementInWater(theCar) == false and getElementHealth(theCar)>250 then
		setElementData(getLocalPlayer(), "myKiller", nil)
		setElementData(getLocalPlayer(), "myAssister", nil)
	else
		setTimer(clearKill, 300, 1)
	end
end