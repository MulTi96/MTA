function calculateRandomPositionToPlayer(posX, posY, posZ)
	
	rndX = math.random(1, 3);
	rndY = math.random(1, 3);
	
	posX = posX + rndX;
	posY = posY + rnxY;
	
	return{posX, posY, posZ};
end
