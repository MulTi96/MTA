addEvent("EnemyJump", true)
addEventHandler("EnemyJump", root, function()
	setPedControlState(source, "jump", not getPedControlState(source, "jump"));
end)
addEvent("setEnemyAimTargetClient", true)
addEventHandler("setEnemyAimTargetClient", root, function(...)
	setPedAimTarget(source, ...)
end)
addEvent("setClientEnemyAimWeapon", true)
addEventHandler("setClientEnemyAimWeapon", root, function(state)
	if not(getPedControlState(source, "aim_weapon") == state)then
		setPedControlState(source, "aim_weapon", state);
	end
end)

addEvent("setClientEnemyShoot", true);
addEventHandler("setClientEnemyShoot", root, function()
	if not getPedControlState(source, "fire")then
		setPedControlState(source, "fire", true);
	end
end)


function isLineOfSightClearEnemy(arg1, arg2, arg3)

	local matrix   = getElementMatrix(source);
	local int_RayX = matrix[2][1] + matrix[4][1]
    local int_RayY = matrix[2][2] + matrix[4][2]
    local int_RayZ = matrix[2][3] + matrix[4][3]
	
	bPathClear = isLineOfSightClear(arg1, arg2, arg3, int_RayX, int_RayY, int_RayZ - 0.5, true, true, false, true);
		
	triggerServerEvent("isLineOfSightClearEnemyServer", root, bPathClear);
end
addEvent("isLineOfSightClearEnemyClient", true)
addEventHandler("isLineOfSightClearEnemyClient", root, isLineOfSightClearEnemy);

 