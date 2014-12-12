Player 		   			= {};
Player.__index 			= Player;


function Player:Construct(client)

	local self 					= {}
	setmetatable(self, {__index = Player});
	
	self.Client 				 = client;
	self.Clientname				 = client:getName();
	self.ClientEnemys			 = {};
	
	self.MaxEnemysSpawnForPlayer = 5; -- Wie viele Maximal Spawnen dürfen.
	
	self.ClientRefresh  		= function(...) self:Refresh(...) end;
	self.ClientRefreshTimer     = setTimer(self.ClientRefresh, 1000, -1);
	
	addEventHandler("onPlayerQuit", root, function(...) self:Quit(...) end);
end

function Player:Quit(source)
	if(source == self.Client)then
		self:Destructer();
	end
end

function Player:Destructer()

	if isTimer(self.ClientRefreshTimer) then
		killTimer(self.ClientRefreshTimer)
	end 
	Enemys = self:GetEnemys();
	
	for i = 1, #Enemys do 
		self:DestructEnemy(Enemys[i]);
	end
	self = nil;
	outputDebugString("Alle Klassen wurden Destructet!");
end

addCommandHandler("se", function(p)
	Player:Construct(p);
end)

function Player:Refresh()								-- Erstellt im Zeit-Rythmus feindliche Enemys.
	self:SpawnEnemy(self);
end
function Player:SetClientData(data, var)				-- Klassen self verzeichniss Setztung von außen.
	self[data] = var
end
function Player:GetClientData(data)						-- Klassen self verzeichniss abfrage von außen.
	return self[data];
end
function Player:GetEnemyID(enemy)						-- Gibt von dem Enemy die ID wieder.
	for id = 1, #self.ClientEnemys do 	
		if(self.ClientEnemys[id] == enemy)then
			return id;
		end
	end
end
function Player:GetEnemy(enemy) 						-- Geben vom Spieler den Enemy zurück.
	for id = 1, #self.ClientEnemys do 
		if(self.ClientEnemys[id] == enemy)then
			return self.ClientEnemys[id];
		end
	end
end
function Player:SetEnemy(Enemy)							-- Setzten dem Spieler in einem self verzeichnis den Enemy.
	self.ClientEnemys[#self.ClientEnemys + 1] = Enemy; 
end	
function Player:GetEnemys()								-- Gibt alle Enemys vom Spieler zurück.
	return self.ClientEnemys;
end
function Player:DestructEnemy(enemy)					-- Entfernen den den Ped aus der Player-Klasse.
	for i = 1, #self.ClientEnemys do 
		if(self.ClientEnemys[i] == enemy)then
			self.ClientEnemys[i] = nil;
			table.remove(self.ClientEnemys, i);
			outputDebugString("ID: "..i.." wurde aus der Player-Klasse entfernt!"); -- Debugausgabe.
		end
	end
end

function Player:SpawnEnemy(classInheritance)												   -- Neuen Enemy erstellen mit der geerbeten Klasse.
	
	
	self.classInheritanceEnemy = EnemyServerManager:SpawnEnemy(self.Client, classInheritance); -- Unsere Geerbte Unterklasse von sManager womit wie auf die sManager Klasse zugreifen können.
	
	if(self.classInheritanceEnemy ~= "FULL")then
	
		self.classInheritanceEnemy.Enemy:setHealth(100);										   -- Setzten dem Enemy ein Leben von 100.
		self.classInheritanceEnemy.Enemy:setArmor(100);										       -- Setzten dem Enemy eine Armour von 100.	
			
		outputDebugString("Klasse hat einen neuen Enemy erstellt der Enemy wurde auf "..self.classInheritanceEnemy.Player:getName().." gesetzt!");
		
	else
		outputChatBox("Spawnlimit erreicht!");
	end
end

