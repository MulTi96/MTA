addEvent("isLineOfSightClearEnemyServer", true)

function isLineOfSightClearEnemy(classInheritance, enemy, ...) -- Zum Clienten senden da es eine Clientseitige Funktion ist.
	
	triggerClientEvent(getRootElement(), "isLineOfSightClearEnemyClient", enemy, ...)
	
	addEventHandler("isLineOfSightClearEnemyServer", root, function(arg)
		classInheritance.isLineClear = arg;
	end)
end

function setEnemyAimWeapon(enemy, stn)
	triggerClientEvent(getRootElement(), "setClientEnemyAimWeapon", enemy, stn);
end
