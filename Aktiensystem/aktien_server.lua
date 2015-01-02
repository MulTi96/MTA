
Aktien = { -- Neue Tabellen hinzugefuegt --
	{ GoogleAktien     = { searchname = "Google" } }, 
	{ FacebookAktien   = { searchname = "Facebook" } },
	{ YahooAktien	   = { searchname = "Yahoo" } }
}

AktienVars = {}
AktienVars["Google"]     = {}
AktienVars["Facebook"]   = {}
AktienVars["Yahoo"]      = {}

local aktienRefreshTable = {} -- Table Einbauen --


local refreshCycle = 60000 -- 1 Minute

function loadAktien()
	
	for pos, table in pairs(Aktien) do 
		for table_name, data in pairs(table) do 
			
			fetchRemote("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="..data.searchname.."&callback=YAHOO.Finance.SymbolSuggest.ssCallback", function(vars, errno)
				if(errno == 0)then
				
					local json = vars;
					local json = json:gsub('YAHOO.Finance.SymbolSuggest.ssCallback', '');
					local json = json:sub(2, #json - 1);
					
					local json = fromJSON(json);
					
					for _, variable in pairs(json["ResultSet"]["Result"]) do 
					
						
						if not(variable["exchDisp"] == "NASDAQ" and not(AktienVars[data.searchname].exchDisp == "NASDAQ"))then 
							return
						end
						
						AktienVars[data.searchname] = {
							
								searchname = data.searchname,
								fullname   = variable["name"],
								symbol     = variable["symbol"],
								exchDisp   = variable["exchDisp"]
							
						}
						
						local tableVars = AktienVars[data.searchname];
						
						dataurl   = "http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22"..tableVars.symbol.."%22%29&format=json&env=store://datatables.org/alltableswithkeys"
					

						fetchRemote(dataurl, function(callback_data, callback_errno)
						
							if(callback_errno == 0)then
							
								local json = callback_data;
								local json = fromJSON(json);
								
								json_data = json["query"]["results"]["quote"];
								
								AktienVars[data.searchname] = {
								
									Name     			 = tableVars.fullname,
									Symbol       		 = json_data["Symbol"],
									LastTradePriceOnly   = json_data["LastTradePriceOnly"],
									ChangeAktienProzent  = json_data["PercentChange"],
									Change_PercentChange = json_data["Change_PercentChange"], -- Einbauen
									
								}
								aktienRefreshTable[json_data["Symbol"]]						     = {}								  -- Einbauen 
								aktienRefreshTable[json_data["Symbol"]]["LastTradePriceOnly"] 	 = json_data["LastTradePriceOnly"];    -- Einbauen 
								aktienRefreshTable[json_data["Symbol"]]["PercentChange"] 	     = json_data["PercentChange"];	      -- Einbauen 
								aktienRefreshTable[json_data["Symbol"]]["Change_PercentChange"]  = json_data["Change_PercentChange"]; -- Einbauen 
							
								AktienVars[data.searchname].RefreshTimer = setTimer(refreshAktien, refreshCycle, -1, data.searchname);
								
							end
						end, "", false, getRootElement());
					end
				end
			end, "", false, getRootElement())
		end
	end
end
loadAktien();



-- New PayAktie Funktion --
addEvent("payAktie", true)
addEventHandler("payAktie", root, function(player, unternehmen, price, prozent, aktien)
	if(getElementData(player, unternehmen))then
		if(getElementData(player, unternehmen) >= aktien)then
			local opr;
			local aktienprice = price;
			local aktienprozenwert;
			
			if(prozent:find('-'))then
				opr		         = prozent:sub(2,  #prozent - 1);
				aktienprozenwert = ((price*opr)/100);
				aktienprice      = price*aktien - aktienprozenwert;
			elseif(prozent:find('+'))then
				opr 		     = prozent:sub(2, #prozent - 1);
				aktienprozenwert = ((price*opr)/100);
				aktienprice      = price*aktien + aktienprozenwert;
			end 
			
			outputChatBox("Der Aktienwert mit Prozent zurechnung Beträgt: "..aktienprice, player, 0, 125, 0);
			outputChatBox("Du hast nun eine Aktie verkauft fuer "..aktienprice.."$", player, 0, 125, 0);
			
			setPlayerMoney(player, getPlayerMoney(player) + aktienprice);
			
			setElementData(player, unternehmen, getElementData(player, unternehmen) - aktien);
		else
			outputChatBox("Du hast nicht soviele Aktien!", player, 255, 0, 0);
		end
	else
		outputChatBox("Du hast keine Aktien von "..unternehmen.."!", player, 255, 0, 0);
	end
end)
--------------------------------------------------------------------------------------
 
 
-- New BuyAktie Funktion --
addEvent("buyAktie", true)
addEventHandler("buyAktie", root, function(player, unternehmen, price, prozent, aktien)
	
	local opr;
	local aktienprice = price;
	local aktienprozenwert;
	
	if(prozent:find('+'))then -- Aufgrund desen könnte man Geldbuggen da wen man sie für 500$ kauft und der prozentwert +0,25% ist mehr wieder bekommt als der wert beträgt.
		opr 		     = prozent:sub(2, #prozent - 1);
		aktienprozenwert = ((price*opr)/100);
		aktienprice      = price*aktien + aktienprozenwert;
	end 
	
	if(getPlayerMoney(player) >= aktienprice)then
		if not getElementData(player, unternehmen) then
			setElementData(player, unternehmen, aktien);
		else
			setElementData(player, unternehmen, getElementData(player, unternehmen) + aktien);
		end
		setPlayerMoney(player, getPlayerMoney(player) - aktienprice);
		outputChatBox("Du hast dir "..aktien.." "..unternehmen.." Aktie/n gekauft!", player, 0, 125, 0);
	else
		outputChatBox("Nicht genug Geld für "..aktien.." Aktien dir fehlen: "..aktienprice - getPlayerMoney(player).."$", player, 200, 0, 0);
	end
end)
--------------------------------------------------------------------------------------

function loadServerAktien(player)	
	triggerClientEvent(player, "loadClientGUIAktien", player, AktienVars);
end
addEvent("loadAktienServer", true)	
addEventHandler("loadAktienServer", root, loadServerAktien)


function getSymbolName(player, cmd, searchname)
	fetchRemote("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="..searchname.."&callback=YAHOO.Finance.SymbolSuggest.ssCallback", function(vars, errno)
		if(errno == 0)then
			local json = vars;
			local json = json:gsub('YAHOO.Finance.SymbolSuggest.ssCallback', '');
			local json = json:sub(2, #json - 1);
			
			local json = fromJSON(json);
			
			for _, variable in pairs(json["ResultSet"]["Result"]) do 
				outputChatBox("Symbol-Name: "..variable["symbol"], player, 125, 125, 0);
				break;
			end
		else
			outputChatBox("Firma nicht gefunden!", player, 125, 0, 0);
		end
	end, "", false, getRootElement());
end
addCommandHandler("getSymbolName", getSymbolName);


function refreshAktien(searchname)

	local Symbol 			   = AktienVars[searchname].Symbol;
	local Name   			   = AktienVars[searchname].Name;
	
	setAktienData(Symbol, "LastTradePriceOnly");
	setAktienData(Symbol, "PercentChange");
	setAktienData(Symbol, "Change_PercentChange");
	
	LastTradePriceOnly    = aktienRefreshTable[Symbol]["LastTradePriceOnly"];
	ChangeAktienProzent   = aktienRefreshTable[Symbol]["PercentChange"];
	Change_PercentChange  = aktienRefreshTable[Symbol]["Change_PercentChange"]; -- Einbauen
	

	AktienVars[searchname] = {
	
		Name  			     = Name,
		Symbol			     = Symbol,
		LastTradePriceOnly   = LastTradePriceOnly,
		ChangeAktienProzent  = ChangeAktienProzent,
		Change_PercentChange = Change_PercentChange, -- Einbauen
	}
	triggerClientEvent(root, "refreshClientAktienTable", root, AktienVars);
	outputDebugString("Aktien-Unternehmen: "..Name.." Tabelle wurde Aktuallisiert."); -- Lediglich eine Debug-Ausgabe.
end


function setAktienData(symbol, variable)	-- Grund dafür da fetchRemote zeit verzoergrung hat und die Funktion trotzdem was return und das ist nil
		
	assert(symbol,   "@function getAktienData(...): Symbol is not a string!");
	assert(variable, "@function getAktienData(...): variable is not a string!");
	
	-- Funktion so umstellen --
	local dataurl    = "http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22"..(symbol).."%22%29&format=json&env=store://datatables.org/alltableswithkeys"
	fetchRemote(dataurl, function(data, errno)
		
		if(errno == 0)then
		
			local json  = fromJSON(data);
			json_object = json["query"]["results"]["quote"];
			
			aktienRefreshTable[symbol][variable] = json_object[variable];	-- So abspeichern --
		end
	end, "", false, getRootElement());
end
