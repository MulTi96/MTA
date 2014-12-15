SpawnpointsFire = {

	[1] = { x = -1993.73865, y = 85.62280, z = 27.68750, size = 10 },
	[2] = { x = -1993.73865, y = 85.62280, z = 27.68750, size = 10 },
	
}

setTimer(function()
	local rnd  = math.random(1, #SpawnpointsFire);
	
	if SpawnpointsFire[rnd] then
		local data = SpawnpointsFire[rnd];
		local fire = createFire(data.x, data.y, data.z, data.size);
		
		triggerServerEvent("outputFire", root, data.x, data.y, data.z);
	end
	
end, 1000, 0);