
MySQL		  = {};
MySQL.__index = MySQL;

MySQLSettings      = {
	["queryAttemps"] = 10	-- Wie oft ein Query ausgefuert werden soll bis er abbricht.
}

function MySQL:createConnection(typ, database, host, username, password, datachar)

	local self 					= {};
	setmetatable(self, {__index = MySQL});
	
	self.Connection 			= dbConnect(typ or "mysql", "dbname="..database..";host="..host, username, password, datachar or "share=1");
	
	if self.Connection then
		outputServerLog("Eine neue Verbindung wurde in der MySQL-Klasse erstellt!");
	else
		outputServerLog("Eine neue Fehlerhafte Verbindung wurde in der MySQL-Klasse erstellt!");
	end
	
	return self;
end
dbConnection = MySQL:createConnection("mysql", "localhost", "root", "test123", "share=1") -- Beispiel Connection.


function MySQL:setDatabaseQuery(DatabaseTable, DatabaseColumn, SetColumnRow, WhereBlock, WhereElement)	
	
	assert(DatabaseTable,  "MySQL-Klasse(setDatabaseQuery(...)): DatabaseTable is nil or false!");
	assert(DatabaseColumn, "MySQL-Klasse(setDatabaseQuery(...)): DatabaseColumn is nil or false!");
	assert(SetColumnRow,   "MySQL-Klasse(setDatabaseQuery(...)): SetColumnRow is nil or false!");
	assert(WhereBlock,     "MySQL-Klasse(setDatabaseQuery(...)): WhereBlock is nil or false!");
	assert(WhereElement,   "MySQL-Klasse(setDatabaseQuery(...)): WhereElement is nil or false!");
	
	self.tempQuery = self.Connection:query("UPDATE "..DatabaseTable.." SET '"..DatabaseColumn.."' = '"..SetColumnRow.."' WHERE "..WhereBlock.." = '"..WhereElement.."'");
	
	if(self.tempQuery)then
		outputServerLog("MySQL-Klasse(setDatabaseQuery(...)): Query wurde erfolgreich ausgefuert!");
	else
		outputServerLog("MySQL-Klasse(setDatabaseQuery(...)): Query wurde fehlerhaft ausgefuert!");
	end
end


function MySQL:getDatabaseQuery(DatabaseTable, DatabaseColumn, WhereBlock, WhereElement)	
	
	assert(DatabaseTable,  "MySQL-Klasse(getDatabaseQuery(...)): DatabaseTable is nil or false!");
	assert(DatabaseColumn, "MySQL-Klasse(getDatabaseQuery(...)): DatabaseColumn is nil or false!");
	assert(WhereBlock,     "MySQL-Klasse(getDatabaseQuery(...)): WhereBlock is nil or false!");
	assert(WhereElement,   "MySQL-Klasse(getDatabaseQuery(...)): WhereElement is nil or false!");
	
	self.tempQuery  = self.Connection:query("SELECT ?? FROM "..DatabaseTable.." WHERE "..DatabaseColumn.." = ?", WhereBlock, WhereElement)
	self.tempResult = self.tempQuery:poll(MySQLSettings["queryAttemps"] or -1); 
	
	if(self.tempResult == nil)then
		dbFree(self.tempQuery);
		outputServerLog("MySQL-Klasse(getDatabaseQuery(...)): Query wurde fehlerhaft ausgefuert!");
	else
		return self.tempResult;
	end
	return nil;
end


function MySQL:RunQuery(QueryString)		
	assert(QueryString,  "MySQL-Klasse(RunQuery(...)): QueryString is nil or false!");
	
	self.tempQuery  = self.Connection:query(QueryString);
	self.tempResult = self.tempQuery:poll(MySQLSettings["queryAttemps"] or -1);
	
	return self.tempResult;
end


--[[
	Erklärung:
	
	- [class]:createConnection(...)
	-> Baut eine einfache Conneacton auf.
	
	- [class]:getDatabaseQuery(DatabaseTable, DatabaseColumn, WhereBlock, WhereElement)
	-> DatabaseTable:  Die Tabelle wie z.B "userdata"
	-> DatabaseColumn: Über was wir Abfrage wie z.B "name"
	-> WhereBlock:     Die Spalte was wir haben wollen wie z.B "money"
	-> WhereElement:   Worüber mit DatabaseColumn zugreifen und vergleichen wie z.B "MulTi"
	-> Wie fragen also ab wie viel Geld der Spieler mit den Namen MulTi hat.
	
	- [class]:setDatabaseQuery(DatabaseTable, DatabaseColumn, SetColumnRow, WhereBlock, WhereElement)
	-> DatabaseTable:  Die Tabelle wie z.B "userdata"
	-> DatabaseColumn: Über was wir es setzten wollen wie z.B "name"
	-> SetColumnRow:   Was wir setzten wollen.
	-> WhereBlock:     Von welcher spalte es wir ändern wie z.B "name"
	-> WhereElement:   Von oben DatabaseColumn die Abfrage in unseren fall wollen wir es z.B von "MulTi" ändern.
	
	- [class]:RunQuery(QueryString)
	-> Führt einen einfachen Query aus.
	
	
	
	Beispiele:
	Connection erstellen:      [class]:createConnection(...)
	Geld ausgeben vom Spieler: [class]:getDatabaseQuery("userdata", "name", "money", "MulTi")
	Namen ändern vom Spieler:  [class]:setDatabaseQuery("userdata", "name", "MulTi", "name", "Hans")
]]
