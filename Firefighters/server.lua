
Firefighters      = {};
FirefighersPickup = createPickup(-2026.608, 67.1984, 28.69, 3, 1239, 0);

FirefighterSkins  = {
	
	[1] = 277, 
	[2] = 278,
	[3] = 279
	
}


FirefighterVehicle  = {}

FirefighterVehicles = {

	[1] = { x = -2022.3271484375, y = 75.1982421875, z = 28.348129272461, rotx = 358.07739257813, roty = 356.58874511719, rotz = 273.35632324219},
	[2] = { x = -2021.9541015625, y = 84.3095703125, z = 28.267513275146, rotx = 356.59423828125, roty = 0.28564453125, rotz = 272.26318359375},
	[3] = { x = -2022.1572265625, y = 91.8837890625, z = 28.30421257019, rotx = 356.11633300781, roty = 0.6536865234375, rotz = 269.18151855469},
}

--[[
local var	  = 1
addCommandHandler("fpos", function(player)

	if isPedInVehicle(player) then
		local vehicle    = getPedOccupiedVehicle(player);
		local x, y, z = getElementPosition(vehicle);
		local rx, ry, rz = getElementRotation(vehicle);
		
		outputChatBox("["..var.."] = { x = "..x..", y = "..y..", z = "..z..", rotx = "..rx..", roty = "..ry..", rotz = "..rz.."},");
	end
end)
]]--

addEvent("outputFire", true);
addEventHandler("outputFire", root, function(x, y, z)
	local city, zone = getZoneName(x, y, z, true), getZoneName(x, y, z, false);
	outputFirefighters("Feuer wurde in "..city.." "..zone.." Gesichtet!");
end)

for i = 1, #FirefighterVehicles do 
	local data = FirefighterVehicles[i];
	FirefighterVehicle[i] = createVehicle(407, data.x, data.y, data.z, data.rotx, data.roty, data.rotz);
	toggleVehicleRespawn(FirefighterVehicle[i], true);
	setVehicleRespawnDelay(FirefighterVehicle[i], 20000);
	
	
	addEventHandler("onVehicleStartEnter", FirefighterVehicle[i], function(player, seat)
		if(seat == 0 and not isFirefighter(player))then
			cancelEvent();
			outputChatBox("Du bist kein Feuerwehrmann!", player, 255, 0, 0);
		end
	end)
end

function outputFirefighters(text)
	for key, fighters in pairs(Firefighters) do 
		outputChatBox(text, key, 255, 0, 0);
	end
end

addEventHandler("onPickupHit", FirefighersPickup, function(player)
	if(isFirefighter(player))then
		outputChatBox("Gebe /oduty ein um den Dienst zu Verlassen!", player, 255, 0, 0);
	else
		outputChatBox("Gebe /fduty ein um den Dienst zu Betretten!", player, 255, 0, 0);
	end
end) 

addCommandHandler("fduty", function(player)
	
	local x, y, z    = getElementPosition(player);
	local px, py, pz = getElementPosition(FirefighersPickup);
	local distance   = getDistanceBetweenPoints3D(x, y, z, px, py, pz);
	
	if(distance < 3)then
		if(isFirefighter(player))then
			outputChatBox("Du bist schon im Dienst!", player, 255, 0, 0);
		else
			Firefighters[player]		 = {};
			Firefighters[player]["Skin"] = player:getModel();
			
			local rnd  = math.random(1, #FirefighterSkins);
			local skin = FirefighterSkins[rnd];
			
			player:setModel(skin);
			
			outputChatBox("Du hast den Dienst angetretten!", player, 0, 125, 0);
			
		end
	else
		outputChatBox("Du musst am Pickup dafür stehen!", player, 255, 0, 0);
	end
end)

addCommandHandler("oduty", function(player)
	if(isFirefighter(player))then
		local x, y, z    = getElementPosition(player);
		local px, py, pz = getElementPosition(FirefighersPickup);
		local distance   = getDistanceBetweenPoints3D(x, y, z, px, py, pz);
		
		if(distance < 3)then
				
			player:setModel(Firefighters[player]["Skin"]);
			Firefighters[player] = nil;
			outputChatBox("Du hast den Dienst Verlassen!", player, 255, 0, 0);
			
		else
			outputChatBox("Du musst am Pickup dafür stehen!", player, 255, 0, 0);
		end
	else
		outputChatBox("Du bist garnicht im Dienst!", player, 255, 0, 0);
	end
end)

function isFirefighter(player)
	if(Firefighters[player])then
		return true;
	end
	return false;
end