local dbConnection = dbConnect("mysql", "dbname=youtube;host=localhost", "root", "");

if dbConnection then
	outputDebugString("Connection war Erfolgreich!");
else
	outputDebugString("Connection war nicht Erfolgreich!");
end

function dbConnectionSetQuery(player, block, var)
	if(player and isElement(player))then
		local query = dbQuery(dbConnection, "UPDATE userdata SET '"..block.."' = '"..var.."' WHERE Username = '"..getPlayerName(player).."'");
		if query then
			return true
		end
		outputDebugString("Error executing the query ("..query..")");
	end
end

function dbConnectionGetQuery(player, block)
	if(player and isElement(player))then
		local query  = dbQuery(dbConnection, "SELECT ?? FROM userdata WHERE Username = ?", block, getPlayerName(player));
		local result = dbPoll(query, -1);
		
		if(result == nil)then
			dbFree(query)
			return false;
		else
			return result;
		end
	end
end


addCommandHandler("cmd", function(player)
	local money = dbConnectionGetQuery(player, "Money");
	
	if money then
		outputChatBox("Datenbank sagt: "..tonumber(money).."$", player);
	end
	dbConnectionSetQuery(player, "Money", 100);
end)
