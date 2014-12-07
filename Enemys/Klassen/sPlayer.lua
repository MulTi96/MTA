Player 		   = {};
Player.__index = Player;

function Player:Construct(client)
	
	local self 					= {};
	setmetatable(self, {__index = Player});
	
	self.Client					= client;
	self.Clientname				= client:getName();
	self.ClientEnemys			= {};
	
end

function Player:Refresh()
	self:SpawnEnemy();
end

function Player:SetClientData(data, var)
	self[data] = var;
end
function Player:GetClientData(data)
	return self[data];
end
function Player:GetEnemy(enemy)
	for id = 1, #self.ClientEnemys do 
		if(self.ClientEnemys[id] == enemy)then
			return self.ClientEnemys[id];
		end
	end
end
function Player:GetEnemyID(enemy)
	for id = 1, #self.ClientEnemys do 
		if(self.ClientEnemys[id] == enemy)then
			return id;
		end
	end
end
function Player:SetEnemy(Enemy)
	self.ClientEnemys[#self.ClientEnemys + 1] = Enemy;
end
function Player:GetEnemys()
	return self.ClientEnemys;
end

function Player:DestructEnemy(enemy)
	for i = 1, #self.ClientEnemys do 
		if(self.ClientEnemys[i] == enemy)then
			self.ClientEnemys[i] = nil;
			table.remove(self.ClientEnemys, i);
			outputDebugString("ID: "..i.." wurde aus der Player-Klasse entfernt");
		end
	end
end


function Player:SpawnEnemy()
	
	
	self.classInheritanceEnemy = EnemyServerManager:SpawnEnemy(self.Client, self);
	
	self.classInheritanceEnemy.Enemy:setHealth(100);
	self.classInheritanceEnemy.Enemy:setArmor(100):
	
	outputDebugString("Klasse hat einen neuen Enemy erstellt der Enemy wurde auf "..self.classInheritanceEnemy.Player:getName().." gesetzt!");

end
