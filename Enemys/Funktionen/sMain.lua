
function calculateRandomPositionToPlayer(posX, posY, posZ) -- Sehr simpel berechnet uns eine kleine Random Spawnposition zu der Position
	
	rndX = math.random(1, 3);
	rndY = math.random(1, 3);
	
	posX = posX + rndX;
	posY = posY + rndY;
	
	return{posX, posY, posZ};
end

function findRotation(x1,y1,x2,y2)
 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
 
end

function setEnemyAimTarget(enemy, ...)
	triggerClientEvent(getRootElement(), "setEnemyAimTargetClient", enemy, ...);
end