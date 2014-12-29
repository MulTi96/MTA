SpawnpointsFire = {

	[1] = { x = -1993.73865, y = 85.62280, z = 27.68750, size = 10 },
	[2] = { x = -1993.73865, y = 85.62280, z = 27.68750, size = 10 },
	
}

addEvent("onServerStartFire", true)
addEventHandler("onServerStartFire", root, function()
	
	local rnd = math.random(1, #SpawnpointsFire);
	
	if(SpawnpointsFire[rnd])then
		local data = SpawnpointsFire[rnd];
		createFire(data.x, data.y, data.z, data.size);
		
		triggerServerEvent("outputFire", root, data.x, data.y, data.z);
	end
end)
