
MySQL		  = {};
MySQL.__index = MySQL;

MySQLSettings      = {
	["queryAttemps"] = 10	-- Wie oft ein Query ausgefuert werden soll bis er abbricht.
}

function MySQL:createConnection(typ, database, host, username, password, datachar)	-- Neue Connection: [connection] = MySQL:createConnection(typ = "mysql" or "sqlite", database = "datenbankName", username = "datenbankUsername", password = "datenbankPassword", datachar = "share=0" or "share=1")

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


function MySQL:setDatabaseQuery(DatabaseTable, DatabaseColumn, SetColumnRow, WhereBlock, WhereElement)	-- Beispiel: MySQL:setDatabaseQuery("userdata", "name", "MulTi", "name", "Hans") -- Er ändert den Namen von Hans in MulTi 
	
	assert(DatabaseTable,  "MySQL-Klasse(setDatabaseQuery(...)): DatabaseTable is nil or false!");
	assert(DatabaseColumn, "MySQL-Klasse(setDatabaseQuery(...)): DatabaseColumn is nil or false!");
	assert(SetColumnRow,   "MySQL-Klasse(setDatabaseQuery(...)): SetColumnRow is nil or false!");
	assert(WhereBlock, 	   "MySQL-Klasse(setDatabaseQuery(...)): WhereBlock is nil or false!");
	assert(WhereElement,   "MySQL-Klasse(setDatabaseQuery(...)): WhereElement is nil or false!");
	
	self.tempQuery = self.Connection:query("UPDATE "..DatabaseTable.." SET '"..DatabaseColumn.."' = '"..SetColumnRow.."' WHERE "..WhereBlock.." = '"..WhereElement.."'");
	
	if(self.tempQuery)then
		outputServerLog("MySQL-Klasse(setDatabaseQuery(...)): Query wurde erfolgreich ausgefuert!");
	else
		outputServerLog("MySQL-Klasse(setDatabaseQuery(...)): Query wurde fehlerhaft ausgefuert!");
	end
end


function MySQL:getDatabaseQuery(DatabaseTable, DatabaseColumn, WhereBlock, WhereElement)	-- Beispiel: MySQL:getDatabaseQuery("userdata", "name", "money", "MulTi") -- WIe fragen vom Spieler MulTi das Geld über den Namen von ihm ab.
	
	assert(DatabaseTable,  "MySQL-Klasse(getDatabaseQuery(...)): DatabaseTable is nil or false!");
	assert(DatabaseColumn, "MySQL-Klasse(getDatabaseQuery(...)): DatabaseColumn is nil or false!");
	assert(WhereBlock, 	   "MySQL-Klasse(getDatabaseQuery(...)): WhereBlock is nil or false!");
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


function MySQL:RunQuery(QueryString)		-- Einfache RunQuery Funktion die einen Query ueber den String ausfuehrt.
	assert(QueryString,  "MySQL-Klasse(RunQuery(...)): QueryString is nil or false!");
	
	self.tempQuery  = self.Connection:query(QueryString);
	self.tempResult = self.tempQuery:poll(MySQLSettings["queryAttemps"] or -1);
	
	return self.tempResult;
end
