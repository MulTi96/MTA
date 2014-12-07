
EnemyServerManager 		   = {};
EnemyServerManager.__index = EnemyServerManager;

EnemySkinsTable 		   = {		-- Die Skins die, die Peds bekommen können.
							103,
							106,
							109,
							113,
							116,
							117,
							127
}

EnemyWeaponsTable 		  = { 		-- Die Waffen die, die Peds bekommen können.
				           24,
						   27,
						   30,
						   31
					
}

function EnemyServerManager:RandomEnemySkin()
	
	self.TempSkin		 = {}
	for i, skin in pairs(EnemySkinsTable) do 
		self.TempSkin[i] = skin;
	end	
	self.EnemySkin       = self.TempSkin[math.random(1, #self.TempSkin)];
end

function EnemyServerManager:RandomEnemyWeapon()
	
	self.TempWeapon        = {};
	
	for i, weapon in pairs(EnemyWeaponsTable) do 
		self.TempWeapon[i] = weapon;
	end
	self.EnemyWeapon       = self.TempWeapon[math.random(1, #self.TempWeapon)];
end

function EnemyServerManager:EnemyWasted(ammo, killer, weapon, stealth)
	if(self.Enemy == source)then
		if(self.Player == killer)then
			outputDebugString("Der Spieler: "..(self.Player:getName()).." hat von seiner Klasse einen Enemy ausgeschaltet");
			self:Destructer();
		end
	end
end

function EnemyServerManager:Destructer()
	self.classInheritancePlayer:DestructEnemy(self.Enemy);
	removeEventHandler("onPedWasted", self.Enemy, function(...) self:EnemyWasted(...) end);
	destroyElement(self.Enemy);
	self = nil;
end

function EnemyServerManager:SetEnemyPlayer(client)
	self.Player = client;
end

function EnemyServerManager:SpawnEnemy(client, classInheritance)
	
	local self				    = {};
	setmetatable(self, {__index = EnemyServerManager});
	
	clientPos					= {getElementPosition(client)};
	spawnPos                    = calculateRandomPositionToPlayer(clientPos[1], clientPos[2], clientPos[3]);
	
	self:RandomEnemySkin();
	self:RandomEnemyWeapon();
	
	self.Enemy					= createPed(self.EnemySkin, spawnPos[1], spawnPos[2], spawnPos[3]);
	giveWeapon(self.Enemy, self.EnemyWeapon);
	
	addEventHandler("onPedWasted", self.Enemy, function(...) self:EnemyWasted(...) end);
	
	self:SetEnemyPlayer(client);
	classInheritance:SetEnemy(self.Enemy);
	self.classInheritancePlayer = classInheritance;
	
	
	return self;
end
