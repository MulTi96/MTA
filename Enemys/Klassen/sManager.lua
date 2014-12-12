EnemyServerManager		   = {};
EnemyServerManager.__index = EnemyServerManager;


GlobalEnemysTable 		   = {};

EnemySkinsTable            = {							  -- Die Skins die, die Peds bekommen können.
							 103,
							 106,
							 109,
							 113,
							 116,
							 117,
							 127
}
EnemyWeaponsTable		   = {							  -- Die Waffen die, die Peds bekommen können.
							 24,
							 27,
							 30,
							 31
}


function EnemyServerManager:RandomEnemySkin()

	self.TempSkin 		   = {}							   -- Eine Temporäre Tabelle in der Klasse erstellen.
	for i, skin in pairs(EnemySkinsTable) do 			   -- Schleife die alle Skins durch geht.
		self.TempSkin[i]   = skin;						   -- In der Tabelle speichern.
	end
	self.EnemySkin		   = self.TempSkin[math.random(1, #self.TempSkin)]; -- Nun in einer self verzeichnis Abspeichern.
end

function EnemyServerManager:RandomEnemyWeapon()
	
	self.TempWeapon		   = {};						   -- Eine Temporäre Tabelle in der Klasse erstellen.
	for i, weapon in pairs(EnemyWeaponsTable) do 		   -- Schleife die alle Waffen durch geht.
		self.TempWeapon[i] = weapon;					   -- In der Tabelle speichern.
	end 
	self.EnemyWeapon	   = self.TempWeapon[math.random(1, #self.TempWeapon)];	-- Nun in einer self verzeichnis Abspeichern.
end

function EnemyServerManager:SetEnemyPlayer(client)	
	self.Player	= client;									-- Der Enemy Klasse den Player setzten.
end

function EnemyServerManager:EnemyWasted(ammo, killer, weapon, stealth)		-- Pedstirbt Event
	if(self.Enemy == source)then
		if(self.Player == killer)then
			outputDebugString("Der Spieler: "..(self.Player:getName()).." hat von seiner Klasse einen Enemy ausgeschaltet!");					-- Debugausgabe.
			self:Destructer();	-- Aus der Oberklasse Entfernen und der Playerklasse entfernen --
		else
			outputDebugString("Der Spieler: "..(killer:getName()).." hat einen Enemy von der Klasse von "..self.Player:getName().." Getötet!"); -- Debugausgabe.
		end
	end
end

function EnemyServerManager:Destructer()	-- Löscht den Ped aus der Manager & Player Klasse.
	self.classInheritancePlayer:DestructEnemy(self.Enemy);	-- Greifen auf die Player-Klasse per self verzeichnis zu.
	removeEventHandler("onPedWasted", self.Enemy, function(...) self.EnemyWasted(...) end);	-- Entfernen den eventHandler wen der Ped stirbt.
	destroyElement(self.Enemy);				-- Zerstören den Ped.
	killTimer(self.EnemyFightTimer);		-- Timer entfernung.
	killTimer(self.EnemyFixRotation);		-- Timer entfernung.
	self = nil;								-- Löschen der self instanz.
end

function EnemyServerManager:Rotation()
	
	if not isElement(self.Player) then
		self:Destructer();
	end	
	enemyPos		= {getElementPosition(self.Enemy)};
	playerPos	 	= {getElementPosition(self.Player)}
	
	rightRotation   = findRotation(enemyPos[1], enemyPos[2], playerPos[1], playerPos[2]) -- Funktionsaufruf das brauchen wir um die Rotation zu den Spieler zu setzten.
	
	self.Enemy:setRotation(0, 0, rightRotation);	
end

function EnemyServerManager:Fighting()

	enemyPos		= {getElementPosition(self.Enemy)};
	playerPos	 	= {getElementPosition(self.Player)};
		
	isLineOfSightClearEnemy(self, self.Enemy, enemyPos[1], enemyPos[2], enemyPos[3]);	-- Abfragen ob was im weg ist clientseitige Abfrage
	
	if(self.isLineClear	== true)then 															-- Wurde in die self gepackt.
		if(getDistanceBetweenPoints2D(enemyPos[1], enemyPos[2], playerPos[1], playerPos[2]) < 20)then
			if(getDistanceBetweenPoints2D(enemyPos[1], enemyPos[2], playerPos[1], playerPos[2]) < 15)then
					
				setEnemyAimTarget(self.Enemy, playerPos[1], playerPos[2], playerPos[3]);
				self.Enemy:setAnimation(false);											 -- Animation stoppen.
				setEnemyAimWeapon(self.Enemy, true);									 -- Er soll Zielen.
				setWeaponAmmo(self.Enemy, self.EnemyWeapon, 9999, 30);		    		 -- Muss gemacht werden da anscheind MTA da ein bug hat.
				triggerClientEvent(getRootElement(), "setClientEnemyShoot", self.Enemy); -- Schießen.
				
			else
				-- WALK TO PLAYER
				setEnemyAimWeapon(self.Enemy, false);			-- Wen er zielt nicht mehr ziehlen.
				self.Enemy:setAnimation("ped", "WALK_gang1");	-- Ped die Animation zum normalen laufen.
			end
		else
			-- RUN TO PLAYER 
			setEnemyAimWeapon(self.Enemy, false);				-- Wen er zielt nicht mehr ziehlen.
			self.Enemy:setAnimation("ped", "run_gang1");		-- Renn Animation.
		end
	else
		self.Enemy:setAnimation(false);								  -- Animation stoppen wen er eine macht.
		setEnemyAimWeapon(self.Enemy, false);						  -- Wen er zielt nicht mehr ziehlen.
		triggerClientEvent(getRootElement(), "EnemyJump", self.Enemy) -- Funktionsaufruf-Client Ped Springen lassen.
	end
	self.EnemyFightTimer  = setTimer(function(...) self:Fighting(...) end, 500, 1);
end

function EnemyServerManager:SpawnEnemy(client, classInheritance)
	
	
	if(#classInheritance.ClientEnemys <= classInheritance.MaxEnemysSpawnForPlayer)then	-- Abfragen wie viele schon Gespawnt sind und ob es unter dem Maximal Limit ist.
	
		local self				    = {};						-- Tabelle erstellen.
		setmetatable(self, {__index = EnemyServerManager});		-- metatable auf die Geerbte EnemyServerManager Klasse setzten.
		
		clientPos	   			    = {getElementPosition(client)};	-- Abfragen der Position in Tabellen Form.
		spawnPos					= calculateRandomPositionToPlayer(clientPos[1], clientPos[2], clientPos[3]); -- Funktionsaufruf Damit der Ped ein wenig random weg spawnt
		
		self:RandomEnemySkin();   								-- Skin intialiserung..
		self:RandomEnemyWeapon(); 								-- Weapon intialiserung..
		
		
		self.Enemy 		  			= createPed(self.EnemySkin, spawnPos[1], spawnPos[2], spawnPos[3]);	-- Enemy erstellen.
		giveWeapon(self.Enemy, self.EnemyWeapon, 9999);     											-- Enemy eine Waffe geben.
		setPedStat(self.Enemy, 69, 1000);
		setPedStat(self.Enemy, 72, 1000);
		setPedStat(self.Enemy, 77, 1000);
		setPedStat(self.Enemy, 78, 1000);
		
		addEventHandler("onPedWasted", self.Enemy, function(...) self:EnemyWasted(...) end); -- Fügen die Klasse hinzu wen der Ped Stirbt.
		
		self:SetEnemyPlayer(client);							-- Der Klasse vom Enemy den Spieler setzten.
		classInheritance:SetEnemy(self.Enemy);					-- Der Geerbtenober Klasse von dem Player dem Enemy setzten.
		self.classInheritancePlayer	= classInheritance;			-- Setzten in ein self verzeichnis die Player-Klasse vom Clienten.
		self:Fighting();										-- Erstellen die Aktionen die der Ped machen soll.
		self.EnemyFixRotation	    = setTimer(function(...) self:Rotation(...) end, 50, -1); -- Einen Timer der die Rotation vom Ped festlegt zum Spieler.
		
		return self;											-- Klasse wiedergeben zu der Player Klasse.
	end
	return "FULL";
end

